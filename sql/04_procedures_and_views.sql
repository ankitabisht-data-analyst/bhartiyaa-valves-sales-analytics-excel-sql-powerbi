-- ============================================================
-- BHARTIYA VALVES — STORED PROCEDURES & VIEWS
-- Contains: 6 Stored Procedures + 3 Views
-- ============================================================

USE bhartiya_valves;

-- ============================================================
-- SECTION A: STORED PROCEDURES (6 Total)
-- What is a stored procedure?
-- A saved SQL program you can call anytime with parameters
-- Instead of writing the same query again and again,
-- you just call: CALL ProcedureName(parameter);
-- ============================================================


-- ============================================================
-- STORED PROCEDURE 1: GetRevenueByRegion
-- Call: CALL GetRevenueByRegion('Delhi NCR', 2024);
-- Call: CALL GetRevenueByRegion('Haryana', 2025);
-- Purpose: Complete revenue report for any region and year
-- ============================================================

DROP PROCEDURE IF EXISTS GetRevenueByRegion;

DELIMITER //
CREATE PROCEDURE GetRevenueByRegion(
    IN p_region VARCHAR(50),
    IN p_year   INT
)
BEGIN
    -- Overall summary
    SELECT
        p_region  AS Region,
        p_year  AS Year,
        COUNT(*)   AS Total_Orders,
        COUNT(DISTINCT Customer_ID)   AS Unique_Customers,
        SUM(Quantity_Sold)   AS Units_Sold,
        ROUND(SUM(Net_Amount_INR)/100000, 2)   AS Revenue_Lakhs,
        ROUND(AVG(Net_Amount_INR), 2)    AS Avg_Order_Value_INR,
        ROUND(AVG(Discount_Percent), 2) AS Avg_Discount_Pct,
        ROUND(SUM(CASE WHEN Payment_Status='Paid'
                  THEN 1 ELSE 0 END)/COUNT(*)*100, 1)  AS Collection_Rate_Pct
    FROM raw_sales_data
    WHERE Region = p_region AND Year = p_year;

    -- Month-wise breakdown
    SELECT
        Month_Number,
        Month_Name,
        COUNT(*)    AS Orders,
        ROUND(SUM(Net_Amount_INR)/100000, 2)  AS Revenue_Lakhs
    FROM raw_sales_data
    WHERE Region = p_region AND Year = p_year
    GROUP BY Month_Number, Month_Name
    ORDER BY Month_Number;

    -- Top 5 customers in this region-year
    SELECT
        Customer_Name,
        Customer_Type,
        COUNT(*)    AS Orders,
        ROUND(SUM(Net_Amount_INR)/100000, 2) AS Revenue_Lakhs
    FROM raw_sales_data
    WHERE Region = p_region AND Year = p_year
    GROUP BY Customer_Name, Customer_Type
    ORDER BY Revenue_Lakhs DESC
    LIMIT 5;
END //
DELIMITER ;

-- Test
CALL GetRevenueByRegion('Delhi NCR', 2024);
CALL GetRevenueByRegion('Haryana', 2025);


-- ============================================================
-- STORED PROCEDURE 2: GetTopNCustomers
-- Call: CALL GetTopNCustomers(10, 2024);
-- Call: CALL GetTopNCustomers(5, 2025);
-- Purpose: Get top N customers for any year
-- ============================================================

DROP PROCEDURE IF EXISTS GetTopNCustomers;

DELIMITER //
CREATE PROCEDURE GetTopNCustomers(
    IN p_n    INT,
    IN p_year INT
)
BEGIN
    SELECT
        RANK() OVER(ORDER BY SUM(s.Net_Amount_INR) DESC) AS Customer_Rank,
        s.Customer_ID,
        s.Customer_Name,
        c.Customer_Type,
        c.Customer_Rating,
        c.Pricing_Tier,
        s.Region,
        COUNT(s.Transaction_ID)                         AS Total_Orders,
        ROUND(SUM(s.Net_Amount_INR)/100000, 2)          AS Revenue_Lakhs,
        ROUND(AVG(s.Net_Amount_INR), 2)                 AS Avg_Order_Value_INR
    FROM raw_sales_data s
    JOIN customer_master c ON s.Customer_ID = c.Customer_ID
    WHERE s.Year = p_year
    GROUP BY s.Customer_ID, s.Customer_Name, c.Customer_Type,
             c.Customer_Rating, c.Pricing_Tier, s.Region
    ORDER BY Revenue_Lakhs DESC
    LIMIT p_n;
