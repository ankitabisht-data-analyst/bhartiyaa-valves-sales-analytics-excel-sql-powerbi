# 🔧 Bhartiya Valves — Sales & Marketing Analytics | End-to-End Excel, SQL & Power BI Project

[![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)](https://powerbi.microsoft.com/)
[![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com/)
[![Excel](https://img.shields.io/badge/Excel-217346?style=for-the-badge&logo=microsoftexcel&logoColor=white)](https://www.microsoft.com/excel)

## 📌 Project Overview
End-to-end **Sales & Marketing Analytics** solution built with **Excel, MySQL, and Power BI** during an internship at Bhartiya Valves (P) Ltd., a Faridabad-based manufacturer of high-pressure gas cylinder valves (Est. 1989). Analyzes **1,03,842 transactions** spanning 3.5 years (Jan 2023 - Jun 2026) — from raw data cleaning through a 10-table MySQL database to a 7-page interactive Power BI dashboard with 44 DAX measures.

**Goal:** Give management full visibility into revenue drivers, regional performance, target achievement, and — most importantly — trace a real 2024 revenue dip back to its root cause and quantify the 2025 recovery.

## 🎯 Business Problem
Bhartiya Valves needed clear, drillable visibility into its sales performance to support pricing, sales-team, and regional-expansion decisions. This project answers:
- Which regions and products drive the most revenue, and where is growth slowing?
- Are salespeople hitting their monthly/quarterly targets, and by how much?
- What does the customer base look like by segment, pricing tier, and order value?
- Which delivery channels and payment methods are most used, and what's the outstanding collection rate?
- **What caused the May-September 2024 revenue dip, and what changed in the 2025 recovery?**

## 🗂️ Dataset
10 relational tables, created in a MySQL database (`bhartiya_valves`) and joined on `Customer_ID`, `Product_ID`, and `Region`:

| Table | Description | Rows | Key Fields |
|---|---|---|---|
| `raw_sales_data` | Transaction-level fact table | 1,03,842 | Transaction_ID, Date, Customer_ID, Product_ID, Net_Amount_INR, Region |
| `customer_master` | Customer demographic & credit profile | 150 | Customer_ID, Customer_Type, City, Region, Pricing_Tier, Credit_Limit_INR |
| `product_catalogue` | Product SKU details | 12 | Product_ID, Product_Category, Body_Material, Avg_Selling_Price_INR |
| `region_master` | Region-level rollups | 8 | Region_ID, State_Covered, Total_NET_Revenue_INR |
| `region_salesperson_map`, `region_city_map`, `region_deliverymode_map` | Bridge tables | 18 / 39 / 24 | Region_ID + mapped dimension |
| `sales_targets_monthly`, `sales_targets_region` | Target vs. actual tracking | 42 / 32 | Target_INR, Actual_INR, Achievement_Pct |
| `kpi_dashboard` | 8 KPIs x 42 months | 336 | KPI_Name, Target, Actual, Status, MoM_Trend |

Raw data: [`/data`](./data) and [`/excel`](./excel) · Schema: [`/sql/01_schema_creation.sql`](./sql/01_schema_creation.sql)

## 🛠️ Tech Stack & Process
1. **Excel** — Raw sales ledger cleaned and analyzed across 8 workbooks: data cleaning (text-formatted dates, duplicate customers), EDA, and 4 purpose-built analysis workbooks (KPI Tracker, Sales Analysis, Marketing Analytics, Targets vs. Achievement). See [`/excel`](./excel).
2. **MySQL** — Designed a 10-table normalized schema with 22 performance indexes, wrote 53 analytical queries across 4 tiers, 6 parameterized stored procedures, and 3 views feeding Power BI directly. See [`/sql`](./sql).
3. **Power BI** — Star-schema data model (fact table joined to Customer, Product, and a custom Calendar table), 44 DAX measures (time intelligence, dynamic ranking with RANKX/TOPN, dip/recovery calculations), and 7 dashboard pages with cross-filtering and drill-through. See [`/powerbi`](./powerbi).

## 🔄 Data Flow / Architecture
Click the image to view full size.

[![Data Flow Architecture](./powerbi/dataflow_architecture.png)](./powerbi/dataflow_architecture.png)

Excel (raw data + 7 workbooks) → 10 CSV files → MySQL (10 tables, 22 indexes) → SQL analysis (53 queries, 6 procedures, 3 views) → Power BI (44 DAX measures) → 7 interactive dashboard pages.

## 🧩 Data Model / Star Schema
Confirmed directly from the Power BI Model view. Click the image to view full size.

[![Power BI Model Schema](./powerbi/screenshots/power_bi_model_schema.png)](./powerbi/screenshots/power_bi_model_schema.png)

`raw_sales_data` (fact, 1,03,842 rows) → `product_catalogue` (1) on `Product_ID` · → `customer_master` (1) on `Customer_ID` · → `Calendar` (1) on `Date`

## 📈 Dashboards
All 7 pages below — click any image to open the full-size screenshot.

### 1. Executive Summary
[![Executive Summary](./powerbi/screenshots/01_executive_summary.png)](./powerbi/screenshots/01_executive_summary.png)

**Key Insights:**
- Total NET Revenue: **₹77.39 Cr** | Transactions: **1,03,842** | Unique Customers: **150** | Units Sold: **14.80L**
- Top 3 regions (Delhi NCR, Haryana, Uttar Pradesh) account for **71%** of total revenue.

### 2. Regional Performance
[![Regional Performance](./powerbi/screenshots/02_regional_performance.png)](./powerbi/screenshots/02_regional_performance.png)

**Key Insights:**
- **Delhi NCR** alone drives **38.0%** of revenue (₹29.4 Cr).
- **Haryana (18.0%)** and **Uttar Pradesh (15.0%)** follow as the next-largest markets.

### 3. Product Analysis
[![Product Analysis](./powerbi/screenshots/03_product_analysis.png)](./powerbi/screenshots/03_product_analysis.png)

**Key Insights:**
- **Industrial Valves** dominate at **78.5%** of revenue across 8 SKUs.
- **Medical Valves (14.3%)** and **Fire Fighting Valves (6.1%)** make up the rest of the mix.

### 4. Customer & Salesperson Dashboard
[![Customer & Salesperson Dashboard](./powerbi/screenshots/04_customer_salesperson.png)](./powerbi/screenshots/04_customer_salesperson.png)

**Key Insights:**
- 15 salespeople tracked; the **top 3** handle **~48%** of all transactions.
- Customer value segmented by Pricing_Tier and Annual_Purchase_Value_INR.

### 5. Marketing Analytics: Extended Reach
[![Extended Reach](./powerbi/screenshots/05_extended_reach.png)](./powerbi/screenshots/05_extended_reach.png)

**Key Insights:**
- Tracks expansion into Gujarat, Maharashtra, and Telangana as "extended reach" markets.
- Includes port-dispatch analysis for Mundra and Kandla/Gandhidham.

### 6. Dip Analysis 2024
[![Dip Analysis 2024](./powerbi/screenshots/06_dip_analysis_2024.png)](./powerbi/screenshots/06_dip_analysis_2024.png)

**Key Insights:**
- Isolates the **May-September 2024** revenue dip by region, product, and salesperson.
- Most salespeople show a **5-13% YoY decline** in 2024 vs. 2023.

### 7. Recovery and Recommendations
[![Recovery and Recommendations](./powerbi/screenshots/07_recovery_recommendations.png)](./powerbi/screenshots/07_recovery_recommendations.png)

**Key Insights:**
- Quantifies the 2025 recovery against the 2024 dip, region by region.
- Closes with prioritized, data-backed recommendations for management.

Full Power BI file: [`powerbi/BHARTIYA_VALVES_PROJECT.pbix`](./powerbi/BHARTIYA_VALVES_PROJECT.pbix) · All 44 DAX formulas: [`powerbi/DAX_measures.md`](./powerbi/DAX_measures.md)

## 🚀 How to Use This Project
```bash
git clone https://github.com/ankitabisht-data-analyst/bhartiyaa-valves-sales-analytics-excel-sql-powerbi.git
```
1. Create a MySQL database named `bhartiya_valves` and run [`sql/01_schema_creation.sql`](./sql/01_schema_creation.sql) to create all 10 tables (this also loads data via `LOAD DATA LOCAL INFILE` from `/data`).
2. Run [`sql/02_indexes.sql`](./sql/02_indexes.sql) to add the 22 performance indexes.
3. Run [`sql/03_analysis_queries.sql`](./sql/03_analysis_queries.sql) and [`sql/04_procedures_and_views.sql`](./sql/04_procedures_and_views.sql) to build out the analysis layer, procedures, and views.
4. Open [`powerbi/BHARTIYA_VALVES_PROJECT.pbix`](./powerbi/BHARTIYA_VALVES_PROJECT.pbix) in Power BI Desktop and refresh the data source to point to your local MySQL connection.

## 🐞 Data Cleaning & Debugging Highlights
| Issue | Root Cause | Fix |
|---|---|---|
| `YEAR()` / date formulas failing | Dates stored as text, not true Excel dates | Reformatted `Date` column to proper datetime |
| 42-59 duplicate customer names | Same customer entered under multiple `Customer_ID`s | Deduplicated by ranking on `Customer_ID` |
| Power BI showing a "(Blank)" product category | `PRD-012` missing from `Product_Master` | Added missing product dimension row |
| Haryana cities excluded from NCR | Incorrect manual region mapping | Corrected using the official NCR Planning Board 14-district list |
| TOPN/SUMMARIZE measures not responding to year slicer | Static ranking logic | Rebuilt with `ADDCOLUMNS` + `RANKX` |
| Achievement Rate % showing 9496% instead of ~95% | Percentage multiplied twice | Removed duplicate `*100` |

## 📈 Skills Demonstrated
`Excel` `Advanced Formulas` `MySQL` `Data Modeling` `Star Schema` `Stored Procedures` `SQL Views` `Window Functions` `DAX` `Power BI` `Data Cleaning` `ETL` `Data Visualization` `Business Analytics` `Dashboard Design` `KPI Reporting`

## 🤖 AI-Assisted Workflow
Every data model, SQL query, DAX formula, and business insight in this project is mine. AI was used deliberately for debugging (e.g. the RANKX slicer fix, the double-multiplication % bug), documentation, and cross-checking SQL output against Excel formulas — knowing when and how to use AI without letting it replace analytical judgment is part of how I work.

## 📬 Contact
**Ankita Bisht** — Data Analyst
[LinkedIn](https://www.linkedin.com/in/ankita-bisht09) · [GitHub](https://github.com/ankitabisht-data-analyst)
