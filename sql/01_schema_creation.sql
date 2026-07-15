-- ============================================================
-- BHARTIYA VALVES — MYSQL DATABASE SCRIPT
-- CSV Path: D:/bhartiya_csv/
-- ============================================================

-- STEP 0: Run this first, then reconnect MySQL Workbench
SET GLOBAL local_infile = 1;

-- ============================================================
-- STEP 1: CREATE DATABASE
-- ============================================================

DROP DATABASE IF EXISTS bhartiya_valves;
CREATE DATABASE bhartiya_valves
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE bhartiya_valves;

-- ============================================================
-- STEP 2: CREATE ALL TABLES
-- ============================================================

-- TABLE 1: region_master
-- 8 rows | One row per sales region
-- ============================================================
CREATE TABLE region_master (
    Region_ID               VARCHAR(10)     NOT NULL,
    Region_Name             VARCHAR(50)     NOT NULL,
    State_Covered           VARCHAR(50)     NOT NULL,
    Total_Customers         SMALLINT        NOT NULL,
    Total_Transactions      INT             NOT NULL,
    Total_NET_Revenue_INR   DECIMAL(15,2)   NOT NULL,
    Revenue_Share_Pct       DECIMAL(6,4)    NOT NULL,
    Assigned_SP_Count       TINYINT         NOT NULL,
    PRIMARY KEY (Region_ID)
);


-- TABLE 2: region_salesperson_map
-- 18 rows | One row per salesperson per region
-- ============================================================
CREATE TABLE region_salesperson_map (
    Region_ID               VARCHAR(10)     NOT NULL,
    Region_Name             VARCHAR(50)     NOT NULL,
    Salesperson_ID          VARCHAR(10)     NOT NULL,
    Salesperson_Name        VARCHAR(50)     NOT NULL,
    Total_Transactions      INT             NOT NULL,
    Total_NET_Revenue_INR   DECIMAL(15,2)   NOT NULL,
    PRIMARY KEY (Region_ID, Salesperson_ID),
    FOREIGN KEY (Region_ID) REFERENCES region_master(Region_ID)
);


-- TABLE 3: region_city_map
-- 39 rows | One row per city
-- ============================================================
CREATE TABLE region_city_map (
    Region_ID                   VARCHAR(10)     NOT NULL,
    Region_Name                 VARCHAR(50)     NOT NULL,
    City_Name                   VARCHAR(50)     NOT NULL,
    State                       VARCHAR(40)     NOT NULL,
    Total_Transactions_in_City  INT             NOT NULL,
    PRIMARY KEY (Region_ID, City_Name),
    FOREIGN KEY (Region_ID) REFERENCES region_master(Region_ID)
);


-- TABLE 4: region_deliverymode_map
-- 24 rows | One row per delivery mode per region
-- ============================================================
CREATE TABLE region_deliverymode_map (
    Region_ID                   VARCHAR(10)     NOT NULL,
    Region_Name                 VARCHAR(50)     NOT NULL,
    Delivery_Mode               VARCHAR(50)     NOT NULL,
    Mode_Type                   VARCHAR(30)     NOT NULL,
    Is_Active                   VARCHAR(5)      NOT NULL,
    Total_Transactions_via_Mode INT             NOT NULL,
    PRIMARY KEY (Region_ID, Delivery_Mode),
    FOREIGN KEY (Region_ID) REFERENCES region_master(Region_ID)
);


-- TABLE 5: product_catalogue
-- 12 rows | One row per product
-- ============================================================
CREATE TABLE product_catalogue (
    Product_ID                  VARCHAR(10)     NOT NULL,
    Product_Name                VARCHAR(100)    NOT NULL,
    Product_Category            VARCHAR(30)     NOT NULL,
    Product_Subcategory         VARCHAR(60)     NOT NULL,
    Primary_Application         VARCHAR(150)    NOT NULL,
    Standards_and_Certification VARCHAR(60)     NOT NULL,
    Inlet_Thread_Size           VARCHAR(30)         NULL,
    Body_Material               VARCHAR(30)     NOT NULL,
    Product_Description         VARCHAR(300)    NOT NULL,
    Base_Price_Low_INR          DECIMAL(8,2)    NOT NULL,
    Base_Price_High_INR         DECIMAL(8,2)    NOT NULL,
    Avg_Selling_Price_INR       DECIMAL(8,2)    NOT NULL,
    Revenue_Share_Pct           DECIMAL(6,4)    NOT NULL,
    Unit_Share_Pct              DECIMAL(6,4)    NOT NULL,
    PRIMARY KEY (Product_ID)
);


