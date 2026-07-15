-- ============================================================
-- BHARTIYA VALVES — INDEXES & DATA CLEANING
-- File: 02_indexes_and_cleaning.sql
-- Run this BEFORE any analysis queries
-- ============================================================

USE bhartiya_valves;

-- ============================================================
-- SECTION 1: CREATE ALL ADDITIONAL INDEXES
-- ============================================================
-- Purpose: Optimize query performance on 1,03,842 rows
-- Without indexes, every query does a full table scan
-- With indexes, MySQL jumps directly to relevant rows
-- ============================================================

-- Index 1: Product Category
-- Used in: GROUP BY Product_Category, WHERE Product_Category = ?
CREATE INDEX idx_product_category
ON raw_sales_data (Product_Category);

-- Index 2: Customer Type
-- Used in: Segment analysis, WHERE Customer_Type = ?
CREATE INDEX idx_customer_type
ON raw_sales_data (Customer_Type);

-- Index 3: Delivery Mode
-- Used in: Channel mix analysis, WHERE Delivery_Mode = ?
CREATE INDEX idx_delivery_mode
ON raw_sales_data (Delivery_Mode);

-- Index 4: Year + Region (composite)
-- Used in: Dip analysis — comparing regions across years
CREATE INDEX idx_year_region
ON raw_sales_data (Year, Region);

-- Index 5: Year + Product Category (composite)
-- Used in: Product mix by year queries
CREATE INDEX idx_year_product_cat
ON raw_sales_data (Year, Product_Category);

-- Index 6: Net Amount
-- Used in: Revenue ranking, SUM, ORDER BY revenue
CREATE INDEX idx_net_amount
ON raw_sales_data (Net_Amount_INR);

-- Index 7: Quarter
-- Used in: Quarterly analysis queries
CREATE INDEX idx_quarter
ON raw_sales_data (Quarter);

-- Index 8: Payment Method
-- Used in: Payment method analysis
CREATE INDEX idx_payment_method
ON raw_sales_data (Payment_Method);

-- Index 9: City
-- Used in: City level analysis queries
CREATE INDEX idx_city
ON raw_sales_data (City);

-- Index 10: Discount Percent
-- Used in: Discount analysis, legacy pricing queries
CREATE INDEX idx_discount
ON raw_sales_data (Discount_Percent);

-- Index 11: Year + Customer_ID (composite)
-- Used in: Customer loyalty analysis during dip
CREATE INDEX idx_year_customer
ON raw_sales_data (Year, Customer_ID);

-- Index 12: Year + Salesperson_ID (composite)
-- Used in: Salesperson YoY performance
CREATE INDEX idx_year_salesperson
ON raw_sales_data (Year, Salesperson_ID);

-- Index 13: Month_Number + Region (composite)
-- Used in: Monthly regional dip pattern queries
CREATE INDEX idx_month_region
ON raw_sales_data (Month_Number, Region);

-- ---- customer_master indexes ----

-- Index 14: Customer Region
CREATE INDEX idx_cm_region
ON customer_master (Region);

-- Index 15: Customer Type
CREATE INDEX idx_cm_type
ON customer_master (Customer_Type);

-- Index 16: Customer Rating
CREATE INDEX idx_cm_rating
ON customer_master (Customer_Rating);

-- Index 17: Customer Since
CREATE INDEX idx_cm_since
ON customer_master (Customer_Since);

-- Index 18: Pricing Tier
-- Used in: Legacy vs standard customer analysis
CREATE INDEX idx_cm_tier
ON customer_master (Pricing_Tier);

-- ---- sales_targets_monthly indexes ----

-- Index 19: Year
CREATE INDEX idx_stm_year
ON sales_targets_monthly (Year);

-- ---- sales_targets_region indexes ----

-- Index 20: Region
CREATE INDEX idx_str_region
ON sales_targets_region (Region);

-- ---- kpi_dashboard indexes ----

-- Index 21: KPI Name
CREATE INDEX idx_kpi_name
ON kpi_dashboard (KPI_Name);

-- Index 22: Year + Month
CREATE INDEX idx_kpi_year_month
ON kpi_dashboard (Year, Month);

-- Verify all indexes created
SELECT
    TABLE_NAME,
    INDEX_NAME,
    COLUMN_NAME,
    SEQ_IN_INDEX
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'bhartiya_valves'
ORDER BY TABLE_NAME, INDEX_NAME;


