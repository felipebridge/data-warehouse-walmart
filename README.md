# Proyecto Data Warehouse – Sales Analytics (Dataset Walmart)

Este proyecto implementa un **Data Warehouse relacional orientado al análisis de ventas de la compañia Walmart**, cubriendo todo el flujo desde la ingesta de datos transaccionales hasta su explotación analítica mediante un modelo dimensional y visualización en Power BI.

El objetivo es transformar datos operativos en información estructurada y confiable para análisis histórico, métricas de negocio y toma de decisiones.

---

## Dominio del negocio

Retail / Ventas  
Análisis de órdenes, clientes, productos, vendedores y métodos de pago.

---

## Fuentes de datos

Datos transaccionales en formato CSV:

- Customers  
- Orders  
- Order Items  
- Products  
- Sellers  
- Payments  
- Geolocation  

Los datos se cargan inicialmente en una capa **raw**, sin transformaciones analíticas.

---

## Modelo de datos

Modelo dimensional basado en **Star Schema**, optimizado para consultas OLAP.

### Tabla de hechos
- `fact_order_items`  
  Contiene métricas de ventas a nivel de ítem de orden (montos, cantidades, operaciones).

### Dimensiones
- `dim_date`  
- `dim_customer`  
- `dim_product`  
- `dim_seller`  
- `dim_payment`  

El diseño permite análisis temporales, segmentación, agregaciones y comparaciones entre períodos con buen rendimiento.

![Star Schema](docs/star%20schema/Star%20Schema%20.png)

---

## Proceso ETL 

1. Ingesta de datos desde archivos CSV  
2. Limpieza y normalización mediante SQL  
3. Construcción de dimensiones y tabla de hechos  
4. Carga final en el Data Warehouse  

El proceso prioriza claridad, trazabilidad y separación entre datos crudos y datos analíticos.

---

## Tecnologías utilizadas

- MySQL  
- SQL  
- Python (ingesta y preparación de datos)  
- Docker (entorno reproducible)  
- Power BI 

---

## Capacidades analíticas

El Data Warehouse permite responder, entre otras, las siguientes preguntas:

- Evolución de ventas en el tiempo  (año/mes)
- Ventas por producto y categoría  
- Distribución de métodos de pago  
- Ventas por estado
- KPIs agregados y análisis comparativos por período  

---

## Visualización

Dashboard desarrollado en **Power BI**, conectado directamente al Data Warehouse, con foco en:

- KPIs principales  
- Tendencias temporales  
- Rankings y segmentaciones  
- Filtros dinámicos por fecha y dimensiones clave  

![Dashboard Preview](docs/dashboard/Dashboard%20BI.png)

---

## Estado del proyecto

Finalizado.  