-- TABLE 6: customer_master
-- 150 rows | One row per customer
-- ============================================================
CREATE TABLE customer_master (
    Customer_ID                 VARCHAR(10)     NOT NULL,
    Customer_Name               VARCHAR(80)     NOT NULL,
    Customer_Type               VARCHAR(40)     NOT NULL,
    Contact_Person              VARCHAR(50)     NOT NULL,
    Designation                 VARCHAR(40)     NOT NULL,
    Phone                       BIGINT          NOT NULL,
    Email                       VARCHAR(80)     NOT NULL,
    City                        VARCHAR(30)     NOT NULL,
    Region                      VARCHAR(50)     NOT NULL,
    State                       VARCHAR(30)     NOT NULL,
    PIN_Code                    VARCHAR(10)     NOT NULL,
    GST_Number                  VARCHAR(20)     NOT NULL,
    PAN_Number                  VARCHAR(15)     NOT NULL,
    Credit_Limit_INR            DECIMAL(12,2)   NOT NULL,
    Outstanding_Amount_INR      DECIMAL(12,2)   NOT NULL,
    Payment_Terms               VARCHAR(15)     NOT NULL,
    Customer_Since              YEAR            NOT NULL,
    Industry_Segment            VARCHAR(20)     NOT NULL,
    Annual_Purchase_Value_INR   DECIMAL(14,2)   NOT NULL,
    Customer_Rating             VARCHAR(5)      NOT NULL,
    Pricing_Tier                VARCHAR(25)     NOT NULL,
    Remarks                     VARCHAR(100)    NOT NULL,
    PRIMARY KEY (Customer_ID)
);


-- TABLE 7: sales_targets_monthly
-- 42 rows | One row per month (Jan 2023 – Jun 2026)
-- ============================================================
CREATE TABLE sales_targets_monthly (
    Month_No                TINYINT         NOT NULL,
    Month_Name              VARCHAR(12)     NOT NULL,
    Year                    YEAR            NOT NULL,
    Monthly_Target_INR      DECIMAL(14,2)   NOT NULL,
    Monthly_Actual_INR      DECIMAL(14,2)   NOT NULL,
    Variance_INR            DECIMAL(14,2)   NOT NULL,
    Achievement_Pct         DECIMAL(6,4)    NOT NULL,
    Status                  VARCHAR(15)     NOT NULL,
    Units_Target            INT             NOT NULL,
    Units_Actual            INT             NOT NULL,
    PRIMARY KEY (Year, Month_No)
);


-- TABLE 8: sales_targets_region
-- 32 rows | One row per region per year
-- ============================================================
CREATE TABLE sales_targets_region (
    Region                  VARCHAR(50)     NOT NULL,
    Year                    YEAR            NOT NULL,
    Annual_Target_INR       DECIMAL(14,2)   NOT NULL,
    Annual_Actual_INR       DECIMAL(14,2)   NOT NULL,
    Variance_INR            DECIMAL(14,2)   NOT NULL,
    Achievement_Pct         DECIMAL(6,4)    NOT NULL,
    Status                  VARCHAR(15)     NOT NULL,
    Revenue_Share_Pct       DECIMAL(6,4)    NOT NULL,
    PRIMARY KEY (Region, Year)
);


-- TABLE 9: kpi_dashboard
-- 336 rows | 8 KPIs × 42 months
-- ============================================================
CREATE TABLE kpi_dashboard (
    Year            YEAR            NOT NULL,
    Month           VARCHAR(12)     NOT NULL,
    KPI_Name        VARCHAR(40)     NOT NULL,
    Category        VARCHAR(20)     NOT NULL,
    Target          DECIMAL(12,4)   NOT NULL,
    Actual          DECIMAL(12,4)   NOT NULL,
    Unit            VARCHAR(15)     NOT NULL,
    Achievement_Pct DECIMAL(6,4)    NOT NULL,
    Status          VARCHAR(15)     NOT NULL,
    MoM_Trend       VARCHAR(5)      NOT NULL,
    Remarks         VARCHAR(200)        NULL,
    PRIMARY KEY (Year, Month, KPI_Name)
);


