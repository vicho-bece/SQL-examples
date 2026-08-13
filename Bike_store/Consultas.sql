-- CONSULTAS BASICAS
SELECT * FROM staff;
SELECT * FROM ordenes;
SELECT * FROM clientes;
SELECT * FROM orden_item;
SELECT * FROM tiendas;
SELECT * FROM categorias;
SELECT * FROM productos;
SELECT * FROM marcas;


-- Cantidad total de productos vendidas segun la tabla orden_item

SELECT 
	SUM(item_cantidad)
FROM orden_item;

SELECT 
	ciudad_cliente as "Ciudad",
	COUNT(*) as "Cantidad de Clientes"
FROM clientes
GROUP BY "Ciudad"
ORDER BY "Cantidad de Clientes" DESC;

-- CANTIDAD DE ORDENES SEGUN EL STAFF ASIGANDO

SELECT 
	s.nombre_staff as "Nombre del Staff", 
	COUNT(*) as "Cantidad de Ordenes Asignadas"
FROM staff as s
INNER JOIN ordenes as o 
ON o.id_orden_staff = s.id_staff
GROUP BY s.nombre_staff;

-- PRECIO TOTAL DE CADA ORDEN

SELECT 
	id_orden_item AS "Número de Orden", 
	SUM(precio_total) as "Precio Total"
FROM orden_item
GROUP BY id_orden_item
ORDER BY id_orden_item;

-- TOP 3: PRODUCTOS MAS VENDIDAS EN RELACION A CANTIDAD
SELECT 
	p.nombre_producto AS "Nombre del Producto",
	SUM(o.item_cantidad) AS "Cantidad Total Vendida"
FROM productos as p
INNER JOIN orden_item as o
ON o.id_item_producto = id_producto
GROUP BY p.nombre_producto
ORDER BY "Cantidad Total Vendida" DESC
LIMIT 3;

-- Registro de dinero gastado en compras de cada cliente

SELECT
	CONCAT(c.nombre_cliente, ' ', c.apellido_cliente) as "Cliente",
	SUM(i.precio_total) AS "Cantidad Total Gastado"
FROM clientes as c
INNER JOIN ordenes as o ON c.id_cliente = o.id_orden_cli
INNER JOIN orden_item as i ON i.id_orden_item = o.id_orden
GROUP BY c.id_cliente, c.nombre_cliente, c.apellido_cliente
ORDER BY "Cantidad Total Gastado" DESC;

-- Cantidades vendidas segun la tienda

SELECT 
	t.nombre_tienda as "Nombre de la Tienda",
	SUM(i.item_cantidad) as "Cantidades Vendidas"
FROM tiendas as t
INNER JOIN ordenes as o ON o.id_orden_tienda = t.id_tienda
INNER JOIN orden_item as i ON i.id_orden_item = o.id_orden
GROUP BY "Nombre de la Tienda"
ORDER BY "Cantidades Vendidas" DESC;


-- Cantidades Vendidas por categorias de Bicicletas

SELECT 
	c.nombre_categoria as "Categoria de Bicicleta",
	SUM(o.item_cantidad) as "Cantidades Vendidas"
FROM categorias as c	
INNER JOIN productos as p ON p.id_prod_categoria = c.id_categoria
INNER JOIN orden_item as o ON o.id_item_producto = p.id_producto
GROUP BY "Categoria de Bicicleta"
ORDER BY "Cantidades Vendidas" DESC;

-- CTE: tabla temporal para obtener el ranking de los productos con más recaudados de cada marca.
WITH prod_vendidos AS (
	SELECT
		RANK() OVER(PARTITION BY m.nombre_marca ORDER BY SUM(o.precio_total) DESC) AS "rank",
		m.nombre_marca AS "Marca",
		p.nombre_producto AS "Producto",
		SUM(o.precio_total) AS "Dinero Ganado"
	FROM marcas as m
	INNER JOIN productos as p ON p.id_prod_marca = m.id_marca
	INNER JOIN orden_item as o ON o.id_item_producto = p.id_producto
	GROUP BY "Marca", "Producto"
)

-- Consulta para obtener el TOP N de los productos con más recaudaciones de cada marca.
SELECT
	"Marca",
	"Producto",
	"Dinero Ganado"
FROM prod_vendidos
WHERE "rank" <= 3;

-- CTE: tabla temporal para obtener el ranking de las ciudad/estado con más compras realizadas
WITH clientes_ordenes AS (
	SELECT
		RANK() OVER(PARTITION BY c.estado_cliente ORDER BY COUNT(o.id_orden) DESC) AS "rank",
		c.estado_cliente AS "Estado",
		c.ciudad_cliente AS "Ciudad",
		COUNT(o.id_orden) AS "Compras"
	FROM clientes AS c
	INNER JOIN ordenes AS o ON o.id_orden_cli = c.id_cliente
	GROUP BY "Estado",  "Ciudad"
)

-- Consulta para obtener el TOP N de las ciudad/estado con más compras realizadas
SELECT
	"Estado",
	"Ciudad",
	"Compras"
FROM clientes_ordenes
WHERE "rank" <= 3;