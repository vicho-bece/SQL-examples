---
Tienda de Bicicletas
---

**Descripción**

Una Base de Datos que contiene registros de las ventas/ordenes de bicicletas de cada sucursal de esta tienda, incluyendo la información de los clientes que han comprado, el detalle de las ordenes de las compras y los productos existentes de cada marca.
La fuente de información de los archivos CSV que contiene la data, lo puede encontrar en el sitio web **KAGGLE** buscando el dataset denominado: **Bike Store Relational Database | SQL**.

**Motor de Base de Datos**

Se utilizo la Base de Datos **PostgreSQL (Versión 18)** para diseñar y ejecutar todos los comandos que se encuentran en los archivos SQL.

**Código**

En esta carpeta tiene los siguientes archivos en formato SQL:
- Instalacion: tiene los comandos para crear las tablas con su respectivas columnas, declaración de claves primarias/foráneas, revisión de formatos de correos y instrucciones en caso de que un dato se elimine o actualice. Ádemas, en las lineas con el comando **COPY** usted solo debe modificar la ruta en donde se importa el archivo CSV según la tabla que corresponda.
- Consultas: contiene consultas desde lo básico (seleccionar todas las columnas de una tabla) hasta algo en específico (cantidades vendidas por categoria, cantidad de ordenes asignadas a los staffs, cantidad de dinero gastado por clientes, entre otros.)
- Funciones y Triggers: tiene 2 funcionalidades:
  - Evita que se elimina cualquier dato de la tabla de producto
  - Evita que se elimine por completo los datos de la tabla de clientes
- Usuarios y Configuraciones: se crea 2 usuarios:
  - usuario1: puede ejecutar solamente **SELECT** en cualquier tabla de la base de datos
  - asistente1: puede ejecutar **SELECT, INSERT, UPDATE y DELETE** en cualquier tabla de la base de datos.
