-- ============================================================
-- BHARTIYA VALVES — COMPLETE ANALYSIS QUERIES
-- File: 03_analysis_queries.sql
-- Total Queries: 60
-- Intern: Ankita | Duration: 5 Months | Jan 2023 – Jun 2026
-- ============================================================
-- BUSINESS CONTEXT:
-- Bhartiya Valves, Faridabad (Est. 1989) — brass valve manufacturer
-- Serving 150 B2B customers across 8 regions
-- 12 product types | 15 salespersons | ₹77.39 Cr revenue (3.5 years)
-- Key story: 2024 revenue dip → root cause → 2025 recovery
-- ============================================================

USE bhartiya_valves;

-- ============================================================
-- SECTION A: BASIC QUERIES (8 Queries)
-- Business Question: What does the overall business look like?
-- ============================================================

-- ============================================================
-- QUERY A1: Overall Business Summary
-- Business Question: What is the complete picture of Bhartiya
-- Valves sales from Jan 2023 to Jun 2026?
-- ============================================================
SELECT 'QUERY A1: OVERALL BUSINESS SUMMARY' AS Query_Title;

SELECT
    COUNT(DISTINCT Transaction_ID)              AS Total_Transactions,
    COUNT(DISTINCT Customer_ID)                 AS Total_Customers,
    COUNT(DISTINCT Product_ID)                  AS Total_Products,
    COUNT(DISTINCT Region)                      AS Total_Regions,
    COUNT(DISTINCT Salesperson_ID)              AS Total_Salespersons,
    SUM(Quantity_Sold)                          AS Total_Units_Sold,
    ROUND(SUM(Gross_Amount_INR)/10000000, 2)    AS Gross_Revenue_Crore,
    ROUND(SUM(Discount_Amount_INR)/10000000, 2) AS Total_Discount_Crore,
    ROUND(SUM(Net_Amount_INR)/10000000, 2)      AS NET_Revenue_Crore,
    ROUND(SUM(GST_Amount_INR)/10000000, 2)      AS Total_GST_Crore,
    ROUND(SUM(Total_Invoice_Amount_INR)/10000000,2) AS Total_Invoice_Crore,
    ROUND(AVG(Net_Amount_INR), 2)               AS Avg_Order_Value_INR,
    MIN(Date)                                   AS First_Transaction,
    MAX(Date)                                   AS Last_Transaction
FROM raw_sales_data;


-- ============================================================
-- QUERY A2: Year-wise Revenue Summary
-- Business Question: How did annual revenue change year over year?
-- Which year was best and which was worst?
-- ============================================================
SELECT 'QUERY A2: YEAR-WISE REVENUE SUMMARY' AS Query_Title;

SELECT
    Year,
    COUNT(*)                                        AS Total_Transactions,
    SUM(Quantity_Sold)                              AS Units_Sold,
    ROUND(SUM(Net_Amount_INR)/10000000, 3)          AS NET_Revenue_Crore,
    ROUND(AVG(Net_Amount_INR), 2)                   AS Avg_Order_Value_INR,
    ROUND(AVG(Discount_Percent), 2)                 AS Avg_Discount_Pct,
    COUNT(DISTINCT Customer_ID)                     AS Active_Customers
FROM raw_sales_data
GROUP BY Year
ORDER BY Year;


-- ============================================================
-- QUERY A3: Region-wise Revenue Overview
-- Business Question: Which regions contribute most to revenue?
-- Where should we focus our sales efforts?
-- ============================================================
SELECT 'QUERY A3: REGION-WISE REVENUE OVERVIEW' AS Query_Title;

SELECT
    Region,
    COUNT(*)                                                AS Total_Transactions,
    COUNT(DISTINCT Customer_ID)                             AS Unique_Customers,
    SUM(Quantity_Sold)                                      AS Units_Sold,
    ROUND(SUM(Net_Amount_INR)/10000000, 3)                  AS NET_Revenue_Crore,
    ROUND(SUM(Net_Amount_INR)/SUM(SUM(Net_Amount_INR))
          OVER() * 100, 1)                                  AS Revenue_Share_Pct,
    ROUND(AVG(Net_Amount_INR), 2)                           AS Avg_Order_Value_INR
FROM raw_sales_data
GROUP BY Region
ORDER BY NET_Revenue_Crore DESC;


-- ============================================================
-- QUERY A4: Product-wise Sales Overview
-- Business Question: Which products generate most revenue?
-- What is our product mix?
-- ============================================================
SELECT 'QUERY A4: PRODUCT-WISE SALES OVERVIEW' AS Query_Title;

SELECT
    Product_Category,
    Product_Name,
    COUNT(*)                                    AS Total_Orders,
    SUM(Quantity_Sold)                          AS Total_Units,
    ROUND(SUM(Net_Amount_INR)/10000000, 3)      AS NET_Revenue_Crore,
    ROUND(AVG(Unit_Price_INR), 2)               AS Avg_Unit_Price_INR,
    ROUND(AVG(Discount_Percent), 2)             AS Avg_Discount_Pct
FROM raw_sales_data
GROUP BY Product_Category, Product_Name
ORDER BY NET_Revenue_Crore DESC;


-- ============================================================
-- QUERY A5: Customer Type Distribution
-- Business Question: Which type of customer is most valuable?
-- Where should marketing focus?
-- ============================================================
SELECT 'QUERY A5: CUSTOMER TYPE DISTRIBUTION' AS Query_Title;

SELECT
    Customer_Type,
    COUNT(DISTINCT Customer_ID)                 AS Total_Customers,
    COUNT(*)                                    AS Total_Orders,
    ROUND(AVG(Net_Amount_INR), 2)               AS Avg_Order_Value_INR,
    ROUND(SUM(Net_Amount_INR)/10000000, 3)      AS NET_Revenue_Crore,
    ROUND(SUM(Net_Amount_INR)/SUM(SUM(Net_Amount_INR))
          OVER() * 100, 1)                      AS Revenue_Share_Pct,
    ROUND(AVG(Discount_Percent), 2)             AS Avg_Discount_Pct
FROM raw_sales_data
GROUP BY Customer_Type
ORDER BY NET_Revenue_Crore DESC;


-- ============================================================
-- QUERY A6: Monthly Revenue Trend
-- Business Question: How does revenue flow month by month?
-- Can we see the 2024 dip clearly?
-- ============================================================
SELECT 'QUERY A6: MONTHLY REVENUE TREND' AS Query_Title;

SELECT
    Year,
    Month_Number,
    Month_Name,
    Quarter,
    COUNT(*)                                    AS Transactions,
    SUM(Quantity_Sold)                          AS Units_Sold,
    ROUND(SUM(Net_Amount_INR)/100000, 2)        AS NET_Revenue_Lakhs,
    ROUND(AVG(Net_Amount_INR), 2)               AS Avg_Order_Value_INR
FROM raw_sales_data
GROUP BY Year, Month_Number, Month_Name, Quarter
ORDER BY Year, Month_Number;


-- ============================================================
-- QUERY A7: Payment Status Overview
-- Business Question: How much money is collected vs outstanding?
-- What is our cash flow situation?
-- ============================================================
SELECT 'QUERY A7: PAYMENT STATUS OVERVIEW' AS Query_Title;

SELECT
    Payment_Status,
    COUNT(*)                                    AS Total_Orders,
    ROUND(COUNT(*)/103842*100, 1)               AS Pct_of_Orders,
    ROUND(SUM(Net_Amount_INR)/10000000, 3)      AS Revenue_Crore,
    ROUND(SUM(Net_Amount_INR)/
          SUM(SUM(Net_Amount_INR)) OVER()*100,1) AS Revenue_Share_Pct,
    ROUND(AVG(Net_Amount_INR), 2)               AS Avg_Order_Value_INR
FROM raw_sales_data
GROUP BY Payment_Status
ORDER BY Revenue_Crore DESC;


-- ============================================================
-- QUERY A8: Delivery Mode Analysis
-- Business Question: How are we reaching our customers?
-- Which delivery channel is most used?
-- ============================================================
SELECT 'QUERY A8: DELIVERY MODE ANALYSIS' AS Query_Title;

SELECT
    Delivery_Mode,
    COUNT(*)                                    AS Total_Orders,
    ROUND(COUNT(*)/103842*100, 1)               AS Pct_of_Orders,
    ROUND(SUM(Net_Amount_INR)/10000000, 3)      AS Revenue_Crore,
    ROUND(AVG(Net_Amount_INR), 2)               AS Avg_Order_Value_INR,
    COUNT(DISTINCT Customer_ID)                 AS Unique_Customers
FROM raw_sales_data
GROUP BY Delivery_Mode
ORDER BY Revenue_Crore DESC;


-- ============================================================
-- SECTION B: INTERMEDIATE QUERIES (20 Queries)
-- Business Question: How do different parts of the business
-- perform? What patterns emerge when we dig deeper?
-- ============================================================


-- ============================================================
-- QUERY B1: Top 15 Customers by Revenue (JOIN)
-- Business Question: Who are our most valuable customers?
-- What is their profile and how should we retain them?
-- ============================================================
SELECT 'QUERY B1: TOP 15 CUSTOMERS BY REVENUE' AS Query_Title;

SELECT
    s.Customer_ID,
    s.Customer_Name,
    c.Customer_Type,
    c.Pricing_Tier,
    c.Customer_Rating,
    c.Customer_Since,
    s.Region,
    COUNT(s.Transaction_ID)                     AS Total_Orders,
    SUM(s.Quantity_Sold)                        AS Total_Units,
    ROUND(SUM(s.Net_Amount_INR)/100000, 2)      AS Revenue_Lakhs,
    ROUND(AVG(s.Net_Amount_INR), 2)             AS Avg_Order_Value_INR,
    ROUND(AVG(s.Discount_Percent), 1)           AS Avg_Discount_Pct
