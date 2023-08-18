--------------- Query Statements ---------------

--------------- Customer information queries ---------------

--List of customers of a specific reward level
/* Goal: Pull up the list of customers, their emails, and their reward level. This is for a manager or an owner. 
This is important because this will give the names of people, conveniently grouped by their rewards level, and a way of 
contacting them. Their interests also become easily readable. This is key for building personal relationships and 
getting good customers to feel a part of the community. 
The below query can be filtered by reward level -- in this case, i have it set so only people level 2
and above show up -- and filtered by interests. I commented out the code to filter by interest in clothes but it is easy to 
add back in, or change to any other interest as well. */
SELECT cs.cust_name, c.cust_email, cs.rwd_level, interests_text(ci.cust_id) as interests
FROM customer_summary AS cs JOIN customers AS c USING (cust_id)  
LEFT JOIN cust_interests AS ci USING (cust_id)
WHERE rwd_level > 1 --AND clothes_yn;
ORDER BY rwd_level DESC;

--days since last transaction for each customer
/*Goal: Pull up list of customers with their days since their last transaction.*/
SELECT c.cust_id, 
	concat(c.first_name, ' ', c.last_name) AS cust_name, 
	now()::date - max(t.trans_date)::date AS days_since_last_trans
FROM transactions as t JOIN customers as c USING (cust_id)
GROUP BY c.cust_id, cust_name
ORDER BY days_since_last_trans DESC, cust_id;


--List of customers that haven't made a purchase in last 300 days
/*Goal: Get list of customers that haven't made a purchase in x days, in this case 300. 
This builds off the query above in a CTE, then uses IN to filter customers table. 
This is valuable because the company can target special marketing towards these people
in hopes of them returning to make more purchases in the future. */
WITH days_since_purchase AS (
	SELECT c.cust_id, 
		concat(c.first_name, ' ', c.last_name) AS cust_name, 
		now()::date - max(t.trans_date)::date AS days_since_last_trans
	FROM transactions as t JOIN customers as c USING (cust_id)
	GROUP BY c.cust_id, cust_name
	ORDER BY days_since_last_trans DESC, cust_id
)

SELECT cust_id, first_name, last_name, cust_phone, cust_email FROM customers
WHERE cust_id IN (
	SELECT cust_id from days_since_purchase
	WHERE days_since_last_trans > 300
)
ORDER BY cust_id; 


--Customer historical records by year for customer 2
/*Goal: Look at a specific customer's records by year. 
In this case, we pull up the records for customer 2, and can see how her purchases and points in 2022 
compare to 2023. Note that this only works if cust_rewards_hist has been updated via the procedure to get
the historical records. */
SELECT h.cust_id, 
	concat(c.first_name, ' ', c.last_name) AS cust_name,
	h.year, 
	h.total_for_year,
	h.pts_acc_for_year, 
	h.pts_red_for_year,
	(h.pts_acc_for_year - h.pts_red_for_year) AS net_pts,
	h.rwd_level_for_year
FROM cust_rewards_hist AS h
JOIN customers AS c USING (cust_id)
WHERE cust_id = 2;



--------------- Employee Information Query Statements ---------------

--List of customer names for a specific sales employee 3
/*Goal: Pull up list of customer names for a specific sales person. 
We specify which employee we want to look at, in this case Maura Caivano, emp_id = 3. 
This is useful for the sales person to know the names of their best customers and maintain connections. 
The employee in question could easily be changed by changing the emp_id in the WHERE statement. */
SELECT DISTINCT emp_cust_join.cust_name, emp_cust_join.cust_email, emp_cust_join.cust_phone
FROM(
	SELECT t.emp_id, t.cust_id, concat(c.first_name, ' ', c.last_name) AS cust_name, c.cust_email, c.cust_phone
	FROM transactions AS t JOIN customers AS c USING (cust_id)
	UNION 
	SELECT ci.emp_id, ci.cust_id, concat(c.first_name, ' ', c.last_name) AS cust_name, c.cust_email, c.cust_phone
	FROM cust_interests AS ci JOIN customers as c USING (cust_id)
) AS emp_cust_join
WHERE emp_id = 3;

--NOTE: The next three queries are related concepts
-- All transactions that occurred in July 2023
/* Goal: pull up all transactions in a specified month and year. Day could also be specified (not shown). 
We use the trans_full view so that we can get all the info for the transactions.*/
SELECT * 
FROM trans_full
where DATE_PART('month', trans_date) = 7 AND DATE_PART('year', trans_date) = 2023 -- july, 2023
ORDER BY trans_date;
-- Summary of sales for each employee in August 2023
/* Goal: Summarize sales for each employee for a specified month and year. 
This is helpful because we can see employee sales for the month. */
SELECT emp_id, 
	concat(e.first_name, ' ', e.last_name) AS emp_name, 
	SUM(trans_amt) AS total_sales
FROM transactions AS t 
JOIN employee AS e USING (emp_id)
WHERE DATE_PART('month', trans_date) = 8 AND DATE_PART('year', trans_date) = 2023 --august, 2023
GROUP BY emp_id, emp_name
ORDER BY emp_id;
--Summary of sales for each employee today. 
/* Goal: used to show sales for an employee today. This can be used to see how an employee is 
meeting sales goals for the current day. */
SELECT emp_id, concat(e.first_name, ' ', e.last_name) AS emp_name, 
	SUM(trans_amt) FROM transactions AS t JOIN employee AS e USING (emp_id)
WHERE trans_date::date =  now()::date
GROUP BY emp_id, emp_name;


