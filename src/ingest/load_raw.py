import os
from dotenv import load_dotenv
import pandas as pd
from sqlalchemy import create_engine, text

load_dotenv()

MYSQL_PWD = os.getenv("MYSQL_ROOT_PASSWORD")
if not MYSQL_PWD:
    raise RuntimeError("MYSQL_ROOT_PASSWORD no está seteada.")

engine = create_engine(
    f"mysql+mysqlconnector://root:{MYSQL_PWD}@localhost:3307/raw",
    echo=False,
    future=True
)

BASE_PATH = os.path.join("data", "raw")

TABLES = [
    ("orders", "orders.csv"),
    ("order_items", "order_items.csv"),
    ("customers", "customers.csv"),
    ("products", "products.csv"),
    ("payments", "payments.csv"),
    ("sellers", "sellers.csv"),
    ("geolocation", "geolocation.csv"),
]

DATE_COLUMNS = {
    "orders": [
        "order_purchase_timestamp",
        "order_approved_at",
        "order_delivered_carrier_date",
        "order_delivered_customer_date",
        "order_estimated_delivery_date",
    ],
    "order_items": ["shipping_limit_date"],
}

def read_csv_safely(csv_path: str) -> pd.DataFrame:
    return pd.read_csv(csv_path, dtype=str)

def apply_type_casts(table: str, df: pd.DataFrame) -> pd.DataFrame:
    if table in DATE_COLUMNS:
        for c in DATE_COLUMNS[table]:
            if c in df.columns:
                df[c] = pd.to_datetime(df[c], errors="coerce")

    if table == "order_items":
        df["order_item_id"] = pd.to_numeric(df["order_item_id"], errors="coerce").astype("Int64")
        df["price"] = pd.to_numeric(df["price"], errors="coerce")
        df["freight_value"] = pd.to_numeric(df["freight_value"], errors="coerce")
    elif table == "payments":
        df["payment_sequential"] = pd.to_numeric(df["payment_sequential"], errors="coerce").astype("Int64")
        df["payment_installments"] = pd.to_numeric(df["payment_installments"], errors="coerce").astype("Int64")
        df["payment_value"] = pd.to_numeric(df["payment_value"], errors="coerce")
    elif table == "customers":
        df["customer_zip_code_prefix"] = pd.to_numeric(df["customer_zip_code_prefix"], errors="coerce").astype("Int64")
    elif table == "sellers":
        df["seller_zip_code_prefix"] = pd.to_numeric(df["seller_zip_code_prefix"], errors="coerce").astype("Int64")
    elif table == "geolocation":
        df["geolocation_zip_code_prefix"] = pd.to_numeric(df["geolocation_zip_code_prefix"], errors="coerce").astype("Int64")
        df["geolocation_lat"] = pd.to_numeric(df["geolocation_lat"], errors="coerce")
        df["geolocation_lng"] = pd.to_numeric(df["geolocation_lng"], errors="coerce")

    if table == "products":
        if "product category" in df.columns:
            df = df.rename(columns={"product category": "product_category"})

        cols_int = [
            "product_name_length",
            "product_description_length",
            "product_photos_qty",
            "product_weight_g",
            "product_length_cm",
            "product_height_cm",
            "product_width_cm",
        ]
        for c in cols_int:
            if c in df.columns:
                df[c] = pd.to_numeric(df[c], errors="coerce").astype("Int64")

    return df

def truncate_table(table: str) -> None:
    with engine.begin() as conn:
        conn.execute(text(f"TRUNCATE TABLE {table};"))

def load_table(table: str, filename: str) -> int:
    csv_path = os.path.join(BASE_PATH, filename)
    if not os.path.exists(csv_path):
        raise FileNotFoundError(f"No existe el archivo: {csv_path}")

    df = read_csv_safely(csv_path)
    df = apply_type_casts(table, df)

    df.to_sql(
        table,
        con=engine,
        if_exists="append",
        index=False,
        chunksize=5000,
        method="multi",
    )
    return len(df)

def main() -> None:
    print("Ingesta RAW -> MySQL (raw.*)")
    for table, filename in TABLES:
        print(f"\nCargando {table} desde {filename}...")
        truncate_table(table)
        n = load_table(table, filename)
        print(f"OK: {table} cargada: {n} filas")

    print("\nListo. Todas las tablas RAW cargadas.")

if __name__ == "__main__":
    main()
