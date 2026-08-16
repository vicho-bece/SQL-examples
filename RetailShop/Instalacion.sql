CREATE DATABASE RetailShop;
GO

USE RetailShop;
GO


CREATE TABLE CLIENTES(
	id_cliente VARCHAR(6) NOT NULL PRIMARY KEY,
	genero_cliente VARCHAR(7),
	edad_cliente INTEGER,
	ciudad_cliente VARCHAR(20),
	fecha_registro DATE,
	leal_cliente VARCHAR(4)
);
GO

BULK INSERT CLIENTES
FROM 'XXX\customers (1).csv'
WITH (
    FORMAT = 'CSV',           -- Obligatorio para manejar comillas correctamente
    FIRSTROW = 2,             -- Omite la fila de encabezado
    FIELDQUOTE = '"',         -- CRÍTICO: Define la comilla doble como calificador de texto
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',   -- Salto de línea (LF). Usa '0x0d0a' si falla (CRLF)
    TABLOCK,
    CODEPAGE = '65001'
);

SELECT * FROM CLIENTES;

CREATE TABLE PRODUCTOS(
    id_producto VARCHAR(5) PRIMARY KEY NOT NULL,
    nombre_producto VARCHAR(25),
    categoria_producto VARCHAR(15),
    precio_producto FLOAT
);
GO

BULK INSERT PRODUCTOS
FROM 'XXX\products (1).csv'
WITH (
    FORMAT = 'CSV',           -- Obligatorio para manejar comillas correctamente
    FIRSTROW = 2,             -- Omite la fila de encabezado
    FIELDQUOTE = '"',         -- CRÍTICO: Define la comilla doble como calificador de texto
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',   -- Salto de línea (LF). Usa '0x0d0a' si falla (CRLF)
    TABLOCK,
    CODEPAGE = '65001'
);

SELECT * FROM PRODUCTOS;

CREATE TABLE ORDENES(
    id_orden VARCHAR(7) PRIMARY KEY NOT NULL,
    ref_cliente VARCHAR(6),
    ref_producto VARCHAR(5),
    fecha_orden DATE,
    cantidad_prod INTEGER,
    metodo_orden VARCHAR(7),

    CONSTRAINT FK_ID_CLIENTE FOREIGN KEY(ref_cliente) REFERENCES CLIENTES(id_cliente) ON DELETE CASCADE,
    CONSTRAINT FK_ID_PRODUCTO FOREIGN KEY(ref_producto) REFERENCES PRODUCTOS(id_producto) ON DELETE CASCADE
);
GO

BULK INSERT ORDENES
FROM 'XXX\orders (1).csv'
WITH (
    FORMAT = 'CSV',           -- Obligatorio para manejar comillas correctamente
    FIRSTROW = 2,             -- Omite la fila de encabezado
    FIELDQUOTE = '"',         -- CRÍTICO: Define la comilla doble como calificador de texto
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',   -- Salto de línea (LF). Usa '0x0d0a' si falla (CRLF)
    TABLOCK,
    CODEPAGE = '65001'
);

SELECT * FROM ORDENES;