END //
DELIMITER ;

-- Test
CALL GetTopNCustomers(10, 2024);
CALL GetTopNCustomers(5, 2025);


-- ============================================================
-- STORED PROCEDURE 3: GetSalespersonScorecard
-- Call: CALL GetSalespersonScorecard('SP-01');
-- Call: CALL GetSalespersonScorecard('SP-04');
-- Purpose: Full performance report for any salesperson
-- ============================================================

DROP PROCEDURE IF EXISTS GetSalespersonScorecard;

DELIMITER //
CREATE PROCEDURE GetSalespersonScorecard(
    IN p_sp_id VARCHAR(10)
)
BEGIN
    -- Overall scorecard
    SELECT
        Salesperson_ID,
        Salesperson_Name,
        GROUP_CONCAT(DISTINCT Region
                     ORDER BY Region SEPARATOR ', ')    AS Regions_Covered,
        COUNT(*)                                        AS Total_Orders,
        COUNT(DISTINCT Customer_ID)                     AS Unique_Customers,
        SUM(Quantity_Sold)                              AS Total_Units_Sold,
        ROUND(SUM(Net_Amount_INR)/10000000, 3)          AS Total_Revenue_Crore,
        ROUND(AVG(Net_Amount_INR), 2)                   AS Avg_Order_Value_INR,
        ROUND(AVG(Discount_Percent), 2)                 AS Avg_Discount_Pct
    FROM raw_sales_data
    WHERE Salesperson_ID = p_sp_id
    GROUP BY Salesperson_ID, Salesperson_Name;

    -- Year-wise performance
    SELECT
        Year,
        COUNT(*)                                        AS Orders,
        ROUND(SUM(Net_Amount_INR)/10000000, 3)          AS Revenue_Crore,
        COUNT(DISTINCT Customer_ID)                     AS Active_Customers
    FROM raw_sales_data
    WHERE Salesperson_ID = p_sp_id
    GROUP BY Year
    ORDER BY Year;

    -- Top 3 best months
    SELECT
        Year,
        Month_Name,
        ROUND(SUM(Net_Amount_INR)/100000, 2)            AS Revenue_Lakhs
    FROM raw_sales_data
    WHERE Salesperson_ID = p_sp_id
    GROUP BY Year, Month_Number, Month_Name
    ORDER BY Revenue_Lakhs DESC
    LIMIT 3;
END //
DELIMITER ;

-- Test
CALL GetSalespersonScorecard('SP-01');
CALL GetSalespersonScorecard('SP-04');


-- ============================================================
-- STORED PROCEDURE 4: GetDipAnalysis
-- Call: CALL GetDipAnalysis(2023, 2024);
-- Call: CALL GetDipAnalysis(2024, 2025);
-- Purpose: Compare any two years — show dip or recovery
-- ============================================================

DROP PROCEDURE IF EXISTS GetDipAnalysis;

