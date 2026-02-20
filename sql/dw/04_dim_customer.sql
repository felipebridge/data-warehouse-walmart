CREATE DATABASE IF NOT EXISTS dw;

DROP TABLE IF EXISTS dw.dim_customer;

CREATE TABLE dw.dim_customer (
  customer_key INT NOT NULL AUTO_INCREMENT,
  customer_id CHAR(32) NOT NULL,
  customer_unique_id CHAR(32) NOT NULL,
  customer_zip_code_prefix INT NULL,
  customer_city VARCHAR(100) NULL,
  customer_state CHAR(2) NULL,
  PRIMARY KEY (customer_key),
  UNIQUE KEY uq_customer_id (customer_id),
  KEY idx_customer_geo (customer_state, customer_city)
);

INSERT INTO dw.dim_customer (
  customer_id,
  customer_unique_id,
  customer_zip_code_prefix,
  customer_city,
  customer_state
)
SELECT
  c.customer_id,
  c.customer_unique_id,
  c.customer_zip_code_prefix,
  UPPER(TRIM(c.customer_city)) AS customer_city,
  UPPER(TRIM(c.customer_state)) AS customer_state
FROM raw.customers c;