FROM raw_sales_data s
JOIN customer_master c ON s.Customer_ID = c.Customer_ID
GROUP BY s.Customer_ID, s.Customer_Name, c.Customer_Type,
         c.Pricing_Tier, c.Customer_Rating, c.Customer_Since, s.Region
ORDER BY Revenue_Lakhs DESC
LIMIT 15;


-- ============================================================
-- QUERY B2: Salesperson Performance Scorecard (JOIN)
-- Business Question: Which salesperson is performing best?
-- Who needs support and coaching?
-- ============================================================
SELECT 'QUERY B2: SALESPERSON PERFORMANCE SCORECARD' AS Query_Title;

SELECT
    s.Salesperson_ID,
    s.Salesperson_Name,
    GROUP_CONCAT(DISTINCT s.Region ORDER BY s.Region SEPARATOR ' | ') AS Regions_Handled,
    COUNT(s.Transaction_ID)                     AS Total_Orders,
    COUNT(DISTINCT s.Customer_ID)               AS Unique_Customers,
    SUM(s.Quantity_Sold)                        AS Units_Sold,
    ROUND(SUM(s.Net_Amount_INR)/10000000, 3)    AS Revenue_Crore,
    ROUND(AVG(s.Net_Amount_INR), 2)             AS Avg_Order_Value_INR,
    ROUND(AVG(s.Discount_Percent), 2)           AS Avg_Discount_Given_Pct
FROM raw_sales_data s
GROUP BY s.Salesperson_ID, s.Salesperson_Name
ORDER BY Revenue_Crore DESC;


-- ============================================================
-- QUERY B3: Product Category Revenue by Year
-- Business Question: How has product mix changed over years?
-- Did medical/fire fighting valves grow during dip?
-- ============================================================
SELECT 'QUERY B3: PRODUCT CATEGORY REVENUE BY YEAR' AS Query_Title;

SELECT
    Product_Category,
    ROUND(SUM(CASE WHEN Year = 2023 THEN Net_Amount_INR ELSE 0 END)/10000000, 3) AS Rev_2023_Cr,
    ROUND(SUM(CASE WHEN Year = 2024 THEN Net_Amount_INR ELSE 0 END)/10000000, 3) AS Rev_2024_Cr,
    ROUND(SUM(CASE WHEN Year = 2025 THEN Net_Amount_INR ELSE 0 END)/10000000, 3) AS Rev_2025_Cr,
    ROUND(SUM(CASE WHEN Year = 2026 THEN Net_Amount_INR ELSE 0 END)/10000000, 3) AS Rev_2026_H1_Cr,
    ROUND(SUM(Net_Amount_INR)/10000000, 3)                                        AS Total_Cr,
    ROUND(
        (SUM(CASE WHEN Year=2024 THEN Net_Amount_INR ELSE 0 END) -
         SUM(CASE WHEN Year=2023 THEN Net_Amount_INR ELSE 0 END)) /
         SUM(CASE WHEN Year=2023 THEN Net_Amount_INR ELSE 0 END) * 100
    , 1)                                                                           AS YoY_2024_vs_2023_Pct
FROM raw_sales_data
GROUP BY Product_Category
ORDER BY Total_Cr DESC;


-- ============================================================
-- QUERY B4: Region Performance by Year (CASE WHEN Pivot)
-- Business Question: Which region was most affected by 2024 dip?
-- Which recovered fastest in 2025?
-- ============================================================
SELECT 'QUERY B4: REGION PERFORMANCE BY YEAR' AS Query_Title;

SELECT
    Region,
    ROUND(SUM(CASE WHEN Year=2023 THEN Net_Amount_INR ELSE 0 END)/10000000,3) AS Rev_2023_Cr,
    ROUND(SUM(CASE WHEN Year=2024 THEN Net_Amount_INR ELSE 0 END)/10000000,3) AS Rev_2024_Cr,
    ROUND(SUM(CASE WHEN Year=2025 THEN Net_Amount_INR ELSE 0 END)/10000000,3) AS Rev_2025_Cr,
    ROUND(SUM(CASE WHEN Year=2026 THEN Net_Amount_INR ELSE 0 END)/10000000,3) AS Rev_2026_H1_Cr,
    ROUND(
        (SUM(CASE WHEN Year=2024 THEN Net_Amount_INR ELSE 0 END) -
         SUM(CASE WHEN Year=2023 THEN Net_Amount_INR ELSE 0 END)) /
         SUM(CASE WHEN Year=2023 THEN Net_Amount_INR ELSE 0 END) * 100
    ,1)                                                                        AS Dip_Pct_2024,
    ROUND(
        (SUM(CASE WHEN Year=2025 THEN Net_Amount_INR ELSE 0 END) -
         SUM(CASE WHEN Year=2024 THEN Net_Amount_INR ELSE 0 END)) /
         SUM(CASE WHEN Year=2024 THEN Net_Amount_INR ELSE 0 END) * 100
    ,1)                                                                        AS Recovery_Pct_2025
FROM raw_sales_data
GROUP BY Region
ORDER BY Dip_Pct_2024 ASC;


-- ============================================================
-- QUERY B5: Quarterly Revenue Analysis
-- Business Question: Which quarter is strongest?
-- Is Q3 consistently weakest due to monsoon?
-- ============================================================
SELECT 'QUERY B5: QUARTERLY REVENUE ANALYSIS' AS Query_Title;

SELECT
    Year,
    Quarter,
    COUNT(*)                                    AS Transactions,
    ROUND(SUM(Net_Amount_INR)/100000, 2)        AS Revenue_Lakhs,
    ROUND(AVG(Net_Amount_INR), 2)               AS Avg_Order_Value,
    SUM(Quantity_Sold)                          AS Units_Sold,
    ROUND(SUM(Net_Amount_INR)/
          SUM(SUM(Net_Amount_INR)) OVER(PARTITION BY Year)*100,1) AS Qtr_Share_in_Year_Pct
FROM raw_sales_data
GROUP BY Year, Quarter
ORDER BY Year, Quarter;


-- ============================================================
-- QUERY B6: Legacy vs Standard Customer Comparison (JOIN)
-- Business Question: Do legacy customers generate more value?
-- Is the preferential pricing justified?
-- ============================================================
SELECT 'QUERY B6: LEGACY VS STANDARD CUSTOMER COMPARISON' AS Query_Title;

SELECT
    c.Pricing_Tier,
    COUNT(DISTINCT c.Customer_ID)               AS Customer_Count,
    COUNT(s.Transaction_ID)                     AS Total_Orders,
    ROUND(AVG(s.Net_Amount_INR), 2)             AS Avg_Order_Value_INR,
    ROUND(SUM(s.Net_Amount_INR)/10000000, 3)    AS Total_Revenue_Crore,
    ROUND(AVG(s.Discount_Percent), 2)           AS Avg_Discount_Pct,
    ROUND(SUM(s.Net_Amount_INR)/
          COUNT(DISTINCT c.Customer_ID)/10000000, 4) AS Revenue_Per_Customer_Crore,
    ROUND(COUNT(s.Transaction_ID)/
          COUNT(DISTINCT c.Customer_ID), 1)     AS Orders_Per_Customer
FROM customer_master c
JOIN raw_sales_data s ON c.Customer_ID = s.Customer_ID
GROUP BY c.Pricing_Tier;


-- ============================================================
-- QUERY B7: Payment Collection by Region
-- Business Question: Which region has worst payment collection?
-- Where is credit risk highest?
-- ============================================================
SELECT 'QUERY B7: PAYMENT COLLECTION BY REGION' AS Query_Title;

SELECT
    Region,
    COUNT(*)                                                AS Total_Orders,
    SUM(CASE WHEN Payment_Status='Paid'    THEN 1 ELSE 0 END) AS Paid_Orders,
    SUM(CASE WHEN Payment_Status='Pending' THEN 1 ELSE 0 END) AS Pending_Orders,
    SUM(CASE WHEN Payment_Status='Partial' THEN 1 ELSE 0 END) AS Partial_Orders,
    ROUND(SUM(CASE WHEN Payment_Status='Paid' THEN 1 ELSE 0 END)/COUNT(*)*100,1) AS Collection_Rate_Pct,
    ROUND(SUM(CASE WHEN Payment_Status IN ('Pending','Partial')
              THEN Net_Amount_INR ELSE 0 END)/100000, 2)    AS Outstanding_Lakhs
FROM raw_sales_data
GROUP BY Region
ORDER BY Collection_Rate_Pct ASC;


-- ============================================================
-- QUERY B8: Salesperson Target vs Achievement (JOIN)
-- Business Question: Are salespersons meeting their targets?
-- Who exceeded and who fell short during the dip year?
-- ============================================================
SELECT 'QUERY B8: SALESPERSON TARGET VS ACHIEVEMENT' AS Query_Title;