DELIMITER //
CREATE PROCEDURE GetDipAnalysis(
    IN p_year1 INT,
    IN p_year2 INT
)
BEGIN
    -- Overall comparison
    SELECT
        p_year1                                         AS Base_Year,
        p_year2                                         AS Compare_Year,
        ROUND(SUM(CASE WHEN Year = p_year1
                  THEN Net_Amount_INR ELSE 0 END)
              /10000000, 3)                             AS Base_Revenue_Crore,
        ROUND(SUM(CASE WHEN Year = p_year2
                  THEN Net_Amount_INR ELSE 0 END)
              /10000000, 3)                             AS Compare_Revenue_Crore,
        ROUND((SUM(CASE WHEN Year=p_year2
                   THEN Net_Amount_INR ELSE 0 END) -
               SUM(CASE WHEN Year=p_year1
                   THEN Net_Amount_INR ELSE 0 END)) /
               NULLIF(SUM(CASE WHEN Year=p_year1
                          THEN Net_Amount_INR ELSE 0 END),0)*100,1) AS Change_Pct,
        CASE
            WHEN SUM(CASE WHEN Year=p_year2
                     THEN Net_Amount_INR ELSE 0 END) >
                 SUM(CASE WHEN Year=p_year1
                     THEN Net_Amount_INR ELSE 0 END)
            THEN 'GROWTH'
            ELSE 'DIP'
        END                                             AS Verdict
    FROM raw_sales_data
    WHERE Year IN (p_year1, p_year2);

    -- Region-wise impact
    SELECT
        Region,
        ROUND(SUM(CASE WHEN Year=p_year1
                  THEN Net_Amount_INR ELSE 0 END)/100000,2) AS Base_Lakhs,
        ROUND(SUM(CASE WHEN Year=p_year2
                  THEN Net_Amount_INR ELSE 0 END)/100000,2) AS Compare_Lakhs,
        ROUND((SUM(CASE WHEN Year=p_year2
                   THEN Net_Amount_INR ELSE 0 END) -
               SUM(CASE WHEN Year=p_year1
                   THEN Net_Amount_INR ELSE 0 END)) /
               NULLIF(SUM(CASE WHEN Year=p_year1
                          THEN Net_Amount_INR ELSE 0 END),0)*100,1) AS Change_Pct
    FROM raw_sales_data
    WHERE Year IN (p_year1, p_year2)
    GROUP BY Region
    ORDER BY Change_Pct ASC;

    -- Month-wise impact
    SELECT
        Month_Number,
        Month_Name,
        ROUND(SUM(CASE WHEN Year=p_year1
                  THEN Net_Amount_INR ELSE 0 END)/100000,2) AS Base_Lakhs,
        ROUND(SUM(CASE WHEN Year=p_year2
                  THEN Net_Amount_INR ELSE 0 END)/100000,2) AS Compare_Lakhs,
        ROUND((SUM(CASE WHEN Year=p_year2
                   THEN Net_Amount_INR ELSE 0 END) -
               SUM(CASE WHEN Year=p_year1
                   THEN Net_Amount_INR ELSE 0 END)) /
               NULLIF(SUM(CASE WHEN Year=p_year1
                          THEN Net_Amount_INR ELSE 0 END),0)*100,1) AS Change_Pct
    FROM raw_sales_data
    WHERE Year IN (p_year1, p_year2)
    GROUP BY Month_Number, Month_Name
    ORDER BY Month_Number;
END //
DELIMITER ;

-- Test
CALL GetDipAnalysis(2023, 2024);
CALL GetDipAnalysis(2024, 2025);


-- ============================================================
-- STORED PROCEDURE 5: GetProductPerformance
-- Call: CALL GetProductPerformance('Industrial Valve');
-- Call: CALL GetProductPerformance('Medical Valve');
-- Purpose: Full product analysis for any category
-- ============================================================

DROP PROCEDURE IF EXISTS GetProductPerformance;

DELIMITER //
CREATE PROCEDURE GetProductPerformance(
    IN p_category VARCHAR(30)
)
BEGIN
    -- Category summary
    SELECT
        Product_Category,
        COUNT(DISTINCT Product_ID)                      AS Products_in_Category,
        COUNT(*)                                        AS Total_Orders,
        SUM(Quantity_Sold)                              AS Total_Units,
        ROUND(SUM(Net_Amount_INR)/10000000, 3)          AS Revenue_Crore,
        ROUND(AVG(Unit_Price_INR), 2)                   AS Avg_Unit_Price_INR,
        ROUND(AVG(Discount_Percent), 2)                 AS Avg_Discount_Pct
    FROM raw_sales_data
    WHERE Product_Category = p_category
    GROUP BY Product_Category;

    -- Product-wise breakdown
    SELECT
        Product_ID,
        Product_Name,
        COUNT(*)                                        AS Orders,
        SUM(Quantity_Sold)                              AS Units_Sold,
        ROUND(AVG(Unit_Price_INR), 2)                   AS Avg_Price_INR,
        ROUND(SUM(Net_Amount_INR)/10000000, 3)          AS Revenue_Crore
    FROM raw_sales_data
    WHERE Product_Category = p_category
    GROUP BY Product_ID, Product_Name
    ORDER BY Revenue_Crore DESC;

    -- Year-wise trend
    SELECT
        Year,
        SUM(Quantity_Sold)                              AS Units_Sold,
        ROUND(SUM(Net_Amount_INR)/10000000, 3)          AS Revenue_Crore
    FROM raw_sales_data
    WHERE Product_Category = p_category
    GROUP BY Year
    ORDER BY Year;
