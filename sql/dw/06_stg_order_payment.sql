CREATE DATABASE IF NOT EXISTS dw;

DROP TABLE IF EXISTS dw.stg_order_payment;

CREATE TABLE dw.stg_order_payment AS
SELECT
  p.order_id,
  SUM(p.payment_value) AS payment_total,
  SUBSTRING_INDEX(
    GROUP_CONCAT(p.payment_type ORDER BY p.payment_value DESC),
    ',', 1
  ) AS payment_type_primary,
  MAX(p.payment_installments) AS max_installments
FROM raw.payments p
GROUP BY p.order_id;
