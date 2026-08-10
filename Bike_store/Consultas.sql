-- CONSULTAS BASICAS
SELECT * FROM staff;
SELECT * FROM ordenes;
SELECT * FROM clientes;
SELECT * FROM orden_item;


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
GROUP BY "Cliente"
ORDER BY "Cantidad Total Gastado" DESC;