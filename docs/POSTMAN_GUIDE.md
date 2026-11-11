# 📮 Stockify API - Postman Collection Guide

This collection contains all pre-configured endpoints for the Stockify RESTful API.

## 🚀 How to import and use:
1. Open **Postman**.
2. Click **Import** (top left).
3. Select `stockify_api_collection.json`.
4. Under the collection's **Variables** tab:
   - Ensure `baseUrl` is set to `http://localhost:5000/api/v1`.
   - After executing `Login User` or `Register User`, copy the returned JWT token and paste it into the `token` variable.
5. All protected endpoints (Products Admin & Invoices) will automatically inherit the token!