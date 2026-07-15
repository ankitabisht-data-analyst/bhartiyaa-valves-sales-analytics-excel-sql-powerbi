# SQL

10 tables, 22 indexes, 53 queries, 6 stored procedures, 3 views — all built on the CSVs in `../data/`.

| File | Contents |
|---|---|
| [`01_schema_creation.sql`](./01_schema_creation.sql) | 10 `CREATE TABLE` statements (PK/FK constraints) + `LOAD DATA INFILE` for all 10 CSVs, loaded fact-table-last |
| [`02_indexes.sql`](./02_indexes.sql) | 22 performance indexes on `raw_sales_data`, `customer_master`, `sales_targets_monthly`, `sales_targets_region`, `kpi_dashboard` — each commented with the query pattern it optimizes |
| [`03_analysis_queries.sql`](./03_analysis_queries.sql) | 53 queries in 4 sections: **A** Basic (8) - **B** Intermediate joins/pivots (20) - **C** Advanced window functions/CTEs (15) - **D** Dip & Recovery root-cause analysis (10) |
| [`04_procedures_and_views.sql`](./04_procedures_and_views.sql) | 6 parameterized stored procedures + 3 views feeding Power BI |

## Stored Procedures
`GetRevenueByRegion(region, year)` - `GetTopNCustomers(n, year)` - `GetSalespersonScorecard(sp_id)` - `GetDipAnalysis(year1, year2)` - `GetProductPerformance(...)` - `GetPaymentCollectionReport(year)`

## Views
`vw_monthly_revenue_summary` (monthly revenue vs. target, tagged Dip/Recovery/Normal period) - `vw_customer_360` (full customer profile with year-wise revenue, value band, activity status) - `vw_region_product_summary` (region x product performance)