SELECT
    s.Salesperson_Name,
    s.Salesperson_ID,
    ROUND(SUM(CASE WHEN r.Year=2023 THEN r.Net_Amount_INR ELSE 0 END)/10000000,3) AS Actual_2023_Cr,
    ROUND(SUM(CASE WHEN r.Year=2024 THEN r.Net_Amount_INR ELSE 0 END)/10000000,3) AS Actual_2024_Cr,
    ROUND(SUM(CASE WHEN r.Year=2025 THEN r.Net_Amount_INR ELSE 0 END)/10000000,3) AS Actual_2025_Cr,
    ROUND(
        (SUM(CASE WHEN r.Year=2024 THEN r.Net_Amount_INR ELSE 0 END) -
         SUM(CASE WHEN r.Year=2023 THEN r.Net_Amount_INR ELSE 0 END)) /
         NULLIF(SUM(CASE WHEN r.Year=2023 THEN r.Net_Amount_INR ELSE 0 END),0)*100
    ,1)                                                                             AS Dip_Impact_Pct,
    ROUND(
        (SUM(CASE WHEN r.Year=2025 THEN r.Net_Amount_INR ELSE 0 END) -
         SUM(CASE WHEN r.Year=2024 THEN r.Net_Amount_INR ELSE 0 END)) /
         NULLIF(SUM(CASE WHEN r.Year=2024 THEN r.Net_Amount_INR ELSE 0 END),0)*100
    ,1)                                                                             AS Recovery_Pct,
    CASE
        WHEN (SUM(CASE WHEN r.Year=2025 THEN r.Net_Amount_INR ELSE 0 END) -
              SUM(CASE WHEN r.Year=2024 THEN r.Net_Amount_INR ELSE 0 END)) /
              NULLIF(SUM(CASE WHEN r.Year=2024 THEN r.Net_Amount_INR ELSE 0 END),0)*100 > 20
        THEN 'Strong Recovery'
        WHEN (SUM(CASE WHEN r.Year=2025 THEN r.Net_Amount_INR ELSE 0 END) -
              SUM(CASE WHEN r.Year=2024 THEN r.Net_Amount_INR ELSE 0 END)) /
              NULLIF(SUM(CASE WHEN r.Year=2024 THEN r.Net_Amount_INR ELSE 0 END),0)*100 > 10
        THEN 'Moderate Recovery'
        ELSE 'Needs Attention'
    END AS Recovery_Status
FROM region_salesperson_map s
JOIN raw_sales_data r ON s.Salesperson_ID = r.Salesperson_ID
GROUP BY s.Salesperson_Name, s.Salesperson_ID
ORDER BY Actual_2025_Cr DESC;


-- ============================================================
-- QUERY B9: Customer Rating vs Revenue (JOIN + HAVING)
-- Business Question: Do A-rated customers buy more?
-- Should we upgrade B customers to improve revenue?
-- ============================================================
SELECT 'QUERY B9: CUSTOMER RATING VS REVENUE ANALYSIS' AS Query_Title;

SELECT
    c.Customer_Rating,
    COUNT(DISTINCT c.Customer_ID)               AS Customer_Count,
    COUNT(s.Transaction_ID)                     AS Total_Orders,
    ROUND(SUM(s.Net_Amount_INR)/10000000, 3)    AS Total_Revenue_Crore,
    ROUND(AVG(s.Net_Amount_INR), 2)             AS Avg_Order_Value_INR,
    ROUND(SUM(s.Net_Amount_INR)/
          COUNT(DISTINCT c.Customer_ID)/100000, 2) AS Avg_Revenue_Per_Customer_Lakhs,
    ROUND(COUNT(s.Transaction_ID)/
          COUNT(DISTINCT c.Customer_ID), 1)     AS Avg_Orders_Per_Customer
FROM customer_master c
JOIN raw_sales_data s ON c.Customer_ID = s.Customer_ID
GROUP BY c.Customer_Rating
ORDER BY Total_Revenue_Crore DESC;


-- ============================================================
-- QUERY B10: City-wise Revenue Analysis (JOIN)
-- Business Question: Which cities are our strongest markets?
-- Where should we open new dealer networks?
-- ============================================================
SELECT 'QUERY B10: CITY-WISE REVENUE ANALYSIS' AS Query_Title;

SELECT
    s.City,
    s.Region,
    COUNT(*)                                    AS Total_Orders,
    COUNT(DISTINCT s.Customer_ID)               AS Unique_Customers,
    ROUND(SUM(s.Net_Amount_INR)/100000, 2)      AS Revenue_Lakhs,
    ROUND(AVG(s.Net_Amount_INR), 2)             AS Avg_Order_Value_INR
FROM raw_sales_data s
JOIN region_city_map c ON s.City = c.City_Name
GROUP BY s.City, s.Region
HAVING Revenue_Lakhs > 50
ORDER BY Revenue_Lakhs DESC
LIMIT 20;


-- ============================================================
-- QUERY B11: Month-wise Units Sold vs 30k-35k Target
-- Business Question: Are we meeting our production/sales target
-- of 30,000-35,000 units per month?
-- ============================================================
SELECT 'QUERY B11: MONTHLY UNITS VS 30K-35K TARGET' AS Query_Title;

SELECT
    Year,
    Month_Number,
    Month_Name,
    SUM(Quantity_Sold)                          AS Actual_Units,
    32500                                       AS Monthly_Target_Units,
    SUM(Quantity_Sold) - 32500                  AS Variance_Units,
    CASE
        WHEN SUM(Quantity_Sold) >= 35000 THEN 'Exceeded Target'
        WHEN SUM(Quantity_Sold) >= 30000 THEN 'Met Target'
        WHEN SUM(Quantity_Sold) >= 25000 THEN 'Near Target'
        ELSE 'Below Target — Action Required'
    END AS Target_Status
FROM raw_sales_data
GROUP BY Year, Month_Number, Month_Name
ORDER BY Year, Month_Number;


-- ============================================================
-- QUERY B12: Discount Analysis by Customer Type
-- Business Question: Are we giving too much discount to
-- certain customer types? Where can we improve margin?
-- ============================================================
SELECT 'QUERY B12: DISCOUNT ANALYSIS BY CUSTOMER TYPE' AS Query_Title;

SELECT
    Customer_Type,
    COUNT(*)                                    AS Total_Orders,
    SUM(CASE WHEN Discount_Percent = 0  THEN 1 ELSE 0 END) AS No_Discount_Orders,
    SUM(CASE WHEN Discount_Percent > 0
             AND Discount_Percent <= 3  THEN 1 ELSE 0 END) AS Low_Discount_Orders,
    SUM(CASE WHEN Discount_Percent > 3
             AND Discount_Percent <= 7  THEN 1 ELSE 0 END) AS Mid_Discount_Orders,
    SUM(CASE WHEN Discount_Percent > 7  THEN 1 ELSE 0 END) AS High_Discount_Orders,
    ROUND(AVG(Discount_Percent), 2)             AS Avg_Discount_Pct,
    ROUND(SUM(Discount_Amount_INR)/100000, 2)   AS Total_Discount_Given_Lakhs,
    ROUND(SUM(Net_Amount_INR)/10000000, 3)      AS Net_Revenue_Crore
FROM raw_sales_data
GROUP BY Customer_Type
ORDER BY Avg_Discount_Pct DESC;


-- ============================================================
-- QUERY B13: Port Dispatch Analysis (Gujarat + Maharashtra)
-- Business Question: How significant is our port-based
-- Extended Reach business? Is it growing?
-- ============================================================
SELECT 'QUERY B13: PORT DISPATCH ANALYSIS' AS Query_Title;

SELECT
    Delivery_Mode,
    Region,
    Year,
    COUNT(*)                                    AS Total_Shipments,
    COUNT(DISTINCT Customer_ID)                 AS Customers_Served,
    SUM(Quantity_Sold)                          AS Units_Dispatched,
    ROUND(SUM(Net_Amount_INR)/100000, 2)        AS Revenue_Lakhs
FROM raw_sales_data
WHERE Delivery_Mode LIKE 'Port%'
GROUP BY Delivery_Mode, Region, Year
ORDER BY Delivery_Mode, Year;


-- ============================================================
-- QUERY B14: Customer Longevity vs Order Frequency (JOIN)
-- Business Question: Do older customers order more frequently?
-- Is loyalty driving revenue?
-- ============================================================
SELECT 'QUERY B14: CUSTOMER LONGEVITY VS ORDER FREQUENCY' AS Query_Title;

SELECT
    CASE
        WHEN c.Customer_Since <= 2005 THEN 'Pre-2006 (20+ years)'
        WHEN c.Customer_Since <= 2010 THEN '2006-2010 (15-20 years)'
        WHEN c.Customer_Since <= 2015 THEN '2011-2015 (10-15 years)'
        WHEN c.Customer_Since <= 2020 THEN '2016-2020 (5-10 years)'
        ELSE '2021+ (Recent)'
    END                                         AS Customer_Vintage,
    COUNT(DISTINCT c.Customer_ID)               AS Customer_Count,
    COUNT(s.Transaction_ID)                     AS Total_Orders,
    ROUND(COUNT(s.Transaction_ID)/
          COUNT(DISTINCT c.Customer_ID), 1)     AS Avg_Orders_Per_Customer,
    ROUND(SUM(s.Net_Amount_INR)/
          COUNT(DISTINCT c.Customer_ID)/100000,2) AS Avg_Revenue_Per_Customer_Lakhs,
    ROUND(AVG(s.Discount_Percent), 2)           AS Avg_Discount_Pct
FROM customer_master c
JOIN raw_sales_data s ON c.Customer_ID = s.Customer_ID
GROUP BY Customer_Vintage
ORDER BY MIN(c.Customer_Since);


-- ============================================================
-- QUERY B15: Targets vs Achievement Summary (JOIN)
-- Business Question: Overall how well did we achieve
-- our sales targets across all months?
-- ============================================================
SELECT 'QUERY B15: TARGETS VS ACHIEVEMENT SUMMARY' AS Query_Title;

SELECT
    Year,
    COUNT(*)                                            AS Total_Months,
    SUM(CASE WHEN Status='Exceeded' THEN 1 ELSE 0 END) AS Months_Exceeded,
    SUM(CASE WHEN Status='Met'      THEN 1 ELSE 0 END) AS Months_Met,
    SUM(CASE WHEN Status='Not Met'  THEN 1 ELSE 0 END) AS Months_Not_Met,
    ROUND(SUM(Monthly_Target_INR)/10000000, 3)          AS Total_Target_Crore,
    ROUND(SUM(Monthly_Actual_INR)/10000000, 3)          AS Total_Actual_Crore,
    ROUND(AVG(Achievement_Pct)*100, 1)                  AS Avg_Achievement_Pct
