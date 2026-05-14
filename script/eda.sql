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
1. Rentabilidad por Categoría: ¿Qué línea de producto genera el mayor volumen de efectivo real y vende mayor cantidad de productos?
2. Popularidad de Métodos de Pago: ¿Cuál es el método de pago más usado al realizar las compras?
3. Evaluación de la Eficiencia Logística Regional: ¿Cuál es el tiempo promedio de las entregas en cada región?
4. Ranking de Satisfacción General: ¿Cuál es el promedio de la clasificación del cliente en general?
5. Clientes más activos: ¿Quiénes son clientes que compran la mayor cantidad de productos?
6. Ranking de categoría estrella por Región: ¿Cuál es la categoría que genera mayor ingreso en cada región?
7. Identificación de Clientes con Ratings Críticos: ¿Quiénes son los clientes que calificaron con un puntaje bajo a los productos? 
8. Detección de Anomalías Logísticas: ¿Cuáles son los pedidos que tardaron el doble del promedio de su región?
9. Categorías con Mejor Calificación: ¿Cuál es el promedio de la clasificación de los clientes sobre cada categoría?
10. Segmentación de Clientes por nivel de gasto: ¿Cómo se podría clasificar a los clientes en tres categorías (Platinum, Gold y Silver) en base a la cantidad de dinero que ponen cuando realizan sus compras?


*/



---- Pregunta #1: ¿Qué línea de producto genera el mayor volumen de efectivo real y vende mayor cantidad de productos?


SELECT 
    product_category,
    SUM(quantity) AS total_units_sold,
    SUM(revenue) AS total_revenue
FROM e_commerce_clean
GROUP BY product_category
ORDER BY total_revenue DESC;





---- Pregunta #2: ¿Cuál es el método de pago más usado al realizar las compras?

SELECT 
    payment_method, 
    COUNT(order_id) AS transaction_count
FROM e_commerce_clean
GROUP BY payment_method
ORDER BY transaction_count desc;




---- Pregunta #3: ¿Cuál es el tiempo promedio de las entregas en cada región?



SELECT 
    region, 
    AVG(delivery_days) AS avg_delivery_time
FROM e_commerce_clean
GROUP BY region
ORDER BY avg_delivery_time DESC;




---- Pregunta #4: ¿Cuál es el promedio de la clasificación del cliente en general?



SELECT AVG(customer_rating) AS global_rating
FROM e_commerce_clean;




---- Pregunta #5: ¿Quiénes son clientes que compran la mayor cantidad de productos?


with mejores_clientes as (
select TOP 10
      sum([quantity]) as 'Productos_vendidos',
      [customer_id] from [dbo].[e_commerce_clean]
where [quantity]> 0
group by [customer_id]
order by sum([quantity]) desc
)

select * 
from mejores_clientes;



---- Pregunta #6: ¿Cuál es la categoría que genera mayor ingreso en cada región?


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



---- Pregunta #7: ¿Quiénes son los clientes que calificaron con un puntaje bajo a los productos? 

SELECT order_id, customer_id, customer_rating
FROM e_commerce_clean
WHERE customer_rating < 2.0;


---- Pregunta #8:  ¿Cuáles son los pedidos que tardaron el doble del promedio de su región? 


SELECT order_id, region, delivery_days,
AVG(delivery_days) OVER(PARTITION BY region) AS regional_avg
FROM e_commerce_clean
WHERE delivery_days > (SELECT AVG(delivery_days) * 2
FROM e_commerce_clean);


---- Pregunta #9: ¿Cuál es el promedio de la clasificación de los clientes sobre cada categoría?


SELECT product_category, ROUND(AVG(customer_rating), 2) AS avg_rating
FROM e_commerce_clean
GROUP BY product_category
ORDER BY avg_rating DESC;


---- Pregunta #10: Segmentación de Clientes por nivel de gasto: ¿Cómo se podría clasificar a los clientes en tres categorías (Platinum, Gold y Silver) en base a la cantidad de dinero que ponen cuando realizan sus compras?

```
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



