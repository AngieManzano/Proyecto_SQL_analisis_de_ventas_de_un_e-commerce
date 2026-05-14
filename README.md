![Proyecto SQL](./picture/banner_sql.jpeg)

# Proyecto SQL: análisis de ventas de un e-commerce
## Resumen (Overview)
Un e-commerce busca mejorar su servicio y brindar un mejor servicio a sus clientes. Mi objetivo utilizar SQL Server Management Studio para analizar los datos para obtener recomendaciones para mejorar el servicio del e-commerce.


## Estructura del Proyecto
- Sobre los Datos
- Tareas
- Limpieza de Datos
- Análisis Exploratorio de Datos e Insights

## Sobre los Datos
Los datos originales con la información de cada columna se encuentra [aquí](https://www.kaggle.com/datasets/abbas829/e-commerce-sales-analytics-dataset?resource=download). 

El conjunto de datos consta de 5.000 registros con las siguientes columnas:
- order_id: Un identificador único para cada pedido.
- Order_date: La fecha en que se realizó el pedido.
- Customer_id: Un identificador único para el cliente que realizó el pedido.
- Product_category: La categoría del producto vendido (por ejemplo, Belleza, Ropa, Electrónica).
- Region: La región geográfica donde se realizó el pedido (por ejemplo, Sur, Este, Oeste).
- Quantity: El número de artículos comprados en el pedido.
- Unit_price: El precio de una sola unidad del producto.
- Discount: El descuento aplicado al pedido (expresado como un número decimal).
- Payment_method: El método utilizado para el pago (por ejemplo, monedero electrónico, tarjeta, contra reembolso).
- Delivery_days: El número de días que tarda en entregarse el pedido.
- Customer_rating: La calificación otorgada por el cliente al pedido (en una escala del 1 al 5).
- Revenue: Los ingresos totales generados por el pedido (calculados como quantity * unit_price * (1 - discount)).
- Total_sales: Son los ingresos totales del pedido que consite en la multiplicacion de quantity con unit_price. Sin aplicar el descuento.

![Proyecto SQL](./picture/tabla.jpeg)

## Tareas (Task)

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




## Limpieza de Datos
Se tiene que realizar limpieza de datos para que los datos esten limpios y listos antes del analisis. 

![Proyecto SQL](./picture/limpia1.jpeg)

![Proyecto SQL](./picture/limpia2.jpeg)


## Análisis Exploratorio de Datos (EDA) e Insights

#### Pregunta #1: ¿Qué línea de producto genera el mayor volumen de efectivo real y vende mayor cantidad de productos?


```
SELECT 
    product_category,
    SUM(quantity) AS total_units_sold,
    SUM(revenue) AS total_revenue
FROM e_commerce_clean
GROUP BY product_category
ORDER BY total_revenue DESC;

```

![Proyecto SQL](./picture/pregunta%201.jpeg)

#### Pregunta #2: ¿Cuál es el método de pago más usado al realizar las compras?


```
SELECT 
    payment_method, 
    COUNT(order_id) AS transaction_count
FROM e_commerce_clean
GROUP BY payment_method
ORDER BY transaction_count desc;

```
![Proyecto SQL](./picture/pregunta%202.5.jpeg) 


#### Pregunta #3: ¿Cuál es el tiempo promedio de las entregas en cada región?



```
SELECT 
    region, 
    AVG(delivery_days) AS avg_delivery_time
FROM e_commerce_clean
GROUP BY region
ORDER BY avg_delivery_time DESC;

```

![Proyecto SQL](./picture/pregunta%203.jpeg)

#### Pregunta #4: ¿Cuál es el promedio de la clasificación del cliente en general?


```
SELECT AVG(customer_rating) AS global_rating
FROM e_commerce_clean;


```

![Proyecto SQL](./picture/pregunta%204-cambio.jpeg)

#### Pregunta #5: ¿Quiénes son clientes que compran la mayor cantidad de productos?


```
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


```
![Proyecto SQL](./picture/pregunta%205.jpeg)

#### Pregunta #6: ¿Cuál es la categoría que genera mayor ingreso en cada región?


```
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


```
![Proyecto SQL](./picture/pregunta%206.jpeg)


#### Pregunta #7: ¿Quiénes son los clientes que calificaron con un puntaje bajo a los productos? 

```
SELECT order_id, customer_id, customer_rating
FROM e_commerce_clean
WHERE customer_rating < 2.0;


```
![Proyecto SQL](./picture/pregunta7-cambio.jpeg)

#### Pregunta #8:  ¿Cuáles son los pedidos que tardaron el doble del promedio de su región?


```
SELECT order_id, region, delivery_days,
AVG(delivery_days) OVER(PARTITION BY region) AS regional_avg
FROM e_commerce_clean
WHERE delivery_days > (SELECT AVG(delivery_days) * 2
FROM e_commerce_clean);

```
![Proyecto SQL](./picture/pregunta%208.jpeg)

#### Pregunta #9: ¿Cuál es el promedio de la clasificación de los clientes sobre cada categoría?


```
SELECT product_category, ROUND(AVG(customer_rating), 2) AS avg_rating
FROM e_commerce_clean
GROUP BY product_category
ORDER BY avg_rating DESC;



```
![Proyecto SQL](./picture/pregunta%209.jpeg)

#### Pregunta #10: Segmentación de Clientes por nivel de gasto: ¿Cómo se podría clasificar a los clientes en tres categorías (Platinum, Gold y Silver) en base a la cantidad de dinero que ponen cuando realizan sus compras?

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

```
![Proyecto SQL](./picture/pregunta%204.jpeg)


## Conclusión
Este análisis nos ayuda a determinar puntos de mejora para el negocio en diferentes áreas, asimismo, se puede encontrar apartados donde el negocio esta sadisfaciendo las necesidades de los clientes. Con la información de los analisis se pueden tomar desciciones para mejorar la experiencia de los clientes y los prodcutos. 



