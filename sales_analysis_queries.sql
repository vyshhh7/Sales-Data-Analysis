-- =====================================================================
-- Sales Data Analysis Queries
-- Source table: sales  (loaded from cleaned_sales_data.csv)
--
-- Columns:
--   Product_ID, Sale_Date (text, DD-MM-YYYY), Sales_Rep, Region,
--   Quantity_Sold, Product_Category, Unit_Cost, Unit_Price,
--   Customer_Type, Discount (text, e.g. '9%'), Payment_Method,
--   Sales_Channel, Revenue, Cost
--

-- ===================================================
-- Q1: What is the total sales revenue?
-- ===================================================
SELECT
    ROUND(SUM(Revenue), 2) AS Total_Sales_Revenue
FROM cleaned_sales_data;


-- ===================================================
-- Q2: What is the total profit?
-- ===================================================
SELECT
    ROUND(SUM(Revenue - Cost), 2) AS Total_Profit
FROM cleaned_sales_data;


-- ===================================================
-- Q3: What is the total quantity of products sold?
-- ===================================================
SELECT
    SUM(Quantity_Sold) AS Total_Quantity_Sold
FROM cleaned_sales_data;


-- ===================================================
-- Q4: Which products generate the highest sales (revenue)?
-- ===================================================
SELECT
   Product_Category, Product_ID,
    ROUND(SUM(Revenue), 2) AS Total_Revenue
FROM cleaned_sales_data
GROUP BY Product_Category,Product_ID
ORDER BY Total_Revenue DESC
LIMIT 10;


-- ===================================================
-- Q5: Which products generate the highest profit?
-- ===================================================
SELECT
    Product_Category,Product_ID,
    ROUND(SUM(Revenue - Cost), 2) AS Total_Profit
FROM cleaned_sales_data
GROUP BY Product_Category,Product_ID
ORDER BY Total_Profit DESC
LIMIT 10;


-- ===================================================
-- Q6: Which categories have the highest sales and profit?
-- ===================================================
SELECT
    Product_Category,
    ROUND(SUM(Revenue), 2)             AS Total_Revenue,
    ROUND(SUM(Revenue - Cost), 2)      AS Total_Profit
FROM cleaned_sales_data
GROUP BY Product_Category
ORDER BY Total_Revenue DESC;


-- ===================================================
-- Q7: Which regions perform best?
-- ===================================================
SELECT
    Region,
    COUNT(*)                      AS Num_Orders,
    ROUND(SUM(Revenue), 2)        AS Total_Revenue,
    ROUND(SUM(Revenue - Cost), 2) AS Total_Profit
FROM cleaned_sales_data
GROUP BY Region
ORDER BY Total_Revenue DESC;


-- ===================================================
-- Q8: Which sales representatives generate the most revenue?
-- ===================================================
SELECT
    Sales_Rep,
    COUNT(*)                AS Num_Sales,
    ROUND(SUM(Revenue), 2)  AS Total_Revenue,
    ROUND(AVG(Revenue), 2)  AS Avg_Revenue_Per_Sale
FROM cleaned_sales_data
GROUP BY Sales_Rep
ORDER BY Total_Revenue DESC;


-- ===================================================
-- Q9: How do new vs. returning customers compare in sales?
-- ===================================================
SELECT
    Customer_Type,
    COUNT(*)                                              AS Num_Orders,
    ROUND(SUM(Revenue), 2)                                AS Total_Revenue,
    ROUND(AVG(Revenue), 2)                                AS Avg_Order_Value,
    ROUND(AVG(CAST(REPLACE(Discount,'%','') AS FLOAT)),2) AS Avg_Discount_Pct
FROM cleaned_sales_data
GROUP BY Customer_Type;


-- ===================================================
-- Q10: What are the monthly sales trends?
-- ===================================================
SELECT
    SUBSTR(Sale_Date, 4, 2) AS Sale_Month,
    COUNT(*)                AS Num_Orders,
    ROUND(SUM(Revenue), 2)  AS Total_Revenue
FROM cleaned_sales_data
GROUP BY Sale_Month
ORDER BY Sale_Month;


-- ===================================================
-- Q11: Which products have the highest quantities sold?
-- ===================================================
SELECT
    Product_Category,Product_ID,
    SUM(Quantity_Sold) AS Total_Units_Sold
FROM cleaned_sales_data
GROUP BY Product_Category,Product_ID
ORDER BY Total_Units_Sold DESC
LIMIT 10;


-- ===================================================
-- Q12: What is the average order/sale value?
-- ===================================================
SELECT
    ROUND(AVG(Revenue), 2) AS Avg_Order_Value
FROM cleaned_sales_data;


-- ===================================================
-- Q13: Does a higher discount appear to be associated with higher sales?
-- ===================================================
SELECT
    CASE
        WHEN CAST(REPLACE(Discount,'%','') AS FLOAT) < 10 THEN '0-9%'
        WHEN CAST(REPLACE(Discount,'%','') AS FLOAT) < 20 THEN '10-19%'
        WHEN CAST(REPLACE(Discount,'%','') AS FLOAT) < 30 THEN '20-29%'
        ELSE '30%+'
    END AS Discount_Bucket,
    COUNT(*)                AS Num_Orders,
    ROUND(AVG(Revenue), 2)  AS Avg_Revenue
FROM cleaned_sales_data
GROUP BY Discount_Bucket
ORDER BY Discount_Bucket;


-- ===================================================
-- Q14: Which products/categories have low sales or low profit?
-- ===================================================
-- 14a: Bottom 10 products by revenue
SELECT
    Product_Category,Product_ID,
    ROUND(SUM(Revenue), 2) AS Total_Revenue
FROM cleaned_sales_data
GROUP BY Product_Category, Product_ID
ORDER BY Total_Revenue ASC
LIMIT 10;

-- 14b: Bottom 10 products by profit
SELECT
    Product_Category,Product_ID,
    ROUND(SUM(Revenue - Cost), 2) AS Total_Profit
FROM cleaned_sales_data
GROUP BY Product_Category,Product_ID
ORDER BY Total_Profit ASC
LIMIT 10;

-- 14c: Categories ranked lowest to highest by revenue and profit
SELECT
    Product_Category,
    ROUND(SUM(Revenue), 2)        AS Total_Revenue,
    ROUND(SUM(Revenue - Cost), 2) AS Total_Profit
FROM cleaned_sales_data
GROUP BY Product_Category
ORDER BY Total_Profit ASC;
