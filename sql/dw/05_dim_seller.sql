CREATE DATABASE IF NOT EXISTS dw;

DROP TABLE IF EXISTS dw.dim_seller;

CREATE TABLE dw.dim_seller (
  seller_key INT NOT NULL AUTO_INCREMENT,
  seller_id CHAR(32) NOT NULL,
  seller_zip_code_prefix INT NULL,
  seller_city VARCHAR(100) NULL,
  seller_state CHAR(2) NULL,
  PRIMARY KEY (seller_key),
  UNIQUE KEY uq_seller_id (seller_id),
  KEY idx_seller_geo (seller_state, seller_city)
);

INSERT INTO dw.dim_seller (
  seller_id,
  seller_zip_code_prefix,
  seller_city,
  seller_state
)
SELECT
  s.seller_id,
  s.seller_zip_code_prefix,
  UPPER(TRIM(s.seller_city)) AS seller_city,
  UPPER(TRIM(s.seller_state)) AS seller_state
FROM raw.sellers s;