FROM sales_targets_monthly
GROUP BY Year
ORDER BY Year;


-- ============================================================
-- QUERY B16: KPI Performance Summary (JOIN)
-- Business Question: Which KPIs are we consistently
-- meeting and which need improvement?
-- ============================================================
SELECT 'QUERY B16: KPI PERFORMANCE SUMMARY' AS Query_Title;

SELECT
    KPI_Name,
    Unit,
    COUNT(*)                                                AS Total_Months_Tracked,
    SUM(CASE WHEN Status='Exceeded'     THEN 1 ELSE 0 END) AS Months_Exceeded,
    SUM(CASE WHEN Status='On Track'     THEN 1 ELSE 0 END) AS Months_On_Track,
    SUM(CASE WHEN Status='Below Target' THEN 1 ELSE 0 END) AS Months_Below_Target,
    ROUND(AVG(Achievement_Pct)*100, 1)                     AS Avg_Achievement_Pct,
    CASE
        WHEN AVG(Achievement_Pct) >= 1.05 THEN 'Consistently Exceeding'
        WHEN AVG(Achievement_Pct) >= 0.95 THEN 'Consistently On Track'
        ELSE 'Needs Improvement'
    END AS Overall_KPI_Status
FROM kpi_dashboard
GROUP BY KPI_Name, Unit
ORDER BY Avg_Achievement_Pct DESC;


-- ============================================================
-- QUERY B17: Product Performance by Region (Subquery)
-- Business Question: Which product sells best in each region?
-- Should we customize our product pitch by region?
-- ============================================================
SELECT 'QUERY B17: TOP PRODUCT PER REGION' AS Query_Title;

SELECT
    r.Region,
    r.Product_Name,
    r.Product_Category,
    r.Revenue_Crore
FROM (
    SELECT
        Region,
        Product_Name,
        Product_Category,
        ROUND(SUM(Net_Amount_INR)/10000000, 3) AS Revenue_Crore,
        RANK() OVER(PARTITION BY Region
                    ORDER BY SUM(Net_Amount_INR) DESC) AS Product_Rank
    FROM raw_sales_data
    GROUP BY Region, Product_Name, Product_Category
) r
WHERE r.Product_Rank = 1
ORDER BY r.Revenue_Crore DESC;


-- ============================================================
-- QUERY B18: Revenue Concentration Risk
-- Business Question: Are we too dependent on few customers?
-- What happens if top 10 customers leave?
-- ============================================================
SELECT 'QUERY B18: REVENUE CONCENTRATION RISK' AS Query_Title;

SELECT
    'Top 5 Customers'   AS Customer_Group,
    ROUND(SUM(Revenue_Lakhs)/SUM(SUM(Revenue_Lakhs)) OVER()*100,1) AS Revenue_Share_Pct,
    ROUND(SUM(Revenue_Lakhs)/100,2) AS Revenue_Crore
FROM (
    SELECT Customer_ID,
           SUM(Net_Amount_INR)/100000 AS Revenue_Lakhs
    FROM raw_sales_data
    GROUP BY Customer_ID
    ORDER BY Revenue_Lakhs DESC
    LIMIT 5
) top5

UNION ALL

SELECT 'Top 10 Customers',
    ROUND(SUM(Revenue_Lakhs)/
          (SELECT SUM(Net_Amount_INR)/100000 FROM raw_sales_data)*100,1),
    ROUND(SUM(Revenue_Lakhs)/100,2)
FROM (
    SELECT Customer_ID,
           SUM(Net_Amount_INR)/100000 AS Revenue_Lakhs
    FROM raw_sales_data
    GROUP BY Customer_ID
    ORDER BY Revenue_Lakhs DESC
    LIMIT 10
) top10

UNION ALL

SELECT 'Top 20 Customers',
    ROUND(SUM(Revenue_Lakhs)/
          (SELECT SUM(Net_Amount_INR)/100000 FROM raw_sales_data)*100,1),
    ROUND(SUM(Revenue_Lakhs)/100,2)
FROM (
    SELECT Customer_ID,
           SUM(Net_Amount_INR)/100000 AS Revenue_Lakhs
    FROM raw_sales_data
    GROUP BY Customer_ID
    ORDER BY Revenue_Lakhs DESC
    LIMIT 20
) top20;


-- ============================================================
-- QUERY B19: GST Collection Summary by Year
-- Business Question: How much GST are we collecting?
-- Useful for compliance and financial reporting
-- ============================================================
SELECT 'QUERY B19: GST COLLECTION SUMMARY' AS Query_Title;

SELECT
    Year,
    COUNT(*)                                        AS Total_Invoices,
    ROUND(SUM(Net_Amount_INR)/10000000, 3)          AS Net_Revenue_Crore,
    ROUND(SUM(GST_Amount_INR)/10000000, 3)          AS GST_Collected_Crore,
    ROUND(SUM(Total_Invoice_Amount_INR)/10000000, 3) AS Total_Invoice_Value_Crore,
    ROUND(AVG(GST_Rate_Percent), 0)                 AS GST_Rate_Pct
FROM raw_sales_data
GROUP BY Year
ORDER BY Year;


-- ============================================================
-- QUERY B20: Customer Acquisition by Year (JOIN)
-- Business Question: How many new customers did we acquire
-- each year? Did the dip reduce new customer acquisition?
-- ============================================================
SELECT 'QUERY B20: CUSTOMER ACQUISITION ANALYSIS' AS Query_Title;

SELECT
    Customer_Since AS Acquisition_Year,
    COUNT(*)       AS New_Customers_Acquired,
    GROUP_CONCAT(DISTINCT Pricing_Tier ORDER BY Pricing_Tier) AS Pricing_Tiers,
    SUM(CASE WHEN Customer_Rating='A' THEN 1 ELSE 0 END) AS Rating_A,
    SUM(CASE WHEN Customer_Rating='B' THEN 1 ELSE 0 END) AS Rating_B,
    SUM(CASE WHEN Customer_Rating='C' THEN 1 ELSE 0 END) AS Rating_C
FROM customer_master
GROUP BY Customer_Since
ORDER BY Customer_Since;


-- ============================================================
-- SECTION C: ADVANCED QUERIES (15 Queries)
-- Business Question: What deep patterns, rankings, and trends
-- are hidden in the data that require advanced SQL?
-- ============================================================


-- ============================================================
-- QUERY C1: Running Total Revenue (Window Function)
-- Business Question: When did we cross ₹25Cr, ₹50Cr, ₹75Cr?
-- What is our revenue trajectory?
-- ============================================================
SELECT 'QUERY C1: RUNNING TOTAL REVENUE BY MONTH' AS Query_Title;

SELECT
    Year,
    Month_Number,
    Month_Name,
    ROUND(SUM(Net_Amount_INR)/100000, 2)        AS Monthly_Revenue_Lakhs,
    ROUND(SUM(SUM(Net_Amount_INR))
          OVER(ORDER BY Year, Month_Number)/10000000, 3) AS Running_Total_Crore,
    CASE
        WHEN SUM(SUM(Net_Amount_INR))
             OVER(ORDER BY Year, Month_Number) >= 750000000
        THEN 'Crossed ₹75 Crore'
        WHEN SUM(SUM(Net_Amount_INR))
             OVER(ORDER BY Year, Month_Number) >= 500000000
        THEN 'Crossed ₹50 Crore'
        WHEN SUM(SUM(Net_Amount_INR))
             OVER(ORDER BY Year, Month_Number) >= 250000000
        THEN 'Crossed ₹25 Crore'
        ELSE 'Below ₹25 Crore'
    END AS Milestone
FROM raw_sales_data
GROUP BY Year, Month_Number, Month_Name
ORDER BY Year, Month_Number;


-- ============================================================
-- QUERY C2: Month-over-Month Revenue Change (LAG Function)
-- Business Question: Which month saw the sharpest drop?
-- Identify exact months that drove the 2024 dip
-- ============================================================
SELECT 'QUERY C2: MONTH-OVER-MONTH REVENUE CHANGE' AS Query_Title;

WITH monthly_revenue AS (
    SELECT
        Year,
        Month_Number,
        Month_Name,
        ROUND(SUM(Net_Amount_INR)/100000, 2) AS Revenue_Lakhs
    FROM raw_sales_data
    GROUP BY Year, Month_Number, Month_Name
)
SELECT
    Year,
    Month_Number,
    Month_Name,
    Revenue_Lakhs,
    LAG(Revenue_Lakhs) OVER(ORDER BY Year, Month_Number) AS Prev_Month_Revenue_Lakhs,
    ROUND(Revenue_Lakhs -
          LAG(Revenue_Lakhs) OVER(ORDER BY Year, Month_Number), 2)  AS MoM_Change_Lakhs,
    ROUND((Revenue_Lakhs -
           LAG(Revenue_Lakhs) OVER(ORDER BY Year, Month_Number)) /
           NULLIF(LAG(Revenue_Lakhs) OVER(ORDER BY Year, Month_Number),0)*100
    ,1)                                                              AS MoM_Change_Pct,
    CASE
        WHEN Revenue_Lakhs < LAG(Revenue_Lakhs) OVER(ORDER BY Year, Month_Number)
        THEN 'Declined'
        ELSE 'Grew'
    END AS Trend
FROM monthly_revenue
ORDER BY Year, Month_Number;


-- ============================================================
-- QUERY C3: Year-over-Year Revenue by Month (LEAD + LAG)
-- Business Question: How does each month in 2024 compare
-- to same month in 2023? Exactly when did dip start?
-- ============================================================
SELECT 'QUERY C3: YEAR-OVER-YEAR MONTHLY COMPARISON' AS Query_Title;

