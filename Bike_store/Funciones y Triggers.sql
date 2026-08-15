-- FUNCION PARA TRADUCIR EL ESTADO ACTUAL DE LA ORDEN DE UN CLIENTE
CREATE OR REPLACE FUNCTION fn_estado_orden(
	num_estado NUMERIC
)
RETURNS TEXT AS $$
DECLARE
	estado TEXT;
BEGIN
	CASE
		WHEN num_estado = 1 THEN
			estado = 'Pendiente';
		WHEN num_estado = 2 THEN 
			estado = 'Procesando';
		WHEN num_estado = 3 THEN 
			estado = 'Rechazado';
		ELSE 
			estado = 'Completado';
	END CASE;

	RETURN estado;
END
$$
LANGUAGE plpgsql;

-- FUNCION PARA IMPEDIR QUE UN USUARIO ELIMINE DATOS DE LA TABLA PRODUCTOS
CREATE OR REPLACE FUNCTION fn_prevenir_delete()
RETURNS TRIGGER
AS
$$
BEGIN
	-- Mensaje cuando se detecte un DELETE en la tabla
	RAISE EXCEPTION 'Eliminar de la tabla PRODUCTOS no esta permitido';
END;
$$
LANGUAGE plpgsql;

-- TRIGGER QUE EJECUTA LA FUNCION "fn_prevenir_delete" AL DETECTAR UNA CONSULTA DELETE EN LA TABLA  PRODUCTOS
CREATE TRIGGER no_eliminar_productos
BEFORE DELETE ON productos
FOR EACH ROW
EXECUTE FUNCTION fn_prevenir_delete();

DELETE FROM productos;

-- FUNCION PARA EVITAR QUE UN USUARIO ELIMINE TODOS LOS REGISTROS DE LA TABLA CLIENTE
-- La finalidad es prevenir que realicen " DELETE FROM clientes "
CREATE OR REPLACE FUNCTION fn_no_eliminar_todos()
RETURNS TRIGGER
AS
$$
DECLARE
	total_rows INT;

BEGIN
	SELECT COUNT(*) INTO total_rows FROM clientes;

	-- Si la consulta del DELETE deja vacio la tabla clientes, activa el RAISE EXCEPTION
	IF total_rows = 0 THEN
		-- Anula la transaccion
		RAISE EXCEPTION 'ADVERTENCIA: Ejecutaste un DELETE que elimina todas las filas de la tabla CLIENTES';
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;

-- TRIGGER QUE EJECUTA LA FUNCION " fn_no_eliminar_todos " DESPUES DE UNA CONSULTA DELETE EN LA TABLA CLIENTES.
CREATE TRIGGER no_eliminar_todos
AFTER DELETE ON clientes FOR EACH STATEMENT
EXECUTE FUNCTION fn_no_eliminar_todos();

DELETE FROM clientes;
SELECT * FROM clientes;

-- CREACION DE TABLA QUE REGISTRA LA ACTIVIDAD DE LOS USUARIOS (No se relaciona con la temática de las bicicletas)
CREATE TABLE actividad(
	usuario VARCHAR(250) not null,
	fecha DATE not null,
	hora TIME not null,
	consulta TEXT not null
);

-- FUNCION PARA ALMACENAR FECHA Y HORA DE CUALQUIER CONSULTA APLICADA POR UN USUARIO
CREATE OR REPLACE FUNCTION fn_detectar_actividad()
RETURNS TRIGGER
AS
$$
DECLARE
	nombre_usuario VARCHAR(250) := USER;
	fecha_actual DATE := current_date;
	hora_actual TIME := current_time;
	consulta TEXT := current_query();

BEGIN
	INSERT INTO actividad VALUES(nombre_usuario, fecha_actual, hora_actual, consulta);
	RETURN NEW;
END
$$
LANGUAGE plpgsql;

-- TRIGGER: ACTIVA LA FUNCION DESPUES DE UNA CONSULTA A LA TABLA TIENDAS.
drop trigger IF EXISTS user_activity ON tiendas;
CREATE TRIGGER user_activity
AFTER INSERT OR UPDATE OR DELETE ON tiendas
FOR EACH ROW
EXECUTE PROCEDURE fn_detectar_actividad();

INSERT INTO tiendas VALUES(4, 'Tienda Bicicleta', '123456897', NULL, 'Armando Casas 001', 'Nueva York', 'NY', NULL);
SELECT * FROM actividad