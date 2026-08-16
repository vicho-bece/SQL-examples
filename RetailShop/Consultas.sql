-- CONSULTA SELECCIONAR TODAS LAS COLUMNAS
SELECT * FROM CLIENTES;
SELECT * FROM PRODUCTOS;
SELECT * FROM ORDENES;

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