WITH yoy AS (
    SELECT
        Month_Number,
        Month_Name,
        ROUND(SUM(CASE WHEN Year=2023 THEN Net_Amount_INR ELSE 0 END)/100000,2) AS Rev_2023_L,
        ROUND(SUM(CASE WHEN Year=2024 THEN Net_Amount_INR ELSE 0 END)/100000,2) AS Rev_2024_L,
        ROUND(SUM(CASE WHEN Year=2025 THEN Net_Amount_INR ELSE 0 END)/100000,2) AS Rev_2025_L
    FROM raw_sales_data
    GROUP BY Month_Number, Month_Name
)
SELECT
    Month_Number,
    Month_Name,
    Rev_2023_L,
    Rev_2024_L,
    Rev_2025_L,
    ROUND((Rev_2024_L - Rev_2023_L)/Rev_2023_L*100, 1) AS Change_2024_vs_2023_Pct,
    ROUND((Rev_2025_L - Rev_2024_L)/Rev_2024_L*100, 1) AS Change_2025_vs_2024_Pct,
    CASE
        WHEN (Rev_2024_L - Rev_2023_L)/Rev_2023_L*100 < -5
        THEN 'DIP MONTH'
        ELSE 'Normal'
    END AS Dip_Flag
FROM yoy
ORDER BY Month_Number;


-- ============================================================
-- QUERY C4: Customer Revenue Ranking (RANK + DENSE_RANK)
-- Business Question: Full ranked list of all customers
-- including ties — for management reporting
-- ============================================================
SELECT 'QUERY C4: CUSTOMER REVENUE RANKING' AS Query_Title;

SELECT
    RANK() OVER(ORDER BY SUM(s.Net_Amount_INR) DESC)        AS Revenue_Rank,
    DENSE_RANK() OVER(ORDER BY SUM(s.Net_Amount_INR) DESC)  AS Dense_Rank,
    s.Customer_ID,
    s.Customer_Name,
    c.Customer_Type,
    c.Pricing_Tier,
    c.Customer_Rating,
    s.Region,
    ROUND(SUM(s.Net_Amount_INR)/100000, 2)                  AS Total_Revenue_Lakhs,
    COUNT(s.Transaction_ID)                                  AS Total_Orders,
    ROUND(AVG(s.Net_Amount_INR), 2)                         AS Avg_Order_Value_INR
FROM raw_sales_data s
JOIN customer_master c ON s.Customer_ID = c.Customer_ID
GROUP BY s.Customer_ID, s.Customer_Name, c.Customer_Type,
         c.Pricing_Tier, c.Customer_Rating, s.Region
ORDER BY Revenue_Rank;


-- ============================================================
-- QUERY C5: Salesperson Ranking within Region (PARTITION BY)
-- Business Question: Who is the top salesperson in each region?
-- Used for regional awards and performance reviews
-- ============================================================
SELECT 'QUERY C5: SALESPERSON RANKING WITHIN REGION' AS Query_Title;

WITH sp_region_rev AS (
    SELECT
        Region,
        Salesperson_ID,
        Salesperson_Name,
        ROUND(SUM(Net_Amount_INR)/10000000, 3) AS Revenue_Crore,
        COUNT(*)                                AS Total_Orders,
        RANK() OVER(
            PARTITION BY Region
            ORDER BY SUM(Net_Amount_INR) DESC
        )                                       AS Rank_in_Region
    FROM raw_sales_data
    GROUP BY Region, Salesperson_ID, Salesperson_Name
)
SELECT
    Region,
    Rank_in_Region,
    Salesperson_ID,
    Salesperson_Name,
    Revenue_Crore,
    Total_Orders
FROM sp_region_rev
ORDER BY Region, Rank_in_Region;


-- ============================================================
-- QUERY C6: Product Revenue Percentile (NTILE)
-- Business Question: Which products are in top 25%, middle 50%
-- and bottom 25% of revenue? Portfolio categorization
-- ============================================================
SELECT 'QUERY C6: PRODUCT REVENUE PERCENTILE (NTILE)' AS Query_Title;

WITH product_rev AS (
    SELECT
        Product_ID,
        Product_Name,
        Product_Category,
        ROUND(SUM(Net_Amount_INR)/10000000, 3) AS Revenue_Crore,
        SUM(Quantity_Sold)                      AS Units_Sold
    FROM raw_sales_data
    GROUP BY Product_ID, Product_Name, Product_Category
)
SELECT
    Product_Name,
    Product_Category,
    Revenue_Crore,
    Units_Sold,
    NTILE(4) OVER(ORDER BY Revenue_Crore DESC) AS Revenue_Quartile,
    CASE NTILE(4) OVER(ORDER BY Revenue_Crore DESC)
        WHEN 1 THEN 'Star Product — Top 25%'
        WHEN 2 THEN 'Growth Product — Upper Middle'
        WHEN 3 THEN 'Steady Product — Lower Middle'
        WHEN 4 THEN 'Laggard — Bottom 25% — Review Needed'
    END AS Product_Classification
FROM product_rev
ORDER BY Revenue_Crore DESC;


-- ============================================================
-- QUERY C7: Customers with Declining Orders (CTE + HAVING)
-- Business Question: Which customers reduced orders in 2024?
-- These are at-risk customers we need to re-engage
-- ============================================================
SELECT 'QUERY C7: CUSTOMERS WITH DECLINING ORDERS IN 2024' AS Query_Title;

WITH customer_yearly AS (
    SELECT
        Customer_ID,
        Customer_Name,
        Region,
        SUM(CASE WHEN Year=2023 THEN Net_Amount_INR ELSE 0 END) AS Rev_2023,
        SUM(CASE WHEN Year=2024 THEN Net_Amount_INR ELSE 0 END) AS Rev_2024,
        SUM(CASE WHEN Year=2025 THEN Net_Amount_INR ELSE 0 END) AS Rev_2025
    FROM raw_sales_data
    GROUP BY Customer_ID, Customer_Name, Region
)
SELECT
    cy.Customer_ID,
    cy.Customer_Name,
    cy.Region,
    c.Customer_Type,
    c.Customer_Rating,
    ROUND(cy.Rev_2023/100000, 2) AS Rev_2023_Lakhs,
    ROUND(cy.Rev_2024/100000, 2) AS Rev_2024_Lakhs,
    ROUND(cy.Rev_2025/100000, 2) AS Rev_2025_Lakhs,
    ROUND((cy.Rev_2024-cy.Rev_2023)/NULLIF(cy.Rev_2023,0)*100, 1) AS Decline_2024_Pct,
    ROUND((cy.Rev_2025-cy.Rev_2024)/NULLIF(cy.Rev_2024,0)*100, 1) AS Recovery_2025_Pct,
    CASE
        WHEN cy.Rev_2025 > cy.Rev_2023 THEN 'Fully Recovered'
        WHEN cy.Rev_2025 > cy.Rev_2024 THEN 'Partially Recovered'
        ELSE 'Still Declining — Urgent Action Needed'
    END AS Customer_Recovery_Status
FROM customer_yearly cy
JOIN customer_master c ON cy.Customer_ID = c.Customer_ID
WHERE cy.Rev_2024 < cy.Rev_2023
ORDER BY Decline_2024_Pct ASC
LIMIT 20;


-- ============================================================
-- QUERY C8: Moving Average Revenue (Window Function)
-- Business Question: What is the 3-month moving average?
-- Smooth out seasonal spikes to see real trend
-- ============================================================
SELECT 'QUERY C8: 3-MONTH MOVING AVERAGE REVENUE' AS Query_Title;

