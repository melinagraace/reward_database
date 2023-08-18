--------------- Trigger Functions ---------------
/* The goal of these trigger functions is to update all tables that are based on values being inserted
into transactions and customers. That is, as you see below, several tables are based on calculations
rather than purely inserting data. This ensures that all those tables update automatically instead of 
needing to be manually updated. */


--Add a customer ID to cust_pts and cust_rewards tables on new customer being added to customers table
CREATE OR REPLACE FUNCTION
add_cust()
RETURNS trigger AS
$$
BEGIN
INSERT INTO cust_pts (cust_id)
VALUES (NEW.cust_id);
INSERT INTO cust_rewards (cust_id)
VALUES (NEW.cust_id);
RETURN NEW;
END;
$$
LANGUAGE plpgsql;

--Add new row to trans_pts based on amount and customer info from new row of transactions table
CREATE OR REPLACE FUNCTION
trans_pts_update()
RETURNS trigger AS
$$
BEGIN
INSERT INTO trans_pts
VALUES (NEW.trans_id, 
		NEW.cust_id, 
		NEW.trans_date, 
		(NEW.trans_amt * NEW.pt_mult_bonus * pt_base_calc(NEW.cust_id))::numeric::int,
		(NEW.trans_amt * NEW.pt_mult_bonus * pt_base_calc(NEW.cust_id))::numeric::int - NEW.pts_redeemed);
RETURN NEW;
END;
$$
LANGUAGE plpgsql;

--Adds transaction information to redeemed_hist table if a transaction that redeems points is added to transactions table
CREATE OR REPLACE FUNCTION
redeemed_hist_update()
RETURNS trigger AS 
$$
BEGIN
IF NEW.pts_redeemed > 0 THEN
INSERT INTO redeemed_hist
VALUES (NEW.trans_id, NEW.cust_id, NEW.trans_date, NEW.pts_redeemed, 3 * NEW.pts_redeemed / 100);
END IF;
RETURN NEW;
END;
$$
LANGUAGE plpgsql;

--Updates the pts_redeemed_total column of cust_pts for the appropriate customer id when a transaction is added to transactions table
CREATE OR REPLACE FUNCTION 
cust_pts_update1()
RETURNS trigger AS
$$
BEGIN
UPDATE cust_pts
SET pts_redeemed_total = (SELECT SUM(pts_redeemed) FROM transactions WHERE cust_id = NEW.cust_id GROUP BY cust_id)
WHERE cust_id = NEW.cust_id;
RETURN NEW;
END;
$$
LANGUAGE plpgsql;


--Update all other columns of cust_pts for the appropriate customer id when a transaction is added to trans_pts table
CREATE OR REPLACE FUNCTION 
cust_pts_update2()
RETURNS trigger AS
$$
BEGIN
UPDATE cust_pts
SET pts_total = (SELECT SUM(pts_trans)+100 FROM trans_pts WHERE cust_id = NEW.cust_id GROUP BY cust_id),
	pts_remaining = (SELECT SUM(pts_net)+100 FROM trans_pts WHERE cust_id = NEW.cust_id GROUP BY cust_id)
WHERE cust_id = NEW.cust_id;
UPDATE cust_pts
SET pts_redeemable = redeemable_points(pts_remaining)
WHERE cust_id = NEW.cust_id;
RETURN NEW;
END;
$$
LANGUAGE plpgsql;

--Update columns of cust_rewards for the appropriate customer id when a transaction is added to the transaction table
CREATE OR REPLACE FUNCTION
cust_rewards_update()
RETURNS trigger AS
$$
BEGIN
UPDATE cust_rewards
SET total_current_year = (SELECT SUM(trans_amt) 
						  FROM transactions 
						  WHERE cust_id = NEW.cust_id AND date_part('year', trans_date) = date_part('year', now())
						  GROUP BY cust_id)
WHERE cust_id = NEW.cust_id; 
UPDATE cust_rewards
SET rwd_level = reward_fun(NEW.cust_id)
WHERE cust_id = NEW.cust_id;
RETURN NEW;
END;
$$
LANGUAGE plpgsql;



--------------- Create Triggers ---------------

--Trigger on customer table insert
CREATE TRIGGER cust_add_trigger
AFTER INSERT 
ON customers
FOR EACH ROW 
EXECUTE PROCEDURE add_cust();

--Triggers on transactions table insert
CREATE TRIGGER trans_pts_trigger
AFTER INSERT
ON transactions
FOR EACH ROW
EXECUTE PROCEDURE trans_pts_update();

CREATE TRIGGER redeemed_hist_trigger
AFTER INSERT
ON transactions
FOR EACH ROW
EXECUTE PROCEDURE redeemed_hist_update();

CREATE TRIGGER cust_pts_trigger1
AFTER INSERT
ON transactions
FOR EACH ROW
EXECUTE PROCEDURE cust_pts_update1();

CREATE TRIGGER cust_rewards_trigger
AFTER INSERT
ON transactions
FOR EACH ROW
EXECUTE PROCEDURE cust_rewards_update();

--Trigger on trans_pts table insert
CREATE TRIGGER cust_pts_trigger2
AFTER INSERT
ON trans_pts
FOR EACH ROW
EXECUTE PROCEDURE cust_pts_update2();



