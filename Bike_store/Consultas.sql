-- CONSULTAS BASICAS
SELECT * FROM staff;
SELECT * FROM ordenes;
SELECT * FROM clientes;
SELECT * FROM orden_item;
SELECT * FROM tiendas;


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

SELECT
	CONCAT(c.nombre_cliente, ' ', c.apellido_cliente) as "Cliente",
	SUM(i.precio_total) AS "Cantidad Total Gastado"
FROM clientes as c
INNER JOIN ordenes as o ON c.id_cliente = o.id_orden_cli
INNER JOIN orden_item as i ON i.id_orden_item = o.id_orden
GROUP BY c.id_cliente, c.nombre_cliente, c.apellido_cliente
ORDER BY "Cantidad Total Gastado" DESC;

SELECT 
	t.nombre_tienda as "Nombre de la Tienda",
	SUM(i.item_cantidad) as "Cantidades Vendidas"
FROM tiendas as t
INNER JOIN ordenes as o ON o.id_orden_tienda = t.id_tienda
INNER JOIN orden_item as i ON i.id_orden_item = o.id_orden
GROUP BY "Nombre de la Tienda"
ORDER BY "Cantidades Vendidas" DESC;