-- TABLE 10: raw_sales_data
-- 103,842 rows | Main fact table — load LAST
-- ============================================================
CREATE TABLE raw_sales_data (
    Transaction_ID              VARCHAR(20)     NOT NULL,
    Date                        DATE            NOT NULL,
    Invoice_Number              VARCHAR(25)     NOT NULL,
    Customer_ID                 VARCHAR(10)     NOT NULL,
    Customer_Name               VARCHAR(80)     NOT NULL,
    Customer_Type               VARCHAR(40)     NOT NULL,
    Product_ID                  VARCHAR(10)     NOT NULL,
    Product_Name                VARCHAR(100)    NOT NULL,
    Product_Category            VARCHAR(30)     NOT NULL,
    Inlet_Thread_Size           VARCHAR(15)     NOT NULL,
    Quantity_Sold               INT             NOT NULL,
    Unit_Price_INR              DECIMAL(8,2)    NOT NULL,
    Gross_Amount_INR            DECIMAL(12,2)   NOT NULL,
    Discount_Percent            TINYINT         NOT NULL,
    Discount_Amount_INR         DECIMAL(12,2)   NOT NULL,
    Net_Amount_INR              DECIMAL(12,2)   NOT NULL,
    GST_Rate_Percent            TINYINT         NOT NULL,
    GST_Amount_INR              DECIMAL(12,2)   NOT NULL,
    Total_Invoice_Amount_INR    DECIMAL(12,2)   NOT NULL,
    Region                      VARCHAR(50)     NOT NULL,
    City                        VARCHAR(30)     NOT NULL,
    Salesperson_ID              VARCHAR(10)     NOT NULL,
    Salesperson_Name            VARCHAR(50)     NOT NULL,
    Payment_Status              VARCHAR(10)     NOT NULL,
    Payment_Method              VARCHAR(30)     NOT NULL,
    Payment_Due_Date            DATE            NOT NULL,
    Delivery_Mode               VARCHAR(40)     NOT NULL,
    Year                        YEAR            NOT NULL,
    Month_Number                TINYINT         NOT NULL,
    Month_Name                  VARCHAR(12)     NOT NULL,
    Quarter                     VARCHAR(2)      NOT NULL,
    PRIMARY KEY (Transaction_ID),
    FOREIGN KEY (Customer_ID)  REFERENCES customer_master(Customer_ID),
    FOREIGN KEY (Product_ID)   REFERENCES product_catalogue(Product_ID),
    INDEX idx_region            (Region),
    INDEX idx_year_month        (Year, Month_Number),
    INDEX idx_customer          (Customer_ID),
    INDEX idx_product           (Product_ID),
    INDEX idx_salesperson       (Salesperson_ID),
    INDEX idx_date              (Date),
    INDEX idx_payment_status    (Payment_Status)
);


-- ============================================================
-- STEP 3: LOAD DATA — all from D:/bhartiya_csv/
-- ============================================================

-- LOAD 1: region_master
LOAD DATA LOCAL INFILE 'D:/bhartiya_csv/region_master.csv'
INTO TABLE region_master
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Region_ID, Region_Name, State_Covered, Total_Customers,
 Total_Transactions, Total_NET_Revenue_INR, Revenue_Share_Pct, Assigned_SP_Count);
SELECT 'region_master' AS Table_Name, COUNT(*) AS Rows_Loaded FROM region_master;

-- LOAD 2: region_salesperson_map
LOAD DATA LOCAL INFILE 'D:/bhartiya_csv/region_salesperson_map.csv'
INTO TABLE region_salesperson_map
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Region_ID, Region_Name, Salesperson_ID, Salesperson_Name,
 Total_Transactions, Total_NET_Revenue_INR);
SELECT 'region_salesperson_map' AS Table_Name, COUNT(*) AS Rows_Loaded FROM region_salesperson_map;

-- LOAD 3: region_city_map
LOAD DATA LOCAL INFILE 'D:/bhartiya_csv/region_city_map.csv'
INTO TABLE region_city_map
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Region_ID, Region_Name, City_Name, State, Total_Transactions_in_City);
SELECT 'region_city_map' AS Table_Name, COUNT(*) AS Rows_Loaded FROM region_city_map;

