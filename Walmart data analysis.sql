Create Database Walmart;

Create Table Walmart_sales_data (
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    order_date DATETIME NOT NULL,
    order_time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT,
    gross_income DECIMAL(12, 4),
    rating FLOAT not null
);


select *
from walmart_sales_data;

-- Feature Engineering

# time_of_the_day

select order_time, 
(Case
	When Order_time between '00:00:00' And '12:00:00' then 'Morning'
    When Order_time between '12:00:01' And '16:00:00' then 'Afternoon'
    else 'Evening'
    end
)  As time_of_the_date
from walmart_sales_data;

alter table walmart_sales_data
add column time_of_the_date varchar(10);

update walmart_sales_data
set time_of_the_date = ( Case
	When Order_time between '00:00:00' And '12:00:00' then 'Morning'
    When Order_time between '12:00:01' And '16:00:00' then 'Afternoon'
    else 'Evening'
    end
) ; 


# Adding day and Month to the table

select order_date , monthname(order_date) , dayname(Order_date)
from walmart_sales_data;

alter table walmart_sales_data
add column  Order_day Varchar(10);

alter table walmart_sales_data
add column  Month_name Varchar(10);


update walmart_sales_data
set Month_name = monthname(order_date);

update walmart_sales_data
set Order_day = dayname(Order_date);

Select *
from walmart_sales_data;


-- How many unique cities does the data have?

select count(distinct city)
from walmart_sales_data;


-- In which city is each branch?

select distinct city , branch	
from walmart_sales_data;

-- How many unique product lines does the data have?

select distinct product_line
from walmart_sales_data;

-- What is the most common payment method?

select payment, count(Payment)
from walmart_sales_data
group by payment
order by count(payment) desc
limit 1;

-- What is the most selling product line?

select product_line, sum(quantity) as total_sales
from walmart_sales_data
group by product_line
order by total_sales desc
limit 1;

-- What is the total revenue by month?
select distinct month_name
from walmart_sales_data;


select month_name, sum(unit_price * quantity) as Revenue
from walmart_sales_data
group by month_name
order by revenue desc;


-- What month had the largest COGS?

select month_name, sum(cogs)
from walmart_sales_data
group by month_name
order by sum(cogs) desc;

-- What product line had the largest revenue?

select product_line , sum(unit_price * quantity) as revenue
from walmart_sales_data
group by product_line
order by revenue desc
limit 1;

-- What is the city with the largest revenue?

select city , sum(unit_price * quantity) as revenue
from walmart_sales_data
group by city
order by revenue desc;

-- What product line had the largest VAT?

select product_line, tax_pct
from walmart_sales_data
order by tax_pct desc
limit 1;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

Alter table walmart_sales_data
add column Total_sales float;

update walmart_sales_data
set total_sales = unit_price * quantity;

select product_line, (case when sum(total_sales) > (select avg(unit_price * quantity) as Avg_sales
from walmart_sales_data) then 'Good'
else 'Bad'
end
) as Comment
from walmart_sales_data
group by product_line;


-- Which branch sold more products than average product sold?

select branch, avg(total_sales)
from walmart_sales_data
group by branch
having sum(total_sales) > (select avg(total_sales) from walmart_sales_data)
order by avg(total_sales) desc;

-- What is the most common product line by gender?

select gender, product_line, count(gender)
from walmart_sales_data
group by gender,product_line;

-- What is the average rating of each product line?

SELECT product_line, round(avg(rating),2)  as Avg_rating
FROM walmart_sales_data
group by product_line;

-- Number of sales made in each time of the day per weekday


-- Which of the customer types brings the most revenue?

select customer_type, round(sum(total_sales), 2) as Total_revenue
from walmart_sales_data
group by customer_type
order by Total_revenue desc;


-- Which city has the largest tax percent/ VAT (Value Added Tax)?

select city, max(tax_pct)
from walmart_sales_data
group by city;

select max(tax_pct)
from walmart_sales_data;


-- Which customer type pays the most in VAT?

SELECT customer_type, avg(tax_pct)
from walmart_sales_data
group by customer_type;


-- How many unique customer types does the data have?

select count(distinct customer_type) as Unique_customer
from walmart_sales_data;

-- How many unique payment methods does the data have?

select distinct Payment
from walmart_sales_data;

-- What is the most common customer type?

select customer_type, count(customer_type) AS Count_customer
from walmart_sales_data
group by customer_type
order by Count_customer desc;

-- Which customer type buys the most in terms of Purchase quantity and Revenue

select customer_type, sum(quantity) as Customer_Quantity
from walmart_sales_data
group by customer_type
order by customer_quantity desc;

select customer_type, round(sum(Total_sales), 2) as Customer_revenue
from walmart_sales_data
group by customer_type
order by customer_revenue desc;

-- What is the gender of most of the customers?

select gender , count(gender)
from walmart_sales_data
group by gender
order by count(gender) desc;

-- What is the gender distribution per branch?

select Branch, gender, count(Gender) as gender_distribution
from walmart_sales_data
group by branch, gender
order by branch;

-- Which time of the day do customers give most ratings?

Select time_of_the_date , round(avg(rating), 3) as Avg_rating
from walmart_sales_data
group by time_of_the_date
order by avg_rating desc;

-- Which time of the day do customers give most ratings per branch?

Select branch, time_of_the_date , round(avg(rating), 3) as Avg_rating
from walmart_sales_data
group by branch, time_of_the_date
order by branch;


-- Which day fo the week has the best avg ratings?

select order_day, round(avg(rating), 2) as Avg_rating
from walmart_sales_data
group by Order_day
order by avg_rating desc
limit 1;

-- Which day of the week has the best average ratings per branch?

select branch ,order_day, round(avg(rating), 2) as Avg_rating
from walmart_sales_data
group by branch, order_day
order by avg_rating desc
limit 3;





