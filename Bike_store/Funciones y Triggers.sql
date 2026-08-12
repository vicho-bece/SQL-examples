-- TRIGGER PARA IMPEDIR QUE UN USUARIO ELIMINE DATOS DE LA TABLA PRODUCTOS
CREATE OR REPLACE FUNCTION fn_prevenir_delete()
RETURNS TRIGGER
AS
$$
BEGIN
	RAISE EXCEPTION 'Eliminar de la tabla PRODUCTOS no esta permitido';
END;
$$
LANGUAGE plpgsql;


CREATE TRIGGER no_eliminar_productos
BEFORE DELETE ON productos
FOR EACH ROW
EXECUTE FUNCTION fn_prevenir_delete();

DELETE FROM productos;

CREATE OR REPLACE FUNCTION fn_no_eliminar_todos()
RETURNS TRIGGER
AS
$$
DECLARE
	total_rows INT;

BEGIN
	SELECT COUNT(*) INTO total_rows FROM clientes;

	IF total_rows = 0 THEN
		RAISE EXCEPTION 'ADVERTENCIA: Ejecutaste un DELETE que elimina todas las filas de la tabla CLIENTES';
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER no_eliminar_todos
AFTER DELETE ON clientes FOR EACH STATEMENT
EXECUTE FUNCTION fn_no_eliminar_todos();

DELETE FROM clientes;
SELECT * FROM clientes;