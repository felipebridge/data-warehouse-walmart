USE dw;

SET @min_date = (SELECT DATE(MIN(order_purchase_timestamp))
                 FROM raw.orders
                 WHERE order_purchase_timestamp IS NOT NULL);

SET @max_date = (SELECT DATE(MAX(order_purchase_timestamp))
                 FROM raw.orders
                 WHERE order_purchase_timestamp IS NOT NULL);

TRUNCATE TABLE dw.dim_date;

INSERT INTO dw.dim_date (
  date_key, full_date, year, quarter, month, month_name,
  day, day_of_week, day_name, week_of_year, is_weekend
)
SELECT
  (YEAR(DATE_ADD(@min_date, INTERVAL n.n DAY)) * 10000
   + MONTH(DATE_ADD(@min_date, INTERVAL n.n DAY)) * 100
   + DAY(DATE_ADD(@min_date, INTERVAL n.n DAY))) AS date_key,
  DATE_ADD(@min_date, INTERVAL n.n DAY) AS full_date,
  YEAR(DATE_ADD(@min_date, INTERVAL n.n DAY)) AS year,
  QUARTER(DATE_ADD(@min_date, INTERVAL n.n DAY)) AS quarter,
  MONTH(DATE_ADD(@min_date, INTERVAL n.n DAY)) AS month,
  MONTHNAME(DATE_ADD(@min_date, INTERVAL n.n DAY)) AS month_name,
  DAY(DATE_ADD(@min_date, INTERVAL n.n DAY)) AS day,
  DAYOFWEEK(DATE_ADD(@min_date, INTERVAL n.n DAY)) AS day_of_week,
  DAYNAME(DATE_ADD(@min_date, INTERVAL n.n DAY)) AS day_name,
  WEEK(DATE_ADD(@min_date, INTERVAL n.n DAY), 3) AS week_of_year,
  CASE WHEN DAYOFWEEK(DATE_ADD(@min_date, INTERVAL n.n DAY)) IN (1,7) THEN 1 ELSE 0 END AS is_weekend
FROM dw.numbers n
WHERE n.n <= DATEDIFF(@max_date, @min_date);
