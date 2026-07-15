# Data

10 tables imported into MySQL, exported here as clean, import-ready CSVs.

## `master/` — Dimensions, Bridges & Reporting Tables

| File | Rows | Role | Description |
|---|---|---|---|
| `customer_master.csv` | 150 | Dimension | Customer profile: type, city, region, credit limit, pricing tier |
| `product_catalogue.csv` | 12 | Dimension | Product SKU, category, thread size, material, price band |
| `region_master.csv` | 8 | Dimension | Region-level customer count, transactions, revenue share |
| `region_salesperson_map.csv` | 18 | Bridge | Salesperson-to-region assignment with performance |
| `region_city_map.csv` | 39 | Bridge | City-to-region mapping (NCR corrected per official 14-district list) |
| `region_deliverymode_map.csv` | 24 | Bridge | Delivery mode usage by region |
| `kpi_dashboard.csv` | 336 | Reporting | 8 KPIs x 42 months, target vs. actual with status/trend |
| `sales_targets_monthly.csv` | 42 | Reporting | Company-wide monthly target vs. actual |
| `sales_targets_region.csv` | 32 | Reporting | Annual target vs. actual by region |

## `sales/` — Fact Table

| File | Rows | Description |
|---|---|---|
| `raw_sales_data.csv.gz` | 103,842 | Full transaction ledger, Jan 2023 - Jun 2026 (gzip-compressed; ~35 MB uncompressed) |

### Fact table columns

`Transaction_ID, Date, Invoice_Number, Customer_ID, Customer_Name, Customer_Type, Product_ID, Product_Name, Product_Category, Inlet_Thread_Size, Quantity_Sold, Unit_Price_INR, Gross_Amount_INR, Discount_Percent, Discount_Amount_INR, Net_Amount_INR, GST_Rate_Percent, GST_Amount_INR, Total_Invoice_Amount_INR, Region, City, Salesperson_ID, Salesperson_Name, Payment_Status, Payment_Method, Payment_Due_Date, Delivery_Mode, Year, Month_Number, Month_Name, Quarter`

To unzip:
```bash
gunzip -k raw_sales_data.csv.gz
```

> If pushing to GitHub, consider Git LFS for the fact table since it's ~35 MB uncompressed - GitHub allows it but LFS keeps clone times fast.

These are the exact CSVs loaded into MySQL via `LOAD DATA INFILE` / Table Data Import Wizard - see `../sql/` for the schema and queries built on top of them.

