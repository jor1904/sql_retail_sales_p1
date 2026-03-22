-- SQL Retail Sales Analysis - P1
/*
CREATE DATABASE sql_project_p1
*/
-- Create TABLE
CREATE TABLE RETAIL_SALES (
	TRANSACTIONS_ID INT PRIMARY KEY,
	SALE_DATE DATE,
	SALE_TIME TIME,
	CUSTOMER_ID INT,
	GENDER VARCHAR(15),
	AGE INT,
	CATEGORY VARCHAR(15),
	QUANTIY INT,
	PRICE_PER_UNIT FLOAT,
	COGS FLOAT,
	TOTAL_SALE FLOAT
);

SELECT * FROM retail_sales;

SELECT
	COUNT(*)
FROM
	RETAIL_SALES;


-- Data Cleaning

ALTER TABLE retail_sales RENAME COLUMN quantiy to quantity;

SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

SELECT *
FROM retail_sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;


DELETE FROM retail_sales 
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;


-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales;

-- How many unique customers do we have?
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales;

-- How many unique category do we have?
SELECT COUNT(DISTINCT category) FROM retail_sales;

-- Data Analysis & Business Key Problems & Answers

-- Q1 Retrieve all columns for sales made on '2022-11-05'

SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';

-- Q2 Retrieve all transactions where category is 'Clothing' and quantity sold is more than 4 in Nov-2022

SELECT
	*
FROM
	RETAIL_SALES
WHERE
	CATEGORY = 'Clothing'
	AND QUANTITY >= 4
	AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';

	
-- Q3 Calculate total sales for each category
SELECT
	CATEGORY,
	SUM(TOTAL_SALE) AS TOTAL_SALES
FROM
	RETAIL_SALES
GROUP BY
	CATEGORY;

-- Q4 Find the average age of customers who purchased items from the 'Beauty' category

SELECT
	AVG(AGE) AS AVERAGE_AGE,
	CATEGORY
FROM
	RETAIL_SALES
WHERE
	CATEGORY = 'Beauty'
GROUP BY
	CATEGORY;
	
-- Q5 Find all transactions where total_sale is greater than 1000

SELECT * FROM retail_sales WHERE total_sale >= 1000;

-- Q6 Find the total number of transactions made by each gender in each category

SELECT gender, category, COUNT(*) AS Transactions FROM retail_sales GROUP BY gender, category

-- Q7 Calculate average sale for each month and find the best selling month in each year

SELECT
    year,
    month,
    avg_sale
FROM (
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rnk
    FROM retail_sales
    GROUP BY
        EXTRACT(YEAR FROM sale_date),
        EXTRACT(MONTH FROM sale_date)
) t1
WHERE rnk = 1;


-- Q8 Find the top 5 customers based on highest total sales

SELECT
    customer_id,
    SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;


-- Q9 Find the number of unique customers who purchased items from each category

SELECT
	CATEGORY,
	COUNT(DISTINCT CUSTOMER_ID)
FROM
	RETAIL_SALES
GROUP BY
	CATEGORY;

	
-- Q10 Create order shifts and count number of orders (Morning < 12, Afternoon 12–17, Evening > 17)


WITH hourly_sales
AS (
SELECT *,
CASE 
	WHEN EXTRACT(HOUR FROM sale_time) < 12  THEN 'Morning'
	WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 and 17 THEN 'Afternoon'
	ELSE 'Evening'
END AS shift
FROM retail_sales
)
SELECT 
shift,
COUNT(*) as total_orders
FROM hourly_saled
GROUP BY shift;