-- Sales summary by year for each employee
/* Goal: This is a sales summary by year for each employee. 
As opposed to a specified date range, this is by month.
This is helpful for a manager to see how all sales people are in relation to one another and year by year. */
SELECT  DATE_PART('year', t.trans_date) as year,
	e.emp_id, 
	concat(e.first_name, ' ', e.last_name) as emp_name,  
	COUNT(trans_amt) as num_of_trans, 
	SUM(trans_amt) as amt_sold, 
	AVG(trans_amt::numeric)::money as avg_sold_per_trans
FROM transactions AS t JOIN employee AS e USING (emp_id)
GROUP BY e.emp_id, emp_name, year
ORDER BY year, emp_id;




--------------- Sales Summary Statements ---------------

--Sales summary by year for whole store
/* Goal: Sales summary by year. 
This includes the total number of transactions, the total sales, the total points, the total redeemed, 
and the value of those points for the whole store for the whole year. Also, it shows the average bonus 
multiplied used on transactions. This is a good reflection of the store as a whole. */
SELECT DATE_PART('year', trans_date) AS year,
	COUNT(*) AS total_transactions, 
	SUM(trans_amt) AS total_sales,
	AVG(trans_amt::numeric)::money AS avg_per_sale,
	SUM(pts_trans) AS total_pts,
	SUM(pts_redeemed) AS total_red,
	SUM(pts_net) AS total_net,
	(3 * SUM(pts_net)::numeric / 100)::money AS value_net, 
	ROUND(AVG(pt_mult_bonus),2) AS avg_bonus_mult
FROM trans_full
GROUP BY year;


--Sales summary by year averaged over customer
/* Goal: This is a summary of how customers shopped for each year. For example, we can see the number of 
unique customers, the average sales for the year by customers (that is, the average customers spent for the year),
the average points accumulated by customer, the median and mode reward level for customers, and the average
base point multiplier for all customers. 
This gives more insight into the average customer. 
Further, it combines current data with data from past years to get both an up to date reflection for the current year
and a view into the past years. */
WITH cust_by_year AS(
	SELECT cust_id, 
	DATE_PART('year', trans_date) AS year, 
	SUM(pts_trans) AS pts_for_year 
	FROM trans_pts
	GROUP BY year, cust_id 
)

SELECT c.year, 
	COUNT(c.cust_id) AS num_cust_unique, 
	ROUND(AVG(r.total_current_year::numeric), 2)::money AS avg_sales_year_by_cust,
	ROUND(AVG(c.pts_for_year),2) AS avg_points_acc_by_cust, 
	PERCENTILE_DISC(0.5)
		WITHIN GROUP (ORDER BY r.rwd_level) AS median_rwd_lvl,
	MODE()
		WITHIN GROUP (ORDER BY r.rwd_level) AS mode_rwd_lvl, 
	ROUND(AVG(l.pt_mult_base),2) as avg_base_mult
FROM cust_by_year AS c 
JOIN cust_rewards AS r USING (cust_id) 
JOIN reward_level as l USING (rwd_level)
WHERE c.year = DATE_PART('year', now())
GROUP BY c.year
UNION
SELECT year,
	COUNT(c.cust_id) AS num_cust_unique, 
	ROUND(AVG(c.total_for_year::numeric), 2)::money AS avg_sales_year_by_cust,
	ROUND(AVG(c.pts_acc_for_year),2) AS avg_points_acc_by_cust, 
	PERCENTILE_DISC(0.5)
		WITHIN GROUP (ORDER BY c.rwd_level_for_year) AS median_rwd_lvl,
	MODE()
		WITHIN GROUP (ORDER BY c.rwd_level_for_year) AS mode_rwd_lvl, 
	ROUND(AVG(l.pt_mult_base),2) AS avg_base_mult
FROM cust_rewards_hist AS c 
JOIN reward_level AS l 
	ON c.rwd_level_for_year = l.rwd_level
WHERE year != DATE_PART('year', now())
GROUP BY year
ORDER BY year;


--Count and total sales by month
/* Goal: look at patterns in number of transactions and average transaction amount for each month. 
This is helpful for looking at patterns. It will be more helpful when the database has been running for 
a while, but right now, we can at least see an example of how it may look. It can also easily be filtered
by year, to only look at trends for a specific year (this is commented out for the example). */
WITH trans_month AS (
	SELECT *, 
		CASE WHEN DATE_PART('month', trans_date) = 1 THEN 'Jan'
			WHEN DATE_PART('month', trans_date) = 2 THEN 'Feb'
			WHEN DATE_PART('month', trans_date) = 3 THEN 'Mar'
			WHEN DATE_PART('month', trans_date) = 4 THEN 'Apr'
			WHEN DATE_PART('month', trans_date) = 5 THEN 'May'
			WHEN DATE_PART('month', trans_date) = 6 THEN 'Jun'
			WHEN DATE_PART('month', trans_date) = 7 THEN 'Jul'
			WHEN DATE_PART('month', trans_date) = 8 THEN 'Aug'
			WHEN DATE_PART('month', trans_date) = 9 THEN 'Sep'
			WHEN DATE_PART('month', trans_date) = 10 THEN 'Oct'
			WHEN DATE_PART('month', trans_date) = 11 THEN 'Nov'
			ELSE 'Dec' END AS month,
		DATE_PART('year', trans_date) AS year
	FROM transactions
)

SELECT month, COUNT(*) AS trans_count, ROUND(AVG(trans_amt::numeric),2) AS avg_trans_amt 
FROM trans_month
--WHERE year = 2022
GROUP BY month
ORDER BY trans_count DESC;


