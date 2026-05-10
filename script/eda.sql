--Nuestra EDA

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


*/

select *
from e_commerce_clean


--- cual es los orden id que con mayor venta
SELECT TOP 3*
FROM [dbo].[e_commerce_clean]
order by [total_sales] desc;