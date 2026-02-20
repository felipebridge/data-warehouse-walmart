CREATE DATABASE IF NOT EXISTS dw;

DROP TABLE IF EXISTS dw.dim_product;

CREATE TABLE dw.dim_product (
  product_key INT NOT NULL AUTO_INCREMENT,
  product_id CHAR(32) NOT NULL,
  product_category VARCHAR(60) NULL,
  product_name_length INT NULL,
  product_description_length INT NULL,
  product_photos_qty INT NULL,
  product_weight_g INT NULL,
  product_length_cm INT NULL,
  product_height_cm INT NULL,
  product_width_cm INT NULL,
  PRIMARY KEY (product_key),
  UNIQUE KEY uq_product_id (product_id),
  KEY idx_product_category (product_category)
);

-- Carga desde RAW
INSERT INTO dw.dim_product (
  product_id, product_category,
  product_name_length, product_description_length, product_photos_qty,
  product_weight_g, product_length_cm, product_height_cm, product_width_cm
)
SELECT
  p.product_id,
  NULLIF(TRIM(p.product_category), '') AS product_category,
  p.product_name_length,
  p.product_description_length,
  p.product_photos_qty,
  p.product_weight_g,
  p.product_length_cm,
  p.product_height_cm,
  p.product_width_cm
FROM raw.products p;
