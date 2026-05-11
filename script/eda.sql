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
1. Rentabilidad por Categoría: ¿Cuales son las 3 categorias de producto con mayores ingresos?
2.Eficiencia de Logística por Región: ¿cual es el promedio de delivery_days por cada region?
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












---¿Qué órdenes superan el tiempo de entrega estándar de la región?

SELECT * FROM (
  SELECT *, AVG(delivery_days) OVER(PARTITION BY region) as reg_avg
  FROM e_commerce_clean
) t WHERE delivery_days > reg_avg




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
FROM SuperStore
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




---Calcular el ingreso total y la cantidad total de productos vendidos por product_category.
SELECT 
    product_category,
    SUM(quantity) AS total_units_sold,
    SUM(revenue) AS total_revenue
FROM e_commerce_clean
GROUP BY product_category
ORDER BY total_revenue DESC;
