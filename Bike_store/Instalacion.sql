
CREATE TABLE marcas(
	id_marca integer not null,
	nombre_marca varchar(20) not null,

	constraint Marcas_pk primary key(id_marca)
);


COPY marcas(id_marca, nombre_marca)
FROM 'xxx\brands.csv' -- Coloque aqui la ubicaciòn del archivo csv
DELIMITER ','
CSV HEADER;


CREATE TABLE categorias(
	id_categoria integer not null,
	nombre_categoria varchar(25) not null,

	constraint Categorias_pk primary key(id_categoria)
)


COPY categorias(id_categoria, nombre_categoria)
FROM 'xxx\categories.csv' -- Coloque aqui la ubicaciòn del archivo csv
DELIMITER ','
CSV HEADER;


CREATE TABLE clientes(
	id_cliente integer not null,
	nombre_cliente varchar(30) not null,
	apellido_cliente varchar(30) not null,
	telefono_cliente varchar(15),
	email_cliente varchar(100),
	direccion_cliente varchar(50) not null,
	ciudad_cliente varchar(30) not null,
	estado_cliente varchar(3) not null,
	codigo_zip integer,

	constraint Clientes_pk primary key (id_cliente),
	constraint chk_email_cus check (email_cliente is null or email_cliente like '%_@%_.%_')
);

COPY clientes(
	id_cliente, 
	nombre_cliente,
	apellido_cliente,
	telefono_cliente,
	email_cliente,
	direccion_cliente,
	ciudad_cliente,
	estado_cliente,
	codigo_zip)
FROM 'xxx\customers.csv' -- Coloque aqui la ubicaciòn del archivo csv
DELIMITER ','
CSV HEADER;


CREATE TABLE tiendas(
	id_tienda integer not null,
	nombre_tienda varchar(20) not null,
	telefono_tienda varchar(15) not null,
	email_tienda varchar(100),
	direccion_tienda varchar(50) not null,
	ciudad_tienda varchar(30) not null,
	estado_tienda varchar(3) not null,
	cod_zip_tienda integer,

	constraint Tiendas_pk primary key(id_tienda),
	constraint chk_email_shop check (email_tienda is null or email_tienda like '%_@%_.%_')
);

COPY tiendas(
	id_tienda, 
	nombre_tienda,
	telefono_tienda,
	email_tienda,
	direccion_tienda,
	ciudad_tienda,
	estado_tienda,
	cod_zip_tienda
)
FROM 'xxx\stores.csv' -- Coloque aqui la ubicaciòn del archivo csv
DELIMITER ','
CSV HEADER;

CREATE TABLE staff(
	id_staff int not null,
	nombre_staff varchar(30) not null,
	apellido_staff varchar(30) not null,
	email_staff varchar(100),
	telefono_staff varchar(15) not null,
	activo_staff smallint not null,
	id_tienda_staff integer,
	id_admin int,

	constraint Staffs_pk primary key(id_staff),
	
	constraint chk_email_staff check (email_staff is null or email_staff like '%_@%_.%_'),

	constraint fk_id_tienda foreign key (id_tienda_staff) references tiendas (id_tienda),
	constraint fk_id_ADMIN foreign key (id_admin) references staff (id_staff) ON DELETE NO ACTION ON UPDATE NO ACTION
);


COPY staff(
	id_staff,
	nombre_staff,
	apellido_staff,
	email_staff,
	telefono_staff,
	activo_staff,
	id_tienda_staff,
	id_admin
)
FROM 'xxx\staffs.csv' -- Coloque aqui la ubicaciòn del archivo csv
DELIMITER ','
CSV HEADER
NULL 'NULL';

CREATE TABLE productos(
	id_producto integer not null,
	nombre_producto varchar(100) not null,
	id_prod_marca integer not null,
	id_prod_categoria integer not null,
	id_modelo integer not null,
	precio float not null,

	constraint Producto_pk primary key (id_producto),

	constraint fk_prod_marca foreign key(id_prod_marca) references marcas(id_marca),
	constraint fk_prod_categoria foreign key(id_prod_categoria) references categorias(id_categoria)
	
);

COPY productos(
	id_producto,
	nombre_producto,
	id_prod_marca,
	id_prod_categoria,
	id_modelo,
	precio
)
FROM 'xxx\products.csv'  -- Coloque aqui la ubicaciòn del archivo csv
DELIMITER ','
CSV HEADER;

CREATE TABLE inventario(
	id_stock_tienda integer not null,
	id_stock_producto integer not null,
	cantidad integer not null,

	constraint fk_stock_tienda foreign key(id_stock_tienda) references tiendas(id_tienda),
	constraint fk_stock_producto foreign key(id_stock_producto) references productos(id_producto)
);

COPY inventario(
	id_stock_tienda,
	id_stock_producto,
	cantidad
)
FROM 'xxx\stocks.csv'  -- Coloque aqui la ubicaciòn del archivo csv
DELIMITER ','
CSV HEADER;

CREATE TABLE ordenes(
	id_orden integer not null,
	id_orden_cli integer not null,
	orden_estado integer not null,
	fecha_orden date not null,
	fecha_entrega date not null,
	fecha_recibo date,
	id_orden_tienda integer not null,
	id_orden_staff integer not null,

	constraint Orden_pk primary key(id_orden),

	constraint fk_orden_cliente foreign key(id_orden_cli) references clientes(id_cliente),
	constraint fk_orden_tienda foreign key(id_orden_tienda) references tiendas(id_tienda),
	constraint fk_orden_staff foreign key(id_orden_staff) references staff(id_staff)
);

COPY ordenes(
	id_orden,
	id_orden_cli,
	orden_estado,
	fecha_orden,
	fecha_entrega,
	fecha_recibo,
	id_orden_tienda,
	id_orden_staff
)
FROM 'xxx\orders.csv' -- Coloque aqui la ubicaciòn del archivo csv
DELIMITER ','
CSV HEADER
NULL 'NULL';

CREATE TABLE orden_item(
	id_orden_item integer not null,
	id_item integer,
	id_item_producto integer not null,
	item_cantidad integer,
	precio_total float,
	descuento float,

	constraint Orden_item_pk primary key(id_orden_item, id_item),

	constraint fk_orden_item foreign key(id_orden_item) references ordenes(id_orden),
	constraint fk_item_producto foreign key(id_item_producto) references productos(id_producto)
);

COPY orden_item(
	id_orden_item,
	id_item,
	id_item_producto,
	item_cantidad,
	precio_total,
	descuento
)
FROM 'xxx\order_items.csv' -- Coloque aqui la ubicaciòn del archivo csv
DELIMITER ','
CSV HEADER
NULL 'NULL';