from fastapi import FastAPI
import os

app = FastAPI()

@app.get("/health")
def health():
    return {"status": "ok", "service": "product-service"}

@app.get("/products")
def get_products():
    return [
        {"id": 1, "name": "Laptop CI-CD SUCCESS", "price": 999.99},
        {"id": 2, "name": "Phone", "price": 499.99}
    ]
