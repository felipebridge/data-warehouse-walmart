CREATE DATABASE IF NOT EXISTS raw;
CREATE DATABASE IF NOT EXISTS dw;

CREATE TABLE IF NOT EXISTS raw.orders (
  order_id CHAR(32) PRIMARY KEY,
  customer_id CHAR(32),
  order_status VARCHAR(20),
  order_purchase_timestamp DATETIME,
  order_approved_at DATETIME,
  order_delivered_carrier_date DATETIME,
  order_delivered_customer_date DATETIME,
  order_estimated_delivery_date DATETIME
);

CREATE TABLE IF NOT EXISTS raw.order_items (
  order_id CHAR(32),
  order_item_id INT,
  product_id CHAR(32),
  seller_id CHAR(32),
  shipping_limit_date DATETIME,
  price DECIMAL(10,2),
  freight_value DECIMAL(10,2),
  PRIMARY KEY (order_id, order_item_id)
);

CREATE TABLE IF NOT EXISTS raw.customers (
  customer_id CHAR(32) PRIMARY KEY,
  customer_unique_id CHAR(32),
  customer_zip_code_prefix INT,
  customer_city VARCHAR(60),
  customer_state CHAR(2)
);

CREATE TABLE IF NOT EXISTS raw.products (
  product_id CHAR(32) PRIMARY KEY,
  product_category VARCHAR(60),
  product_name_length INT,
  product_description_length INT,
  product_photos_qty INT,
  product_weight_g INT,
  product_length_cm INT,
  product_height_cm INT,
  product_width_cm INT
);

CREATE TABLE IF NOT EXISTS raw.payments (
  order_id CHAR(32),
  payment_sequential INT,
  payment_type VARCHAR(20),
  payment_installments INT,
  payment_value DECIMAL(10,2),
  PRIMARY KEY (order_id, payment_sequential)
);

CREATE TABLE IF NOT EXISTS raw.sellers (
  seller_id CHAR(32) PRIMARY KEY,
  seller_zip_code_prefix INT,
  seller_city VARCHAR(60),
  seller_state CHAR(2)
);

CREATE TABLE IF NOT EXISTS raw.geolocation (
  geolocation_zip_code_prefix INT,
  geolocation_lat DECIMAL(10,6),
  geolocation_lng DECIMAL(10,6),
  geolocation_city VARCHAR(60),
  geolocation_state CHAR(2)
);
