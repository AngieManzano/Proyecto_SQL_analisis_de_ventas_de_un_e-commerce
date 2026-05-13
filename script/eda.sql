--Nuestra EDA


-- Verificar valores faltantes en la tabla--
 SELECT COUNT(*) AS MissingValues
FROM [dbo].[e_commerce_clean]
WHERE [order_id] IS NULL;



-- Verificar valores duplicados en la tabla --

SELECT [order_id], COUNT(*)
FROM [dbo].[e_commerce_clean]
GROUP BY [order_id]
HAVING COUNT(*) > 1;







/*
1. Pregunta #1: ¿Qué línea de producto genera el mayor volumen de efectivo real?
2
3.
4.
5.
6.
7.
8.
9.
10.


cuales son las caterias qe venden mas?
cuales son las regiones que venden mas
cual es el metodo de pago mas usado en las compreas


*/

--- Pregunta #1: ¿Qué línea de producto genera el mayor volumen de efectivo real y vende mayor cantidad de productos?

SELECT 
    product_category,
    SUM(quantity) AS total_units_sold,
    SUM(revenue) AS total_revenue
FROM e_commerce_clean
GROUP BY product_category
ORDER BY total_revenue DESC;


---


---gasto del cliente vs el gasto promedio de los clientes

---Cuanto dinero ingresa a a empresa por medio de un cliente promedio comparado con el dinero que los clientes dan a la empresa para comprar sus productos

select [customer_id]
	,[revenue]
	,avg([revenue]) over() gasto_promedio_clientes
from [dbo].[e_commerce_clean]
order by [revenue] desc
;
select avg ([revenue])
from [dbo].[e_commerce_clean]


---Eficiencia Logística: Tiempo de Entrega Promedio por Región




SELECT 
    region, 
    AVG(delivery_days) AS avg_delivery_time
FROM e_commerce_clean
GROUP BY region
ORDER BY avg_delivery_time DESC;




---Popularidad de Métodos de Pago
SELECT 
    payment_method, 
    COUNT(order_id) AS transaction_count,
    ROUND(AVG(revenue), 2) AS average_ticket
FROM e_commerce_clean
GROUP BY payment_method
ORDER BY transaction_count desc;

SELECT 
    payment_method, 
    COUNT(order_id) AS transaction_count,
    ROUND(AVG(revenue), 2) AS average_ticket
FROM e_commerce_clean
GROUP BY payment_method
ORDER BY transaction_count desc;






SELECT 
    payment_method, 
    COUNT(order_id) AS transaction_count,
    ROUND(AVG(revenue), 2) AS average_ticket
FROM e_commerce_clean
GROUP BY payment_method
ORDER BY transaction_count desc;



SELECT 
    payment_method, 
    COUNT(order_id) AS transaction_count
FROM e_commerce_clean
GROUP BY payment_method
ORDER BY transaction_count desc;

---Segmentación de Clientes por Nivel de Gasto


SELECT 
    customer_id, 
    SUM(revenue) AS total_spent,
    CASE 
        WHEN SUM(revenue) > 3000 THEN 'Platinum'
        WHEN SUM(revenue) BETWEEN 1500 AND 3000 THEN 'Gold'
        ELSE 'Silver'
    END AS customer_segment
FROM e_commerce_clean
GROUP BY customer_id;

----------Detección de Categorías con Alto Valor pero Baja Cantidad


SELECT 
    product_category, 
    AVG(unit_price) AS avg_price,
    SUM(quantity) AS total_units
FROM e_commerce_clean
GROUP BY product_category
HAVING AVG(unit_price) > 300;



---




----





select [customer_id]
	,[revenue]
from [dbo].[e_commerce_clean]
where [revenue] between 1200 and 3000




select [payment_method]
	,[revenue]
from [dbo].[e_commerce_clean];





select*
from[dbo].[e_commerce_clean]
where   [order_date] '2025-01-01' and '2026-12-31'





select top 5*
FROM [dbo].[e_commerce_clean]
order by  [revenue] desc
;





