-- CONSULTA SELECCIONAR TODAS LAS COLUMNAS
SELECT * FROM CLIENTES;
SELECT * FROM PRODUCTOS;
SELECT * FROM ORDENES ORDER BY fecha_orden;

-- OBTENER EL NÚMERO DE CLIENTES POR CIUDAD
SELECT
	ciudad_cliente AS "CIUDAD",
	COUNT(*) AS "NÚMERO DE CLIENTES"
FROM CLIENTES
GROUP BY ciudad_cliente;

-- OBTENER EL NÚMERO DE CLIENTES POR SU GÉNERO
SELECT
	genero_cliente AS "SEXO",
	COUNT(*) AS "NÚMERO DE CLIENTES"
FROM CLIENTES
GROUP BY genero_cliente;

-- OBTENER LA CANTIDAD DE PRODUCTOS POR CATEGORIA
SELECT
	categoria_producto AS "CATEGORIA",
	COUNT(*) AS "CANTIDAD DE PRODUCTOS"
FROM PRODUCTOS
GROUP BY categoria_producto;

-- OBTENER EL NÚMERO DE PAGOS EFECTUADOS POR SU METODO
SELECT
	metodo_orden AS "METODO DE PAGO",
	COUNT(*) AS "CANTIDAD REGISTRADA"
FROM ORDENES
GROUP BY metodo_orden;

-- OBTENER LAS CIUDADES DE LOS CLIENTES SIN REPETIR VALORES
SELECT DISTINCT 
	ciudad_cliente
FROM CLIENTES;

-- OBTENER EL NÚMERO DE CLIENTES POR SU CIUDAD SEPARANDO POR SU GENERO
SELECT 
	genero_cliente,
	[Liverpool] AS Liverpoll,
	[London] AS London,
	[Bristol] AS Bristol,
	[Nottingham] AS Nottingham,
	[Sheffield] AS Sheffield,
	[Birmingham] AS Birmingham,
	[Manchester] AS Manchester,
	[Leeds] AS Leeds
FROM
( 
	SELECT 
		genero_cliente, 
		ciudad_cliente,
		id_cliente
	FROM CLIENTES
) p
PIVOT
(
	COUNT(id_cliente)
	FOR ciudad_cliente IN ([Liverpool], [London], [Bristol], [Nottingham], [Sheffield], [Birmingham], [Manchester], [Leeds])
) AS pvt;


-- OBTENER LOS VALORES UNICOS DE CATEGORIAS DE PRODUCTOS
SELECT DISTINCT categoria_producto
FROM PRODUCTOS;


-- OBTENER EL REGISTRO DE UNIDADES VENDIDAS POR SU CATEGORIAS EN FECHAS REGISTRADAS
SELECT 
	fecha_orden,
	[Beauty] AS Beauty,
	[Clothing] AS Clothing,
	[Electronics] AS Electronics,
	[Home] AS Home,
	[Sports] AS Sports
FROM
( 
	SELECT 
		O.fecha_orden as Fecha_orden, 
		P.categoria_producto as Categorias,
		O.cantidad_prod as Cantidad
	FROM ORDENES AS O
	INNER JOIN PRODUCTOS AS P ON P.id_producto = O.ref_producto
) p
PIVOT
(
	SUM(Cantidad)
	FOR Categorias IN ([Beauty], [Clothing], [Electronics], [Home], [Sports])
) AS pvt ORDER BY Fecha_orden;



-- OBTENER EL REGISTRO DE LAS GANANCIAS POR SU CATEGORIAS CADA MES
-- APLICANDO EL FILTRO DEL AÑO
SELECT 
	Mes,
	[Beauty] AS Beauty,
	[Clothing] AS Clothing,
	[Electronics] AS Electronics,
	[Home] AS Home,
	[Sports] AS Sports
FROM
( 
	SELECT 
		MONTH(O.fecha_orden) AS NumMes,
		DATENAME(MONTH, DATEFROMPARTS(2000, MONTH(O.fecha_orden), 1)) as Mes, 
		P.categoria_producto as Categorias,
		(O.cantidad_prod * P.precio_producto) as Ganancias
	FROM ORDENES AS O
	INNER JOIN PRODUCTOS AS P ON P.id_producto = O.ref_producto
	WHERE YEAR(O.fecha_orden) = '2024'
) p
PIVOT
(
	SUM(Ganancias)
	FOR Categorias IN ([Beauty], [Clothing], [Electronics], [Home], [Sports])
) AS pvt ORDER BY NumMes;