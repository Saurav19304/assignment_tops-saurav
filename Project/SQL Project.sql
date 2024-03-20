CREATE DATABASE IF NOT EXISTS walmartSales;

CREATE TABLE IF NOT EXISTS sales (
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10 , 2 ) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6 , 4 ) NOT NULL,
    total DECIMAL(12 , 4 ) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10 , 2 ) NOT NULL,
    gross_margin_pct FLOAT(11 , 9 ),
    gross_income DECIMAL(12 , 4 ),
    rating FLOAT(2 , 1 )
);

-- CLEANING

SELECT 
    time,
    CASE
        WHEN tIME BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN tIME BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        WHEN tIME BETWEEN '16:01:00' AND '19:00:00' THEN 'Evening'
        ELSE 'Night'
    END AS time_of_date
FROM
    sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);
UPDATE sales 
SET 
    time_of_day = (CASE
        WHEN tIME BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN tIME BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        WHEN tIME BETWEEN '16:01:00' AND '19:00:00' THEN 'Evening'
        ELSE 'Night'
    END);

SELECT 
    date, DAYNAME(date)
FROM
    sales;
    
ALTER TABLE sales ADD COLUMN day_name VARCHAR (20);

UPDATE sales 
SET 
    day_name = DAYNAME(date);

SELECT 
    date, MONTHNAME(DATE)
FROM
    sales;
    
ALTER TABLE sales ADD COLUMN month_name VARCHAR(20);

UPDATE sales 
SET 
    month_name = MONTHNAME(DATE);


-- How many unique cities does the data have?

SELECT DISTINCT
    city
FROM
    sales;
    
-- In which city is each branch?

SELECT DISTINCT
    branch, city
FROM
    sales;
    

-- How many unique product lines does the data have?

SELECT DISTINCT
    product_category
FROM
    sales;
    
-- What is the most common payment method?

SELECT 
    payment_mode, COUNT(payment_mode) AS 'COUNT'
FROM
    sales
GROUP BY payment_mode
ORDER BY 'COUNT' DESC;

-- What is the most selling product line?

SELECT 
    product_category, COUNT(product_category) AS 'COUNT'
FROM
    sales
GROUP BY payment_mode
ORDER BY 'COUNT' DESC;

-- What is the total revenue by month?

SELECT 
    month_name AS 'MONTH', SUM(TOTAL) AS total_sales
FROM
    SALES
GROUP BY month_name
ORDER BY total_sales DESC;

-- What month had the largest COGS?

SELECT 
    month_name AS 'month', SUM(cogs) AS cogs
FROM
    sales
GROUP BY month_name
ORDER BY cogs DESC;

-- What product line had the largest revenue?

SELECT 
    product_category, SUM(TOTAL) AS total_sales
FROM
    SALES
GROUP BY product_category
ORDER BY total_sales DESC;

-- What is the city with the largest revenue?

SELECT 
    branch, city, SUM(TOTAL) AS total_sales
FROM
    SALES
GROUP BY branch , city
ORDER BY total_sales DESC;

-- What product line had the largest VAT?

SELECT 
    product_category, AVG(tax) AS avg_tax
FROM
    SALES
GROUP BY product_category
ORDER BY avg_tax DESC;

-- Which branch sold more products than average product sold?

SELECT 
    branch, SUM(quantity) AS total_qant
FROM
    sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT 
        AVG(quantity)
    FROM
        sales);
        
-- What is the most common product line by gender?

SELECT 
    gender, product_category, COUNT(gender) AS total_count
FROM
    sales
GROUP BY gender , product_category
ORDER BY total_count DESC;

-- What is the average rating of each product line?

SELECT 
    product_category, ROUND(AVG(rating), 2) AS avg_rating
FROM
    sales
GROUP BY product_category
ORDER BY avg_rating DESC;

-- Number of sales made in each time of the day per weekday

SELECT 
    time_of_day, COUNT(*) AS total_sales
FROM
    sales
WHERE
    day_name = 'SUNDAY'
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- Which of the customer types brings the most revenue?

SELECT 
    customer_type, SUM(total) AS total_sales
FROM
    sales
GROUP BY customer_type
ORDER BY total_sales DESC;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?

SELECT 
    city, AVG(tax) AS avg_tax
FROM
    sales
GROUP BY city
ORDER BY avg_tax DESC;

-- Which customer type pays the most in VAT?

SELECT 
    customer_type, ROUND(AVG(tax), 2) AS avg_tax
FROM
    sales
GROUP BY customer_type
ORDER BY avg_tax DESC;

-- How many unique customer types does the data have?

SELECT DISTINCT
    (customer_type)
FROM
    sales;
    
-- How many unique payment methods does the data have?

SELECT DISTINCT
    (payment_mode)
FROM
    sales;
    
-- Which customer type buys the most?

SELECT 
    customer_type, COUNT(*) AS total_customer
FROM
    sales
GROUP BY customer_type
ORDER BY total_customer DESC;

-- What is the gender of most of the customers?

SELECT 
    gender, COUNT(*) AS total_gender
FROM
    sales
GROUP BY gender
ORDER BY total_gender DESC;

-- What is the gender distribution per branch?

SELECT 
    gender, COUNT(*) AS total_gender
FROM
    sales
WHERE
    branch = 'A'
GROUP BY gender
ORDER BY total_gender DESC;

SELECT 
    gender, COUNT(*) AS total_gender
FROM
    sales
WHERE
    branch = 'B'
GROUP BY gender
ORDER BY total_gender DESC;

SELECT 
    gender, COUNT(*) AS total_gender
FROM
    sales
WHERE
    branch = 'C'
GROUP BY gender
ORDER BY total_gender DESC;

-- Which time of the day do customers give most ratings?

SELECT 
    time_of_day, ROUND(AVG(rating), 1) AS avg_rating
FROM
    sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which time of the day do customers give most ratings per branch?

SELECT 
    time_of_day, ROUND(AVG(rating), 1) AS avg_rating
FROM
    sales
WHERE
    branch = 'A'
GROUP BY time_of_day
ORDER BY avg_rating DESC;

SELECT 
    time_of_day, ROUND(AVG(rating), 1) AS avg_rating
FROM
    sales
WHERE
    branch = 'B'
GROUP BY time_of_day
ORDER BY avg_rating DESC;

SELECT 
    time_of_day, ROUND(AVG(rating), 1) AS avg_rating
FROM
    sales
WHERE
    branch = 'C'
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which day of the week has the best avg ratings?

SELECT 
    day_name, ROUND(AVG(rating), 1) AS avg_rating
FROM
    sales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- Which day of the week has the best average ratings per branch?

SELECT 
    day_name, ROUND(AVG(rating), 1) AS avg_rating
FROM
    sales
WHERE
    branch = 'A'
GROUP BY day_name
ORDER BY avg_rating DESC;

SELECT 
    day_name, ROUND(AVG(rating), 1) AS avg_rating
FROM
    sales
WHERE
    branch = 'B'
GROUP BY day_name
ORDER BY avg_rating DESC;

SELECT 
    day_name, ROUND(AVG(rating), 1) AS avg_rating
FROM
    sales
WHERE
    branch = 'C'
GROUP BY day_name
ORDER BY avg_rating DESC;