SELECT 
    product_category,
    SUM(revenue) AS total_revenue,
    ROUND(AVG(discount), 2) AS avg_discount
FROM e_commerce_clean

GROUP BY product_category
ORDER BY total_revenue DESC;








select *
from e_commerce_clean

SELECT COUNT(*) 
FROM [dbo].[e_commerce_clean]
WHERE order_id IS NULL;








--- cual es los orden id que con mayor venta

SELECT TOP 3*
FROM [dbo].[e_commerce_clean]
order by [total_sales] desc;

---¿Qué clientes compran la mayor cantidad de productos?


with mejores_vendedores as (
select TOP 3
      sum(quantity) as 'Productos_vendidos',
      customer_name from basetotal
where quantity > 0
group by customer_name
order by sum(quantity) desc
)

select * from mejores_vendedores;





------¿Cuáles son los productos que generan mayor ganancia por año?

with top_ganancia_producto as (
select top 10
year,product_name,format(sum(profit),'N2') as 'total_ganancia'
from basetotal
group by year,product_name
order by sum(profit) desc
)
select * from top_ganancia_producto




---Pregunta #1: ¿Qué línea de producto genera el mayor volumen de efectivo real y vende mayor cantidad de productos?

SELECT 
    product_category,
    SUM(quantity) AS total_units_sold,
    SUM(revenue) AS total_revenue
FROM e_commerce_clean
GROUP BY product_category
ORDER BY total_revenue DESC;





with mejores_clientes as (
select TOP 10
      sum([quantity]) as 'Productos_vendidos',
      [customer_id] from [dbo].[e_commerce_clean]
where [quantity]> 0
group by [customer_id]
order by sum([quantity]) desc
)

select * from mejores_clientes;





SELECT 
    region, 
    product_category, 
    SUM(revenue) AS total_rev,
    RANK() OVER (PARTITION BY region ORDER BY SUM(revenue) DESC) AS regional_rank
FROM e_commerce_clean
GROUP BY region, product_category;






WITH customer_stats AS (
    SELECT 
        customer_id,
        COUNT(order_id) AS total_orders,
        SUM(revenue) AS lifetime_value,
        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order
    FROM e_commerce_clean
    GROUP BY customer_id
)
SELECT *,
    (lifetime_value / total_orders) AS avg_order_value
FROM customer_stats
WHERE total_orders > 1
ORDER BY lifetime_value DESC;





---Ranking de Productos Estrella por Región
WITH RegionalRanking AS (
    SELECT 
        region,
        product_category,
        SUM(revenue) AS total_revenue,
        RANK() OVER (PARTITION BY region ORDER BY SUM(revenue) DESC) as pos
    FROM e_commerce_clean
    GROUP BY region, product_category
)
SELECT region, product_category, total_revenue
FROM RegionalRanking
WHERE pos = 1
ORDER BY total_revenue desc;







SELECT product_category, AVG(customer_rating) as avg_rating
FROM e_commerce_clean
GROUP BY 1
HAVING AVG(customer_rating) < 1.0;



SELECT * FROM (
  SELECT *, AVG(delivery_days) OVER(PARTITION BY region) as reg_avg
  FROM e_commerce_clean
) t WHERE delivery_days > reg_avg;







SELECT order_id, product_category, customer_rating 
FROM e_commerce_clean 
WHERE customer_rating < 2.0;






SELECT product_category, AVG(customer_rating) as avg_rating
FROM e_commerce_clean
GROUP BY 1
HAVING AVG(customer_rating) < 3.0;











SELECT SUM(revenue) as actual_rev,
SUM(revenue / (1 - discount)) as theoretical_rev
FROM e_commerce_clean;


WITH RankedSales AS (
  SELECT region, product_category, SUM(revenue) as total_rev,
  RANK() OVER(PARTITION BY region ORDER BY SUM(revenue) DESC) as rnk
  FROM e_commerce_clean GROUP BY 1, 2
)
SELECT * FROM RankedSales WHERE rnk = 1;