-- LOAD 4: region_deliverymode_map
LOAD DATA LOCAL INFILE 'D:/bhartiya_csv/region_deliverymode_map.csv'
INTO TABLE region_deliverymode_map
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Region_ID, Region_Name, Delivery_Mode, Mode_Type, Is_Active, Total_Transactions_via_Mode);
SELECT 'region_deliverymode_map' AS Table_Name, COUNT(*) AS Rows_Loaded FROM region_deliverymode_map;

-- LOAD 5: product_catalogue
LOAD DATA LOCAL INFILE 'D:/bhartiya_csv/product_catalogue.csv'
INTO TABLE product_catalogue
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Product_ID, Product_Name, Product_Category, Product_Subcategory,
 Primary_Application, Standards_and_Certification, Inlet_Thread_Size,
 Body_Material, Product_Description, Base_Price_Low_INR, Base_Price_High_INR,
 Avg_Selling_Price_INR, Revenue_Share_Pct, Unit_Share_Pct);
SELECT 'product_catalogue' AS Table_Name, COUNT(*) AS Rows_Loaded FROM product_catalogue;

-- LOAD 6: customer_master
LOAD DATA LOCAL INFILE 'D:/bhartiya_csv/customer_master.csv'
INTO TABLE customer_master
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Customer_ID, Customer_Name, Customer_Type, Contact_Person, Designation,
 Phone, Email, City, Region, State, PIN_Code, GST_Number, PAN_Number,
 Credit_Limit_INR, Outstanding_Amount_INR, Payment_Terms, Customer_Since,
 Industry_Segment, Annual_Purchase_Value_INR, Customer_Rating,
 Pricing_Tier, Remarks);
SELECT 'customer_master' AS Table_Name, COUNT(*) AS Rows_Loaded FROM customer_master;

-- LOAD 7: sales_targets_monthly
LOAD DATA LOCAL INFILE 'D:/bhartiya_csv/sales_targets_monthly.csv'
INTO TABLE sales_targets_monthly
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Month_No, Month_Name, Year, Monthly_Target_INR, Monthly_Actual_INR,
 Variance_INR, Achievement_Pct, Status, Units_Target, Units_Actual);
SELECT 'sales_targets_monthly' AS Table_Name, COUNT(*) AS Rows_Loaded FROM sales_targets_monthly;

-- LOAD 8: sales_targets_region
LOAD DATA LOCAL INFILE 'D:/bhartiya_csv/sales_targets_region.csv'
INTO TABLE sales_targets_region
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Region, Year, Annual_Target_INR, Annual_Actual_INR, Variance_INR,
 Achievement_Pct, Status, Revenue_Share_Pct);
SELECT 'sales_targets_region' AS Table_Name, COUNT(*) AS Rows_Loaded FROM sales_targets_region;

-- LOAD 9: kpi_dashboard
LOAD DATA LOCAL INFILE 'D:/bhartiya_csv/kpi_dashboard.csv'
INTO TABLE kpi_dashboard
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Year, Month, KPI_Name, Category, Target, Actual, Unit,
 Achievement_Pct, Status, MoM_Trend, Remarks);
SELECT 'kpi_dashboard' AS Table_Name, COUNT(*) AS Rows_Loaded FROM kpi_dashboard;

-- LOAD 10: raw_sales_data (always load last)
LOAD DATA LOCAL INFILE 'D:/bhartiya_csv/raw_sales_data.csv'
INTO TABLE raw_sales_data
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Transaction_ID, Date, Invoice_Number, Customer_ID, Customer_Name,
 Customer_Type, Product_ID, Product_Name, Product_Category, Inlet_Thread_Size,
 Quantity_Sold, Unit_Price_INR, Gross_Amount_INR, Discount_Percent,
 Discount_Amount_INR, Net_Amount_INR, GST_Rate_Percent, GST_Amount_INR,
 Total_Invoice_Amount_INR, Region, City, Salesperson_ID, Salesperson_Name,
 Payment_Status, Payment_Method, Payment_Due_Date, Delivery_Mode,
 Year, Month_Number, Month_Name, Quarter);
SELECT 'raw_sales_data' AS Table_Name, COUNT(*) AS Rows_Loaded FROM raw_sales_data;