END //
DELIMITER ;

-- Test
CALL GetProductPerformance('Industrial Valve');
CALL GetProductPerformance('Medical Valve');
CALL GetProductPerformance('Fire Fighting Valve');


-- ============================================================
-- STORED PROCEDURE 6: GetPaymentCollectionReport
-- Call: CALL GetPaymentCollectionReport(2024);
-- Call: CALL GetPaymentCollectionReport(2025);
-- Purpose: Full payment and outstanding report for any year
-- ============================================================

DROP PROCEDURE IF EXISTS GetPaymentCollectionReport;

DELIMITER //
CREATE PROCEDURE GetPaymentCollectionReport(
    IN p_year INT
)
BEGIN
    -- Overall payment summary
    SELECT
        p_year                                          AS Year,
        COUNT(*)                                        AS Total_Orders,
        SUM(CASE WHEN Payment_Status='Paid'
                 THEN 1 ELSE 0 END)                    AS Paid_Orders,
        SUM(CASE WHEN Payment_Status='Pending'
                 THEN 1 ELSE 0 END)                    AS Pending_Orders,
        SUM(CASE WHEN Payment_Status='Partial'
                 THEN 1 ELSE 0 END)                    AS Partial_Orders,
        ROUND(SUM(CASE WHEN Payment_Status='Paid'
                  THEN 1 ELSE 0 END)/COUNT(*)*100,1)   AS Collection_Rate_Pct,
        ROUND(SUM(CASE WHEN Payment_Status
                       IN ('Pending','Partial')
                  THEN Net_Amount_INR ELSE 0 END)
              /100000, 2)                               AS Outstanding_Lakhs
    FROM raw_sales_data
    WHERE Year = p_year;

    -- Region-wise outstanding
    SELECT
        Region,
        ROUND(SUM(CASE WHEN Payment_Status='Paid'
                  THEN 1 ELSE 0 END)/COUNT(*)*100,1)   AS Collection_Rate_Pct,
        ROUND(SUM(CASE WHEN Payment_Status
                       IN ('Pending','Partial')
                  THEN Net_Amount_INR ELSE 0 END)
              /100000, 2)                               AS Outstanding_Lakhs
    FROM raw_sales_data
    WHERE Year = p_year
    GROUP BY Region
    ORDER BY Outstanding_Lakhs DESC;

    -- Monthly collection rate trend
    SELECT
        Month_Number,
        Month_Name,
        COUNT(*)                                        AS Total_Orders,
        ROUND(SUM(CASE WHEN Payment_Status='Paid'
                  THEN 1 ELSE 0 END)/COUNT(*)*100,1)   AS Collection_Rate_Pct,
        ROUND(SUM(CASE WHEN Payment_Status
                       IN ('Pending','Partial')
                  THEN Net_Amount_INR ELSE 0 END)
              /100000, 2)                               AS Outstanding_Lakhs
    FROM raw_sales_data
    WHERE Year = p_year
    GROUP BY Month_Number, Month_Name
    ORDER BY Month_Number;
END //
DELIMITER ;

-- Test
CALL GetPaymentCollectionReport(2024);
CALL GetPaymentCollectionReport(2025);


-- ============================================================
-- SECTION B: VIEWS (3 Total)
-- What is a view?
-- A saved SELECT query that behaves like a table
-- Power BI connects to views directly
-- Data is always live — updates automatically
-- Your original tables are NOT changed
-- ============================================================


-- ============================================================
-- VIEW 1: vw_monthly_revenue_summary
-- Purpose: Power BI main revenue trend dashboard
-- Shows monthly revenue vs target with period classification
-- ============================================================

DROP VIEW IF EXISTS vw_monthly_revenue_summary;

