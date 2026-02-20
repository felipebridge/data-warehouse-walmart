CREATE DATABASE IF NOT EXISTS dw;

-- Dimensión Fecha 
DROP TABLE IF EXISTS dw.dim_date;

CREATE TABLE dw.dim_date (
  date_key INT NOT NULL,              
  full_date DATE NOT NULL,
  year INT NOT NULL,
  quarter INT NOT NULL,
  month INT NOT NULL,
  month_name VARCHAR(15) NOT NULL,
  day INT NOT NULL,
  day_of_week INT NOT NULL,           
  day_name VARCHAR(10) NOT NULL,
  week_of_year INT NOT NULL,
  is_weekend TINYINT NOT NULL,
  PRIMARY KEY (date_key),
  UNIQUE KEY uq_full_date (full_date)
);
