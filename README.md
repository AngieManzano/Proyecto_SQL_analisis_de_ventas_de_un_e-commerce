# Proyecto SQL: análisis de ventas de un e-commerce
## Resumen (Overview)
Un e-commerce busca mejorar su servicio y brindar un mejor servicio a sus clientes. Mi objetivo utilizar SQL Server Management Studio para analizar los datos para obtener recomendaciones para mejorar el servicio del e-commerce


## Estructura del Proyecto
- Sobre los Datos
- Tareas
- Limpieza de Datos
- Análisis Exploratorio de Datos e Insights

## Sobre los Datos
Los datos originales con la informacion de cada columna se encuentra [aquí](https://www.kaggle.com/datasets/abbas829/e-commerce-sales-analytics-dataset?resource=download)

## Tareas (Task)
Desafío Analítico: Calcular el ingreso total y la cantidad total de productos vendidos por product_category.




## Limpieza de Datos
Se tiene que realizar limpieza de datos para que los datos esten limpios y listos antes del analisis. 







## Análisis Exploratorio de Datos (EDA) e Insights


SELECT 
    product_category,
    SUM(quantity) AS total_units_sold,
    SUM(revenue) AS total_revenue
FROM e_commerce_clean
GROUP BY product_category
ORDER BY total_revenue DESC;

## Conclusion