CREATE VIEW vw_monthly_revenue_summary AS
SELECT
    r.Year,
    r.Month_Number,
    r.Month_Name,
    r.Quarter,
    COUNT(r.Transaction_ID)                             AS Total_Orders,
    COUNT(DISTINCT r.Customer_ID)                       AS Active_Customers,
    SUM(r.Quantity_Sold)                                AS Units_Sold,
    ROUND(SUM(r.Net_Amount_INR)/100000, 2)              AS Revenue_Lakhs,
    ROUND(AVG(r.Net_Amount_INR), 2)                     AS Avg_Order_Value_INR,
    ROUND(SUM(CASE WHEN r.Payment_Status='Paid'
              THEN 1 ELSE 0 END)/COUNT(*)*100, 1)       AS Collection_Rate_Pct,
    ROUND(SUM(CASE WHEN r.Payment_Status
                        IN ('Pending','Partial')
              THEN r.Net_Amount_INR ELSE 0 END)
          /100000, 2)                                   AS Outstanding_Lakhs,
    ROUND(t.Monthly_Target_INR/100000, 2)               AS Target_Lakhs,
    t.Status                                            AS Target_Status,
    CASE
        WHEN r.Year = 2024
         AND r.Month_Number BETWEEN 5 AND 9
        THEN 'Dip Period'
        WHEN r.Year = 2025
         AND r.Month_Number >= 3
        THEN 'Recovery Period'
        ELSE 'Normal'
    END                                                 AS Period_Classification
FROM raw_sales_data r
LEFT JOIN sales_targets_monthly t
    ON r.Year = t.Year
   AND r.Month_Number = t.Month_No
GROUP BY r.Year, r.Month_Number, r.Month_Name,
         r.Quarter, t.Monthly_Target_INR, t.Status
ORDER BY r.Year, r.Month_Number;

-- Test
SELECT * FROM vw_monthly_revenue_summary;


-- ============================================================
-- VIEW 2: vw_customer_360
-- Purpose: Complete customer profile for Power BI
-- Shows every customer with sales, loyalty, activity status
-- ============================================================

DROP VIEW IF EXISTS vw_customer_360;

CREATE VIEW vw_customer_360 AS
SELECT
    c.Customer_ID,
    c.Customer_Name,
    c.Customer_Type,
    c.Customer_Rating,
    c.Pricing_Tier,
    c.Customer_Since,
    2026 - c.Customer_Since                             AS Years_as_Customer,
    c.Region,
    c.State,
    c.City,
    c.Payment_Terms,
    c.Industry_Segment,
    COUNT(s.Transaction_ID)                             AS Total_Orders,
    SUM(s.Quantity_Sold)                                AS Total_Units_Bought,
    ROUND(SUM(s.Net_Amount_INR)/100000, 2)              AS Total_Revenue_Lakhs,
    ROUND(AVG(s.Net_Amount_INR), 2)                     AS Avg_Order_Value_INR,
    ROUND(SUM(CASE WHEN s.Year=2023
              THEN s.Net_Amount_INR ELSE 0 END)
          /100000, 2)                                   AS Rev_2023_Lakhs,
    ROUND(SUM(CASE WHEN s.Year=2024
              THEN s.Net_Amount_INR ELSE 0 END)
          /100000, 2)                                   AS Rev_2024_Lakhs,
    ROUND(SUM(CASE WHEN s.Year=2025
              THEN s.Net_Amount_INR ELSE 0 END)
          /100000, 2)                                   AS Rev_2025_Lakhs,
    ROUND(SUM(CASE WHEN s.Year=2026
              THEN s.Net_Amount_INR ELSE 0 END)
          /100000, 2)                                   AS Rev_2026_H1_Lakhs,
    MIN(s.Date)                                         AS First_Order_Date,
    MAX(s.Date)                                         AS Last_Order_Date,
    ROUND(SUM(CASE WHEN s.Payment_Status='Paid'
              THEN 1 ELSE 0 END)/COUNT(*)*100, 1)       AS Payment_Rate_Pct,
    CASE
        WHEN SUM(s.Net_Amount_INR) >= 5000000
        THEN 'High Value'
        WHEN SUM(s.Net_Amount_INR) >= 2000000
        THEN 'Medium Value'
        ELSE 'Standard Value'
    END                                                 AS Customer_Value_Band,
    CASE
        WHEN DATEDIFF('2026-06-30', MAX(s.Date)) <= 90
        THEN 'Active'
        WHEN DATEDIFF('2026-06-30', MAX(s.Date)) <= 180
        THEN 'At Risk'
        ELSE 'Dormant'
    END                                                 AS Activity_Status,
    CASE
        WHEN SUM(CASE WHEN s.Year=2024
                 THEN s.Net_Amount_INR ELSE 0 END) >=
             SUM(CASE WHEN s.Year=2023
                 THEN s.Net_Amount_INR ELSE 0 END) * 0.90
        THEN 'Loyal During Dip'
        ELSE 'Reduced Orders in Dip'
    END                                                 AS Dip_Loyalty_Status
