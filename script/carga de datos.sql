
create database BD_e_commerce;
USE BD_e_commerce;


IF OBJECT_ID('e_commerce', 'U') IS NOT NULL
    DROP TABLE e_commerce;

CREATE TABLE e_commerce (
    -- Alfanumérico por el formato '3012-1A41'
	order_id NVARCHAR(250),
	order_date date,
	customer_id NVARCHAR(250),
	product_category NVARCHAR(250),
	region NVARCHAR(250),
	quantity integer,
	unit_price float,
	discount NVARCHAR(250),
	payment_method NVARCHAR(250),
	delivery_days NVARCHAR(250),
	customer_rating NVARCHAR(250),
	revenue NVARCHAR(250)

);

BULK INSERT e_commerce
FROM 'D:\Proyectos\Sql\proyecto_SQL\data\ecommerce_sales_analytics_5000.csv' -- Reemplaza con la ruta real
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,           -- Ignora el encabezado del CSV
    FIELDTERMINATOR = ',',  -- Cambia por ';' si tu CSV usa punto y coma
    ROWTERMINATOR = '\n' -- Salto de línea estándar (LF) o '\n'
   -- ENCODING = 'UTF-8'      -- Importante si tienes acentos o tildes tildes
 
);


--TRANSFORMACION (SILVER) --> IMPLEMENTE EL MODELO MEDALLON 
-- CAST 
select
	order_id ,
	order_date ,
	customer_id ,
	product_category ,
	region ,
	quantity ,
	unit_price ,
	cast(discount  as float) discount,
	payment_method ,
	cast(delivery_days  as float) delivery_days  ,
	cast(customer_rating AS float) customer_rating,
	cast(revenue  as float) revenue ,
	unit_price *quantity total_sales

	into e_commerce_clean
from [dbo].[e_commerce];






select *
from e_commerce_clean



