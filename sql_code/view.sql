--------------- View Statements ---------------
/* View goal: for the customer, show their rewards level and their redeemable points. 
It also shows their base point multiplier. */ 
CREATE OR REPLACE VIEW customer_summary AS 
SELECT c.cust_id, 
	concat(c.first_name, ' ', c.last_name) as cust_name, 
	rwd.rwd_level, 
	lev.pt_mult_base, 
	pts.pts_redeemable, 
	(3 * pts.pts_redeemable::numeric/100)::money as pt_value
FROM customers as c 
JOIN cust_pts as pts using (cust_id) 
JOIN cust_rewards as rwd using (cust_id)
LEFT JOIN reward_level as lev using (rwd_level)
ORDER BY cust_id; 

SELECT * FROM customer_summary;

/* View goal: for the management team, combines the transaction and trans_pts table so that
transactions and points for the transactions can be views in same query. */
CREATE OR REPLACE VIEW trans_full AS
SELECT t.trans_id, t.emp_id, t.cust_id, t.trans_date, t.trans_amt, t.pt_mult_bonus, 
	p.pts_trans, t.pts_redeemed, p.pts_net 
FROM transactions AS t JOIN trans_pts AS p USING (trans_id)
ORDER BY trans_id;

SELECT * FROM trans_full;