FROM customer_master c
LEFT JOIN raw_sales_data s ON c.Customer_ID = s.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name, c.Customer_Type,
         c.Customer_Rating, c.Pricing_Tier, c.Customer_Since,
         c.Region, c.State, c.City, c.Payment_Terms,
         c.Industry_Segment
ORDER BY Total_Revenue_Lakhs DESC;

-- Test
SELECT * FROM vw_customer_360 LIMIT 10;


-- ============================================================
-- VIEW 3: vw_region_product_summary
-- Purpose: Region and product combined summary for Power BI
-- Shows which product sells best in which region
-- ============================================================

DROP VIEW IF EXISTS vw_region_product_summary;

CREATE VIEW vw_region_product_summary AS
SELECT
    Region,
    Product_Category,
    Product_Name,
    COUNT(*)                                            AS Total_Orders,
    SUM(Quantity_Sold)                                  AS Total_Units,
    ROUND(SUM(Net_Amount_INR)/10000000, 3)              AS Revenue_Crore,
    ROUND(SUM(CASE WHEN Year=2023
              THEN Net_Amount_INR ELSE 0 END)
          /10000000, 3)                                 AS Rev_2023_Crore,
    ROUND(SUM(CASE WHEN Year=2024
              THEN Net_Amount_INR ELSE 0 END)
          /10000000, 3)                                 AS Rev_2024_Crore,
    ROUND(SUM(CASE WHEN Year=2025
              THEN Net_Amount_INR ELSE 0 END)
          /10000000, 3)                                 AS Rev_2025_Crore,
    ROUND(AVG(Unit_Price_INR), 2)                       AS Avg_Unit_Price_INR,
    ROUND(AVG(Discount_Percent), 2)                     AS Avg_Discount_Pct
FROM raw_sales_data
GROUP BY Region, Product_Category, Product_Name
ORDER BY Region, Revenue_Crore DESC;

-- Test
SELECT * FROM vw_region_product_summary LIMIT 20;


-- ============================================================
-- VERIFY ALL PROCEDURES AND VIEWS CREATED
-- ============================================================

SELECT '=== STORED PROCEDURES CREATED ===' AS '';
SELECT
    ROUTINE_NAME        AS Procedure_Name,
    ROUTINE_TYPE        AS Type,
    CREATED             AS Created_At
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_SCHEMA = 'bhartiya_valves'
  AND ROUTINE_TYPE = 'PROCEDURE'
ORDER BY ROUTINE_NAME;

SELECT '=== VIEWS CREATED ===' AS '';
SELECT
    TABLE_NAME          AS View_Name,
    'VIEW'              AS Type
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'bhartiya_valves'
ORDER BY TABLE_NAME;

SELECT '=== COMPLETE ===' AS '';
SELECT
    '6 Stored Procedures' AS Created,
    'GetRevenueByRegion, GetTopNCustomers, GetSalespersonScorecard, GetDipAnalysis, GetProductPerformance, GetPaymentCollectionReport' AS Procedures;
SELECT
    '3 Views' AS Created,
    'vw_monthly_revenue_summary, vw_customer_360, vw_region_product_summary' AS Views;
SELECT
    'Raw data SAFE' AS Status,
    'No existing tables were modified' AS Confirmation;

-- ============================================================
-- END OF FILE: 04_procedures_and_views.sql
-- 6 Stored Procedures + 3 Views
-- ============================================================