WITH monthly AS (
    SELECT
        Year,
        Month_Number,
        Month_Name,
        ROUND(SUM(Net_Amount_INR)/100000, 2) AS Revenue_Lakhs
    FROM raw_sales_data
    GROUP BY Year, Month_Number, Month_Name
)
SELECT
    Year,
    Month_Number,
    Month_Name,
    Revenue_Lakhs,
    ROUND(AVG(Revenue_Lakhs) OVER(
        ORDER BY Year, Month_Number
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS Moving_Avg_3Month_Lakhs,
    ROUND(Revenue_Lakhs - AVG(Revenue_Lakhs) OVER(
        ORDER BY Year, Month_Number
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS Deviation_from_Avg
FROM monthly
ORDER BY Year, Month_Number;


-- ============================================================
-- QUERY C9: Cumulative Customer Revenue (CTE + Window)
-- Business Question: What % of revenue comes from what % of customers?
-- Pareto analysis — do 20% of customers give 80% of revenue?
-- ============================================================
SELECT 'QUERY C9: PARETO ANALYSIS — CUSTOMER REVENUE' AS Query_Title;

WITH customer_rev AS (
    SELECT
        Customer_ID,
        Customer_Name,
        SUM(Net_Amount_INR) AS Total_Revenue
    FROM raw_sales_data
    GROUP BY Customer_ID, Customer_Name
),
ranked AS (
    SELECT
        Customer_ID,
        Customer_Name,
        Total_Revenue,
        RANK() OVER(ORDER BY Total_Revenue DESC) AS Rev_Rank,
        COUNT(*) OVER()                           AS Total_Customers,
        SUM(Total_Revenue) OVER()                 AS Grand_Total_Revenue,
        SUM(Total_Revenue) OVER(
            ORDER BY Total_Revenue DESC
            ROWS UNBOUNDED PRECEDING
        )                                         AS Cumulative_Revenue
    FROM customer_rev
)
SELECT
    Rev_Rank,
    Customer_Name,
    ROUND(Total_Revenue/100000, 2)              AS Revenue_Lakhs,
    ROUND(Rev_Rank/Total_Customers*100, 1)      AS Pct_of_Customers,
    ROUND(Cumulative_Revenue/Grand_Total_Revenue*100, 1) AS Cumulative_Revenue_Pct,
    CASE
        WHEN Cumulative_Revenue/Grand_Total_Revenue <= 0.80
        THEN 'Top 80% Revenue Generators'
        ELSE 'Remaining 20% Revenue'
    END AS Pareto_Category
FROM ranked
ORDER BY Rev_Rank;


-- ============================================================
-- QUERY C10: First and Last Order per Customer (CTE)
-- Business Question: How long have customers been active?
-- Which customers have not ordered recently?
-- ============================================================
SELECT 'QUERY C10: CUSTOMER ACTIVITY ANALYSIS' AS Query_Title;

WITH customer_activity AS (
    SELECT
        Customer_ID,
        Customer_Name,
        Region,
        MIN(Date)           AS First_Order_Date,
        MAX(Date)           AS Last_Order_Date,
        COUNT(*)            AS Total_Orders,
        DATEDIFF(MAX(Date), MIN(Date)) AS Active_Days,
        ROUND(SUM(Net_Amount_INR)/100000, 2) AS Total_Revenue_Lakhs
    FROM raw_sales_data
    GROUP BY Customer_ID, Customer_Name, Region
)
SELECT
    ca.*,
    c.Customer_Since,
    c.Pricing_Tier,
    c.Customer_Rating,
    CASE
        WHEN DATEDIFF('2026-06-30', ca.Last_Order_Date) <= 90
        THEN 'Active — Ordered in last 3 months'
        WHEN DATEDIFF('2026-06-30', ca.Last_Order_Date) <= 180
        THEN 'At Risk — No order in 3-6 months'
        ELSE 'Dormant — No order in 6+ months'
    END AS Customer_Activity_Status
FROM customer_activity ca
JOIN customer_master c ON ca.Customer_ID = c.Customer_ID
ORDER BY Last_Order_Date DESC;


-- ============================================================
-- QUERY C11: Seasonal Pattern Analysis (Avg by Month)
-- Business Question: Which months are consistently strongest?
-- Use this to plan inventory and staffing
-- ============================================================
SELECT 'QUERY C11: SEASONAL PATTERN ANALYSIS' AS Query_Title;

SELECT
    Month_Number,
    Month_Name,
    ROUND(AVG(monthly_rev), 2)  AS Avg_Revenue_Lakhs,
    ROUND(MIN(monthly_rev), 2)  AS Min_Revenue_Lakhs,
    ROUND(MAX(monthly_rev), 2)  AS Max_Revenue_Lakhs,
    ROUND(AVG(monthly_units))   AS Avg_Units_Sold,
    RANK() OVER(ORDER BY AVG(monthly_rev) DESC) AS Revenue_Rank,
    CASE
        WHEN RANK() OVER(ORDER BY AVG(monthly_rev) DESC) <= 3
        THEN 'Peak Season — Maximize stock'
        WHEN RANK() OVER(ORDER BY AVG(monthly_rev) DESC) >= 10
        THEN 'Lean Season — Plan promotions'
        ELSE 'Normal Season'
    END AS Season_Category
FROM (
    SELECT
        Month_Number,
        Month_Name,
        Year,
        SUM(Net_Amount_INR)/100000  AS monthly_rev,
        SUM(Quantity_Sold)          AS monthly_units
    FROM raw_sales_data
    GROUP BY Month_Number, Month_Name, Year
) monthly_data
GROUP BY Month_Number, Month_Name
ORDER BY Month_Number;


-- ============================================================
-- QUERY C12: Cohort Analysis — Revenue by Customer Since Year
-- Business Question: Which batch of customers is most valuable?
-- 2018 cohort vs 2020 cohort — who generates more?
-- ============================================================
SELECT 'QUERY C12: COHORT ANALYSIS BY CUSTOMER SINCE YEAR' AS Query_Title;

SELECT
    c.Customer_Since AS Cohort_Year,
    COUNT(DISTINCT c.Customer_ID) AS Cohort_Size,
    ROUND(SUM(CASE WHEN s.Year=2023 THEN s.Net_Amount_INR ELSE 0 END)/100000,2) AS Rev_2023_Lakhs,
    ROUND(SUM(CASE WHEN s.Year=2024 THEN s.Net_Amount_INR ELSE 0 END)/100000,2) AS Rev_2024_Lakhs,
    ROUND(SUM(CASE WHEN s.Year=2025 THEN s.Net_Amount_INR ELSE 0 END)/100000,2) AS Rev_2025_Lakhs,
    ROUND(SUM(s.Net_Amount_INR)/100000, 2)                                       AS Total_Revenue_Lakhs,
    ROUND(SUM(s.Net_Amount_INR)/COUNT(DISTINCT c.Customer_ID)/100000, 2)         AS Revenue_Per_Customer_Lakhs
FROM customer_master c
JOIN raw_sales_data s ON c.Customer_ID = s.Customer_ID
GROUP BY c.Customer_Since
ORDER BY c.Customer_Since;


-- ============================================================
-- QUERY C13: Top Product per Customer (Correlated Subquery)
-- Business Question: What does each customer buy most?
-- Use for targeted cross-selling and upselling
-- ============================================================
SELECT 'QUERY C13: TOP PRODUCT PER CUSTOMER' AS Query_Title;

SELECT
    s.Customer_ID,
    s.Customer_Name,
    s.Region,
    s.Product_Name AS Top_Product,
    s.Product_Category,
    ROUND(s.Product_Revenue/100000, 2) AS Product_Revenue_Lakhs
FROM (
    SELECT
        Customer_ID,
        Customer_Name,
        Region,
        Product_Name,
        Product_Category,
        SUM(Net_Amount_INR) AS Product_Revenue,
        RANK() OVER(
            PARTITION BY Customer_ID
            ORDER BY SUM(Net_Amount_INR) DESC
        ) AS Product_Rank
    FROM raw_sales_data
    GROUP BY Customer_ID, Customer_Name, Region, Product_Name, Product_Category
) s
WHERE s.Product_Rank = 1
ORDER BY Product_Revenue_Lakhs DESC
LIMIT 30;


-- ============================================================
-- QUERY C14: Revenue Gap Analysis vs Target (CTE)
-- Business Question: By how much did we miss or exceed
-- targets each month? Where were the biggest gaps?
-- ============================================================
SELECT 'QUERY C14: MONTHLY REVENUE GAP ANALYSIS' AS Query_Title;

WITH actuals AS (
    SELECT
        Year,
        Month_Number,
        Month_Name,
        ROUND(SUM(Net_Amount_INR), 2) AS Actual_Revenue
    FROM raw_sales_data
    GROUP BY Year, Month_Number, Month_Name
)
SELECT
    t.Year,
    t.Month_No,
    t.Month_Name,
    ROUND(t.Monthly_Target_INR, 2)              AS Target_INR,
    a.Actual_Revenue                            AS Actual_INR,
    ROUND(a.Actual_Revenue - t.Monthly_Target_INR, 2) AS Gap_INR,
    ROUND((a.Actual_Revenue - t.Monthly_Target_INR)/
          t.Monthly_Target_INR*100, 2)          AS Gap_Pct,
    t.Status,
    CASE
        WHEN a.Actual_Revenue - t.Monthly_Target_INR > 0
        THEN 'Surplus'
        ELSE 'Deficit'
    END AS Gap_Type
FROM sales_targets_monthly t
JOIN actuals a ON t.Year = a.Year AND t.Month_No = a.Month_Number
ORDER BY ABS(a.Actual_Revenue - t.Monthly_Target_INR) DESC;


-- ============================================================
-- QUERY C15: Multi-level Aggregation Summary (ROLLUP)
-- Business Question: Complete hierarchy — total by region,
-- year, and grand total in one query
-- ============================================================
SELECT 'QUERY C15: HIERARCHICAL REVENUE ROLLUP' AS Query_Title;

SELECT
    COALESCE(Region, 'ALL REGIONS')    AS Region,
    COALESCE(CAST(Year AS CHAR), 'ALL YEARS') AS Year,
    COUNT(*)                            AS Transactions,
    ROUND(SUM(Net_Amount_INR)/10000000, 3) AS Revenue_Crore
FROM raw_sales_data
GROUP BY Region, Year WITH ROLLUP
ORDER BY Region, Year;


-- ============================================================
-- SECTION D: DIP & RECOVERY ANALYSIS (10 Queries)
-- Business Question: What caused the 2024 dip?
-- How did we recover in 2025? What should we do next?
-- This is the CORE STORY of your internship project
-- ============================================================


-- ============================================================
-- QUERY D1: Dip Timeline — Exact Month-wise Drop
-- Business Question: When exactly did the dip start and end?
-- What was the severity each month?
-- ============================================================
SELECT 'QUERY D1: 2024 DIP TIMELINE — MONTH BY MONTH' AS Query_Title;

SELECT
    Month_Number,
    Month_Name,
    ROUND(SUM(CASE WHEN Year=2023 THEN Net_Amount_INR ELSE 0 END)/100000,2) AS Rev_2023_Lakhs,
    ROUND(SUM(CASE WHEN Year=2024 THEN Net_Amount_INR ELSE 0 END)/100000,2) AS Rev_2024_Lakhs,
    ROUND(SUM(CASE WHEN Year=2024 THEN Net_Amount_INR ELSE 0 END) -
          SUM(CASE WHEN Year=2023 THEN Net_Amount_INR ELSE 0 END))/100000   AS Revenue_Loss_Lakhs,
    ROUND((SUM(CASE WHEN Year=2024 THEN Net_Amount_INR ELSE 0 END) -
           SUM(CASE WHEN Year=2023 THEN Net_Amount_INR ELSE 0 END)) /
           NULLIF(SUM(CASE WHEN Year=2023 THEN Net_Amount_INR ELSE 0 END),0)*100,1) AS Dip_Pct,
    CASE
        WHEN (SUM(CASE WHEN Year=2024 THEN Net_Amount_INR ELSE 0 END) -
              SUM(CASE WHEN Year=2023 THEN Net_Amount_INR ELSE 0 END)) /
              NULLIF(SUM(CASE WHEN Year=2023 THEN Net_Amount_INR ELSE 0 END),0)*100 < -10
        THEN 'SEVERE DIP'
        WHEN (SUM(CASE WHEN Year=2024 THEN Net_Amount_INR ELSE 0 END) -
              SUM(CASE WHEN Year=2023 THEN Net_Amount_INR ELSE 0 END)) /
              NULLIF(SUM(CASE WHEN Year=2023 THEN Net_Amount_INR ELSE 0 END),0)*100 < -5
        THEN 'MODERATE DIP'
        WHEN (SUM(CASE WHEN Year=2024 THEN Net_Amount_INR ELSE 0 END) -
              SUM(CASE WHEN Year=2023 THEN Net_Amount_INR ELSE 0 END)) /
              NULLIF(SUM(CASE WHEN Year=2023 THEN Net_Amount_INR ELSE 0 END),0)*100 < 0
        THEN 'MILD DIP'
        ELSE 'NO DIP'
    END AS Dip_Severity
FROM raw_sales_data
WHERE Year IN (2023, 2024)
GROUP BY Month_Number, Month_Name
ORDER BY Month_Number;


-- ============================================================
-- QUERY D2: Which Region Was Most Affected by Dip?
-- Business Question: Was the dip company-wide or regional?
-- Which region needs most support for recovery?
-- ============================================================
SELECT 'QUERY D2: REGION-WISE DIP IMPACT ANALYSIS' AS Query_Title;

WITH region_yoy AS (
    SELECT
        Region,
        SUM(CASE WHEN Year=2023 THEN Net_Amount_INR ELSE 0 END) AS Rev_2023,
        SUM(CASE WHEN Year=2024 THEN Net_Amount_INR ELSE 0 END) AS Rev_2024,
        SUM(CASE WHEN Year=2025 THEN Net_Amount_INR ELSE 0 END) AS Rev_2025,
        COUNT(CASE WHEN Year=2023 THEN 1 END)                   AS Orders_2023,
        COUNT(CASE WHEN Year=2024 THEN 1 END)                   AS Orders_2024
    FROM raw_sales_data
    GROUP BY Region
)
SELECT
    Region,
    ROUND(Rev_2023/10000000, 3)                                     AS Rev_2023_Crore,
    ROUND(Rev_2024/10000000, 3)                                     AS Rev_2024_Crore,
    ROUND(Rev_2025/10000000, 3)                                     AS Rev_2025_Crore,
    ROUND((Rev_2024-Rev_2023)/NULLIF(Rev_2023,0)*100, 1)            AS Dip_Pct_2024,
    ROUND((Rev_2025-Rev_2024)/NULLIF(Rev_2024,0)*100, 1)            AS Recovery_Pct_2025,
    Orders_2023,
    Orders_2024,
    Orders_2024 - Orders_2023                                        AS Order_Count_Change,
    CASE
        WHEN (Rev_2025-Rev_2023)/NULLIF(Rev_2023,0)*100 > 5
        THEN 'Fully Recovered + Growth'
        WHEN Rev_2025 >= Rev_2023
        THEN 'Fully Recovered'
        WHEN Rev_2025 > Rev_2024
        THEN 'Partial Recovery'
        ELSE 'Still Below 2023 Level'
    END AS Recovery_Status_2025
FROM region_yoy
ORDER BY Dip_Pct_2024 ASC;


-- ============================================================
-- QUERY D3: Which Products Were Most Affected by Dip?
-- Business Question: Was dip product-specific or across board?
-- Did customers reduce specific product orders?
-- ============================================================
SELECT 'QUERY D3: PRODUCT-WISE DIP IMPACT' AS Query_Title;

SELECT
    Product_Category,
    Product_Name,
    ROUND(SUM(CASE WHEN Year=2023 THEN Net_Amount_INR ELSE 0 END)/100000,2) AS Rev_2023_L,
    ROUND(SUM(CASE WHEN Year=2024 THEN Net_Amount_INR ELSE 0 END)/100000,2) AS Rev_2024_L,
    ROUND(SUM(CASE WHEN Year=2025 THEN Net_Amount_INR ELSE 0 END)/100000,2) AS Rev_2025_L,
    ROUND((SUM(CASE WHEN Year=2024 THEN Net_Amount_INR ELSE 0 END) -
           SUM(CASE WHEN Year=2023 THEN Net_Amount_INR ELSE 0 END))/
           NULLIF(SUM(CASE WHEN Year=2023 THEN Net_Amount_INR ELSE 0 END),0)*100,1) AS Dip_Pct,
    SUM(CASE WHEN Year=2024 THEN Quantity_Sold ELSE 0 END) -
    SUM(CASE WHEN Year=2023 THEN Quantity_Sold ELSE 0 END)                  AS Unit_Change_2024,
    CASE
        WHEN (SUM(CASE WHEN Year=2024 THEN Net_Amount_INR ELSE 0 END) -
              SUM(CASE WHEN Year=2023 THEN Net_Amount_INR ELSE 0 END))/
              NULLIF(SUM(CASE WHEN Year=2023 THEN Net_Amount_INR ELSE 0 END),0)*100 < -5
        THEN 'Significantly Affected'
        ELSE 'Relatively Stable'
    END AS Dip_Impact
FROM raw_sales_data
GROUP BY Product_Category, Product_Name
ORDER BY Dip_Pct ASC;


-- ============================================================
-- QUERY D4: Customer Behavior During Dip — Who Stayed Loyal?
-- Business Question: Which customers maintained orders
-- during 2024 dip? These are our most loyal accounts
-- ============================================================
SELECT 'QUERY D4: LOYAL CUSTOMERS DURING DIP' AS Query_Title;

WITH customer_orders AS (
    SELECT
        s.Customer_ID,
        s.Customer_Name,
        c.Customer_Type,
        c.Pricing_Tier,
        c.Customer_Rating,
        s.Region,
        COUNT(CASE WHEN s.Year=2023 THEN 1 END) AS Orders_2023,
        COUNT(CASE WHEN s.Year=2024 THEN 1 END) AS Orders_2024,
        ROUND(SUM(CASE WHEN s.Year=2023 THEN s.Net_Amount_INR ELSE 0 END)/100000,2) AS Rev_2023_L,
        ROUND(SUM(CASE WHEN s.Year=2024 THEN s.Net_Amount_INR ELSE 0 END)/100000,2) AS Rev_2024_L
    FROM raw_sales_data s
    JOIN customer_master c ON s.Customer_ID = c.Customer_ID
    GROUP BY s.Customer_ID, s.Customer_Name, c.Customer_Type,
             c.Pricing_Tier, c.Customer_Rating, s.Region
)
SELECT
    Customer_ID,
    Customer_Name,
    Customer_Type,
    Pricing_Tier,
    Customer_Rating,
    Region,
    Orders_2023,
    Orders_2024,
    Rev_2023_L,
    Rev_2024_L,
    ROUND((Rev_2024_L - Rev_2023_L)/NULLIF(Rev_2023_L,0)*100, 1) AS Revenue_Change_Pct,
    CASE
        WHEN Rev_2024_L >= Rev_2023_L * 0.95
        THEN 'LOYAL — Maintained orders during dip'
        WHEN Rev_2024_L >= Rev_2023_L * 0.80
        THEN 'NEAR LOYAL — Minor reduction'
        ELSE 'REDUCED — Significant order reduction'
    END AS Loyalty_Status
FROM customer_orders
WHERE Orders_2023 > 0 AND Orders_2024 > 0
ORDER BY Revenue_Change_Pct DESC;


-- ============================================================
-- QUERY D5: Root Cause — Order Size vs Order Frequency
-- Business Question: In 2024 dip — did customers order LESS
-- often, or did they order SMALLER quantities each time?
-- This tells us the nature of the problem
-- ============================================================
SELECT 'QUERY D5: DIP ROOT CAUSE — SIZE VS FREQUENCY' AS Query_Title;

SELECT
    Year,
    Region,
    COUNT(*)                                        AS Total_Orders,
    ROUND(AVG(Quantity_Sold), 1)                    AS Avg_Units_Per_Order,
    ROUND(AVG(Net_Amount_INR), 2)                   AS Avg_Order_Value_INR,
    ROUND(SUM(Net_Amount_INR)/100000, 2)            AS Total_Revenue_Lakhs,
    ROUND(AVG(Discount_Percent), 2)                 AS Avg_Discount_Given
FROM raw_sales_data
WHERE Year IN (2023, 2024, 2025)
GROUP BY Year, Region
ORDER BY Region, Year;


-- ============================================================
-- QUERY D6: 2025 Recovery Analysis — What Changed?
-- Business Question: What drove the 2025 recovery?
-- Which factors improved vs 2024?
-- ============================================================
SELECT 'QUERY D6: 2025 RECOVERY ANALYSIS' AS Query_Title;

SELECT
    '2024 (Dip Year)'       AS Period,
    COUNT(*)                AS Total_Orders,
    COUNT(DISTINCT Customer_ID) AS Active_Customers,
    ROUND(AVG(Net_Amount_INR),2) AS Avg_Order_Value_INR,
    ROUND(SUM(Net_Amount_INR)/10000000,3) AS Revenue_Crore,
    ROUND(AVG(Discount_Percent),2) AS Avg_Discount_Pct,
    SUM(CASE WHEN Payment_Status='Paid' THEN 1 ELSE 0 END) AS Paid_Orders,
    ROUND(SUM(CASE WHEN Payment_Status='Paid' THEN 1 ELSE 0 END)/COUNT(*)*100,1) AS Collection_Rate_Pct
FROM raw_sales_data
WHERE Year = 2024

UNION ALL

SELECT
    '2025 (Recovery Year)',
    COUNT(*),
    COUNT(DISTINCT Customer_ID),
    ROUND(AVG(Net_Amount_INR),2),
    ROUND(SUM(Net_Amount_INR)/10000000,3),
    ROUND(AVG(Discount_Percent),2),
    SUM(CASE WHEN Payment_Status='Paid' THEN 1 ELSE 0 END),
    ROUND(SUM(CASE WHEN Payment_Status='Paid' THEN 1 ELSE 0 END)/COUNT(*)*100,1)
FROM raw_sales_data
WHERE Year = 2025;


-- ============================================================
-- QUERY D7: Dip Impact on Payment Collection
-- Business Question: Did the 2024 dip worsen payment collection?
-- Did customers delay payments when market was slow?
-- ============================================================
SELECT 'QUERY D7: DIP IMPACT ON PAYMENT COLLECTION' AS Query_Title;

SELECT
    Year,
    Month_Number,
    Month_Name,
    COUNT(*)                                                AS Total_Orders,
    SUM(CASE WHEN Payment_Status='Paid'    THEN 1 ELSE 0 END) AS Paid,
    SUM(CASE WHEN Payment_Status='Pending' THEN 1 ELSE 0 END) AS Pending,
    SUM(CASE WHEN Payment_Status='Partial' THEN 1 ELSE 0 END) AS Partial,
    ROUND(SUM(CASE WHEN Payment_Status='Paid' THEN 1 ELSE 0 END)/COUNT(*)*100,1) AS Collection_Rate_Pct,
    ROUND(SUM(CASE WHEN Payment_Status IN ('Pending','Partial')
              THEN Net_Amount_INR ELSE 0 END)/100000,2)     AS Outstanding_Lakhs
FROM raw_sales_data
WHERE Year IN (2023, 2024, 2025)
GROUP BY Year, Month_Number, Month_Name
ORDER BY Year, Month_Number;


-- ============================================================
-- QUERY D8: Recovery Leaders — Top Recovering Customers
-- Business Question: Which customers came back strongest in 2025?
-- These should be our case studies for retention strategy
-- ============================================================
SELECT 'QUERY D8: TOP RECOVERY CUSTOMERS IN 2025' AS Query_Title;

WITH recovery AS (
    SELECT
        s.Customer_ID,
        s.Customer_Name,
        c.Customer_Type,
        c.Customer_Rating,
        s.Region,
        SUM(CASE WHEN s.Year=2024 THEN s.Net_Amount_INR ELSE 0 END) AS Rev_2024,
        SUM(CASE WHEN s.Year=2025 THEN s.Net_Amount_INR ELSE 0 END) AS Rev_2025
    FROM raw_sales_data s
    JOIN customer_master c ON s.Customer_ID = c.Customer_ID
    GROUP BY s.Customer_ID, s.Customer_Name,
             c.Customer_Type, c.Customer_Rating, s.Region
    HAVING Rev_2024 > 0 AND Rev_2025 > Rev_2024
)
SELECT
    Customer_ID,
    Customer_Name,
    Customer_Type,
    Customer_Rating,
    Region,
    ROUND(Rev_2024/100000, 2) AS Rev_2024_Lakhs,
    ROUND(Rev_2025/100000, 2) AS Rev_2025_Lakhs,
    ROUND((Rev_2025-Rev_2024)/Rev_2024*100, 1) AS Growth_Pct,
    ROUND((Rev_2025-Rev_2024)/100000, 2) AS Incremental_Revenue_Lakhs
FROM recovery
ORDER BY Growth_Pct DESC
LIMIT 20;


-- ============================================================
-- QUERY D9: What To Maintain — Factors Behind 2025 Success
-- Business Question: Which regions, products, and customer
-- types maintained growth? What should we protect?
-- ============================================================
SELECT 'QUERY D9: FACTORS BEHIND 2025 SUCCESS — WHAT TO MAINTAIN' AS Query_Title;

SELECT
    'Region Performance 2025 vs 2024' AS Analysis_Dimension,
    Region AS Category,
    ROUND(SUM(CASE WHEN Year=2024 THEN Net_Amount_INR ELSE 0 END)/10000000,3) AS Base_2024_Crore,
    ROUND(SUM(CASE WHEN Year=2025 THEN Net_Amount_INR ELSE 0 END)/10000000,3) AS Recovery_2025_Crore,
    ROUND((SUM(CASE WHEN Year=2025 THEN Net_Amount_INR ELSE 0 END) -
           SUM(CASE WHEN Year=2024 THEN Net_Amount_INR ELSE 0 END))/
           NULLIF(SUM(CASE WHEN Year=2024 THEN Net_Amount_INR ELSE 0 END),0)*100,1) AS Growth_Pct
FROM raw_sales_data
GROUP BY Region

UNION ALL

SELECT
    'Product Category Performance 2025 vs 2024',
    Product_Category,
    ROUND(SUM(CASE WHEN Year=2024 THEN Net_Amount_INR ELSE 0 END)/10000000,3),
    ROUND(SUM(CASE WHEN Year=2025 THEN Net_Amount_INR ELSE 0 END)/10000000,3),
    ROUND((SUM(CASE WHEN Year=2025 THEN Net_Amount_INR ELSE 0 END) -
           SUM(CASE WHEN Year=2024 THEN Net_Amount_INR ELSE 0 END))/
           NULLIF(SUM(CASE WHEN Year=2024 THEN Net_Amount_INR ELSE 0 END),0)*100,1)
FROM raw_sales_data
GROUP BY Product_Category

UNION ALL

SELECT
    'Customer Type Performance 2025 vs 2024',
    Customer_Type,
    ROUND(SUM(CASE WHEN Year=2024 THEN Net_Amount_INR ELSE 0 END)/10000000,3),
    ROUND(SUM(CASE WHEN Year=2025 THEN Net_Amount_INR ELSE 0 END)/10000000,3),
    ROUND((SUM(CASE WHEN Year=2025 THEN Net_Amount_INR ELSE 0 END) -
           SUM(CASE WHEN Year=2024 THEN Net_Amount_INR ELSE 0 END))/
           NULLIF(SUM(CASE WHEN Year=2024 THEN Net_Amount_INR ELSE 0 END),0)*100,1)
FROM raw_sales_data
GROUP BY Customer_Type

ORDER BY Analysis_Dimension, Growth_Pct DESC;


-- ============================================================
-- QUERY D10: Forward-Looking Recommendations
-- Business Question: Based on 3.5 years of data, what are
-- the top recommendations for Bhartiya Valves management?
-- This is your internship insight delivery to your manager
-- ============================================================
SELECT 'QUERY D10: MANAGEMENT RECOMMENDATIONS FROM DATA' AS Query_Title;

SELECT
    1 AS Priority,
    'Protect Top 20 Customers' AS Recommendation,
    CONCAT('Top 20 customers contribute ',
        ROUND((SELECT SUM(t.revenue) FROM
            (SELECT SUM(Net_Amount_INR) AS revenue FROM raw_sales_data
             GROUP BY Customer_ID ORDER BY revenue DESC LIMIT 20) t)
        / (SELECT SUM(Net_Amount_INR) FROM raw_sales_data) * 100, 1),
        '% of total revenue. Assign dedicated account managers.')
    AS Data_Insight,
    'Immediate' AS Timeline

UNION ALL SELECT 2,
    'Expand Haryana Market',
    'Haryana contributes 18% of revenue with only 2 cities (Hisar, Ambala). Adding Rohtak, Panipat dealers can target 25%.',
    'Q3 2026'

UNION ALL SELECT 3,
    'Improve Medical Valve Sales',
    CONCAT('Medical valves are only ',
        ROUND((SELECT SUM(Net_Amount_INR) FROM raw_sales_data WHERE Product_Category='Medical Valve') /
              (SELECT SUM(Net_Amount_INR) FROM raw_sales_data) * 100, 1),
        '% of revenue vs 20% target. Government hospital segment needs focused outreach.'),
    'Q3-Q4 2026'

UNION ALL SELECT 4,
    'Reduce Payment Outstanding',
    CONCAT('Pending + Partial orders = ',
        ROUND((SELECT SUM(Net_Amount_INR) FROM raw_sales_data WHERE Payment_Status IN ('Pending','Partial'))/100000,0),
        ' Lakhs outstanding. Implement 30-day collection follow-up process.'),
    'Immediate'

UNION ALL SELECT 5,
    'Strengthen Q3 Performance',
    'Q3 (Jul-Sep) is consistently 15-18% below Q4. Introduce monsoon season promotions and advance booking discounts.',
    'Before Jul 2026'

UNION ALL SELECT 6,
    'Legacy Customer Retention Program',
    '9 legacy customers (since 1998-2007) contribute disproportionate revenue. Create formal VIP retention program.',
    'Q3 2026'

UNION ALL SELECT 7,
    'Port Dispatch Expansion',
    CONCAT('Gujarat + Maharashtra via port contribute ',
        ROUND((SELECT SUM(Net_Amount_INR) FROM raw_sales_data
               WHERE Region IN ('Gujarat (Extended Reach)','Maharashtra (Extended Reach)'))/10000000,2),
        ' Crore. Telangana shows growth potential — add dedicated Southern SP.'),
    'Q4 2026'

UNION ALL SELECT 8,
    'Monitor 2024 Dip Recurrence',
    'Dip was sharpest May-Sep 2024 in Industrial Valve segment. Set monthly KPI alerts at -8% vs target to trigger early intervention.',
    'Ongoing'

ORDER BY Priority;



