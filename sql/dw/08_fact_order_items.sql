DROP TABLE IF EXISTS dw.fact_order_items;

CREATE TABLE dw.fact_order_items (
  fact_key BIGINT NOT NULL AUTO_INCREMENT,
  order_id CHAR(32) NOT NULL,

  date_key_purchase INT NOT NULL,
  product_key INT NOT NULL,
  customer_key INT NOT NULL,
  seller_key INT NOT NULL,
  payment_key INT NULL,

  order_status VARCHAR(20) NOT NULL,

  sales_amount DECIMAL(10,2) NOT NULL,
  freight_amount DECIMAL(10,2) NOT NULL,
  item_count INT NOT NULL,

  delivery_days INT NULL,
  delay_days INT NULL,
  on_time_flag TINYINT NOT NULL,

  payment_total DECIMAL(10,2) NULL,

  PRIMARY KEY (fact_key),
  KEY idx_fact_date (date_key_purchase),
  KEY idx_fact_product (product_key),
  KEY idx_fact_customer (customer_key),
  KEY idx_fact_seller (seller_key),
  KEY idx_fact_payment (payment_key)
);

INSERT INTO dw.fact_order_items (
  order_id,
  date_key_purchase,
  product_key,
  customer_key,
  seller_key,
  payment_key,
  order_status,
  sales_amount,
  freight_amount,
  item_count,
  delivery_days,
  delay_days,
  on_time_flag,
  payment_total
)
SELECT
  oi.order_id,

  -- date_key_purchase
  (YEAR(o.order_purchase_timestamp) * 10000
   + MONTH(o.order_purchase_timestamp) * 100
   + DAY(o.order_purchase_timestamp)) AS date_key_purchase,

  dp.product_key,
  dc.customer_key,
  ds.seller_key,
  dpay.payment_key,

  o.order_status,

  oi.price AS sales_amount,
  oi.freight_value AS freight_amount,
  1 AS item_count,

  CASE
    WHEN o.order_delivered_customer_date IS NOT NULL
    THEN DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)
    ELSE NULL
  END AS delivery_days,

  CASE
    WHEN o.order_delivered_customer_date IS NOT NULL
     AND o.order_estimated_delivery_date IS NOT NULL
    THEN DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date)
    ELSE NULL
  END AS delay_days,

  CASE
    WHEN o.order_delivered_customer_date IS NOT NULL
     AND o.order_estimated_delivery_date IS NOT NULL
     AND o.order_delivered_customer_date <= o.order_estimated_delivery_date
    THEN 1 ELSE 0
  END AS on_time_flag,

  sop.payment_total

FROM raw.order_items oi
JOIN raw.orders o
  ON o.order_id = oi.order_id

JOIN dw.dim_product dp
  ON dp.product_id = oi.product_id

JOIN dw.dim_customer dc
  ON dc.customer_id = o.customer_id

JOIN dw.dim_seller ds
  ON ds.seller_id = oi.seller_id

LEFT JOIN dw.stg_order_payment sop
  ON sop.order_id = oi.order_id

LEFT JOIN dw.dim_payment dpay
  ON dpay.payment_type = sop.payment_type_primary
 AND dpay.installments_bucket =
   CASE
     WHEN sop.max_installments = 1 THEN '1'
     WHEN sop.max_installments BETWEEN 2 AND 3 THEN '2-3'
     WHEN sop.max_installments BETWEEN 4 AND 6 THEN '4-6'
     ELSE '7+'
   END;
