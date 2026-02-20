DROP TABLE IF EXISTS dw.dim_payment;

CREATE TABLE dw.dim_payment (
  payment_key INT NOT NULL AUTO_INCREMENT,
  payment_type VARCHAR(30) NOT NULL,
  installments_bucket VARCHAR(20) NOT NULL,
  PRIMARY KEY (payment_key),
  UNIQUE KEY uq_payment (payment_type, installments_bucket)
);

INSERT INTO dw.dim_payment (payment_type, installments_bucket)
SELECT DISTINCT
  payment_type_primary,
  CASE
    WHEN max_installments = 1 THEN '1'
    WHEN max_installments BETWEEN 2 AND 3 THEN '2-3'
    WHEN max_installments BETWEEN 4 AND 6 THEN '4-6'
    ELSE '7+'
  END AS installments_bucket
FROM dw.stg_order_payment;
