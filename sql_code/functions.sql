--------------- Functions ---------------
/* Goal of function: take in customer id and output their interests in text form. 
This takes the boolean values of the cust_interests table and creates a list that can 
be easily read to know any customers' interests. */ 
CREATE OR REPLACE FUNCTION 
interests_text(id bigint)
RETURNS TABLE (test text) AS
$$
BEGIN 
RETURN QUERY
	SELECT
	CASE WHEN clothes_yn AND jewelry_yn AND home_yn THEN 'all'
		WHEN clothes_yn AND jewelry_yn THEN 'clothes, jewelry'
		WHEN clothes_yn AND home_yn THEN 'clothes, home'
		WHEN jewelry_yn AND home_yn THEN 'jewelry, home'
		WHEN clothes_yn THEN 'clothes'
		WHEN jewelry_yn THEN 'jewelry'
		WHEN home_yn THEN 'home'
		ELSE 'none' END 
	FROM cust_interests
	WHERE cust_id = id;
END; 
$$
LANGUAGE plpgsql;

--Example of function call: find the interests of customer 1
SELECT interests_text(1); 


/* Goal of function: Calculate the redeemable points from the total points. 
Points are only redeemable in 100 point chunks, so this function takes the sum of the points and subtracts the 
remainder to output the function. Though a simple calculation, it is used frequently enough to warrant a function. */
CREATE OR REPLACE FUNCTION
redeemable_points(pts int)
RETURNS int AS
'SELECT pts - MOD(pts, 100);'
LANGUAGE SQL;

--Example: If a customer has 874 points, how many can they actually redeem? 
SELECT redeemable_points(874);


/*Goal of function: take in the customer id, and output what their reward level is based on how much 
they spent in the current year. This uses the rewards table which has the minimum required to spend to be at 
each reward level. For example, if the reward table says $500 for level 2, that means you must spend at least $500 but 
not more than $1000 to be level 2. After spending more than $1000, you are level 3. Thus, the final step of the select 
statement is selecting the max reward level for the customer id. */
CREATE OR REPLACE FUNCTION
reward_fun(id bigint)
RETURNS smallint AS
$$
BEGIN 
RETURN (
	SELECT MAX(r.rwd_level)
	FROM cust_rewards AS c 
	LEFT JOIN reward_level AS r
	ON c.total_current_year >= r.total_current_year
	WHERE cust_id = id 
	GROUP BY cust_id);
END;
$$
LANGUAGE plpgsql;



--Example: what rewards level is customer 2 at? 
SELECT reward_fun(2) as reward_level;

/* Goal of function: similar to above, only for the history table rather than the current rewards table. 
This only takes into account the sales for the year specified rather than the sum of sales for the current 
year (as it does in the previous function). This is specifically for use in the procedure below. */
CREATE OR REPLACE FUNCTION
reward_fun_past(id bigint, year_add int)
RETURNS smallint AS
$$
BEGIN 
RETURN (
	SELECT MAX(r.rwd_level)
	FROM cust_rewards_hist AS c 
	LEFT JOIN reward_level AS r
	ON c.total_for_year >= r.total_current_year
	WHERE cust_id = id AND year = year_add
	GROUP BY cust_id);
END;
$$
LANGUAGE plpgsql;

--Example: what reward level was customer 2 in 2022
SELECT reward_fun_past(2, 2022); 


/* Goal of function: taking in the customer id, output their point multiplier based on their rewards level. 
At higher rewards levels, customers make more points per transaction. However, if they do not have a rewards level for 
some reason, the function automatically assigns 1.0 as the default multiplier. If there are any NULL values or other issues, 
the function should return 1.0 and still work in the other calculations in this database as needed. */
CREATE OR REPLACE FUNCTION
pt_base_calc(id bigint)
returns numeric(3,1) as
$$
BEGIN
RETURN (
	CASE WHEN (
		SELECT pt_mult_base FROM cust_rewards JOIN reward_level USING (rwd_level) WHERE cust_id = id
	) ISNULL THEN 1.0
	ELSE (
		SELECT pt_mult_base FROM cust_rewards JOIN reward_level USING (rwd_level) WHERE cust_id = id
	) END
);
END;
$$
language plpgsql;

--Example: What point multiplier does customer 3 get on every purchase? 
SELECT pt_base_calc(3);

--------------- Procedures ---------------
/* Goal of procedure: fill in the cust_rewards_hist table for the specific year. This table is for historical data, 
giving information for each customer for each year. The utility of this is with the idea that at the end of each year, you 
run this funcion with the year specified, and it will fill in the historical data for that year. Note that this should only
be run at the end of a year because it uses insert statements, so running it again will cause an error in the 
primary key constraint, which is a composite key of cust_id and year. 
For the sake of example, let's pretend we are at the end of year. This is how we would call the procedure 
to add new values to the table.*/
CREATE OR REPLACE PROCEDURE 
cust_rewards_hist_update(year_add int)
AS 
$$
BEGIN 
INSERT INTO cust_rewards_hist
SELECT t.cust_id, DATE_PART('year', t.trans_date), SUM(t.trans_amt), SUM(pts.pts_trans), SUM(t.pts_redeemed)
FROM transactions AS t JOIN trans_pts AS pts USING (trans_id)
WHERE DATE_PART('year', t.trans_date) = year_add
GROUP BY t.cust_id, DATE_PART('year', t.trans_date);
UPDATE cust_rewards_hist
SET rwd_level_for_year = reward_fun_past(cust_id, year);
END;
$$
LANGUAGE plpgsql;

--Example: Fills in cust_rewards_hist for 2022 and 2023. Note that in the real implementation, 2023 should only be called at the end of year, since the procedure inserts rows rather than updates them. 
--NOTE: uncomment below lines to full cust_rewards_hist, for the queries that require it. 

--CALL cust_rewards_hist_update(2022);
--CALL cust_rewards_hist_update(2023);
--SELECT * FROM cust_rewards_hist;


