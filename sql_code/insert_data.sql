--------------- Insert Statements ---------------

--NOTE: Run triggers first, to ensure the tables autofill as needed. 

--6 example insert values into reward_level (could be adjusted as needed by business requirements)
INSERT INTO reward_level VALUES (1, 0, 1.0);
INSERT INTO reward_level VALUES (2, 500, 1.1);
INSERT INTO reward_level VALUES (3, 1000, 1.3);
INSERT INTO reward_level VALUES (4, 1500, 1.5);
INSERT INTO reward_level VALUES (5, 2000, 2);
INSERT INTO reward_level VALUES (6, 3000, 2.5);
INSERT INTO reward_level VALUES (7, 4000, 3);


--5 example employee insert statements. Note that hourly_rate and current_emp have default values and need not be defined here
INSERT INTO employee (first_name, last_name, emp_phone, emp_email, emp_address)
VALUES ('Blaire', 'Lamarre', '9884471233', 'blaire_lamarre@gmail.com', '23rd average street');
INSERT INTO employee (first_name, last_name, emp_phone, emp_email, emp_address)
VALUES ('Anton', 'Machon', '3058395318', 'antonboy123@gmail.com', '4265 15th ave NE');
INSERT INTO employee (first_name, last_name, emp_phone, emp_email, emp_address)
VALUES('Maura', 'Caivano', '9302762727', 'maurabear1996@yahoo.com', '5656 Bellevue Way SE');
INSERT INTO employee (first_name, last_name, emp_phone, emp_email, emp_address)
VALUES('Hervey', 'Fausti', '7693784037', 'fausti.hervey@gamil.com', '28394 29th ave W');
INSERT INTO employee (first_name, last_name, emp_phone, emp_email, emp_address)
VALUES('Jamey', 'Bellincioni', '8817390575', 'jamey.bellincioni@outlook.com', '2390 eleventh avenue');

--6 example customers insert statements
INSERT INTO customers (first_name, last_name, cust_phone, cust_email, cust_address)
VALUES ('Serafino', 'Acciai', '9254991149', 'carebearlover145@gmail.com', '9823 50th street');
INSERT INTO customers (first_name, last_name, cust_phone, cust_email, cust_address)
VALUES ('Miranda', 'Bell', '3605271191', 'miranda_bell@gamil.com', '2034 ABC ave SE');
INSERT INTO customers (first_name, last_name, cust_phone, cust_email, cust_address)
VALUES ('Roxy', 'Hawthorne', '6768646803', 'roxyfox1234@gmail.com', '6765 seneca street');
INSERT INTO customers (first_name, last_name, cust_phone, cust_email, cust_address)
VALUES ('Pearl', 'Willis', '4013956177', 'pearlywillis@gmail.com', '4545 cherry street');
INSERT INTO customers (first_name, last_name, cust_phone, cust_email, cust_address)
VALUES ('Max', 'Rogers', '2496948723', 'rogers_max@yahoo.com', '3738 pine ave');
INSERT INTO customers (first_name, last_name, cust_phone, cust_email, cust_address)
VALUES ('Emelio', 'Antonio', '4253890294', 'emelio.antonio@yahoo.com', '6738 278th street');
INSERT INTO customers (first_name, last_name, cust_phone, cust_email, cust_address)
VALUES ('Cheap', 'Sally', '1112223333', 'cheapsally@gamil.com', '123 Free Strees')

--6 example cust_interests insert statements
INSERT INTO cust_interests VALUES (1, 4, TRUE, TRUE, FALSE);
INSERT INTO cust_interests VALUES (2, 4, TRUE, FALSE, FALSE);
INSERT INTO cust_interests VALUES (3, 4, FALSE, FALSE, TRUE);
INSERT INTO cust_interests VALUES (4, 4, TRUE, TRUE, TRUE);
INSERT INTO cust_interests VALUES (5, 3, TRUE, FALSE, FALSE);
INSERT INTO cust_interests VALUES (6, 2, TRUE, FALSE, TRUE);


--6 example transactions insert statements. Note that pts_redeemed has a default value, as does pt_mult_bonus
--2022
INSERT INTO transactions(emp_id, cust_id, trans_date, trans_amt)
VALUES (2, 5, '2022-05-12', 500.99);
INSERT INTO transactions(emp_id, cust_id, trans_date, trans_amt)
VALUES (3, 4, '2022-05-13', 101.00);
INSERT INTO transactions(emp_id, cust_id, trans_date, trans_amt)
VALUES (1, 2, '2022-05-14', 54.75);
INSERT INTO transactions(emp_id, cust_id, trans_date, trans_amt, pt_mult_bonus)
VALUES (1, 5, '2022-05-15', 14.05, 3);
INSERT INTO transactions(emp_id, cust_id, trans_date, trans_amt)
VALUES (1, 1, '2022-05-15', 104.75);
INSERT INTO transactions(emp_id, cust_id, trans_date, trans_amt)
VALUES (3, 6, '2022-05-15', 77.77);
INSERT INTO transactions(emp_id, cust_id, trans_date, trans_amt, pt_mult_bonus)
VALUES (1, 2, '2022-05-14', 203.98, 2);
--2023
INSERT INTO transactions(emp_id, cust_id, trans_date, trans_amt)
VALUES (4, 2, now(), 456.00); --add current transaction using now() to make a transaction at current date/time
INSERT INTO transactions(emp_id, cust_id, trans_date, trans_amt, pt_mult_bonus)
VALUES (4, 1, '2023-06-24 12:14:00', 250.00, 1.2);
INSERT INTO transactions(emp_id, cust_id, trans_date, trans_amt, pt_mult_bonus)
VALUES (4, 3, '2023-06-24 2:08:00', 83.76, 10);
INSERT INTO transactions(emp_id, cust_id, trans_date, trans_amt)
VALUES (3, 3, '2023-07-16 10:58:00', 123.50);
INSERT INTO transactions(emp_id, cust_id, trans_date, trans_amt, pts_redeemed)
VALUES (3, 2, '2023-07-16 11:34:00', 303.78, 500);
INSERT INTO transactions(emp_id, cust_id, trans_date, trans_amt, pts_redeemed) 
VALUES (1, 3, '2023-01-20 10:52:00', 1000, 0);
INSERT INTO transactions(emp_id, cust_id, trans_date, trans_amt)
VALUES (1, 4, '2023-05-13', 95.00);
INSERT INTO transactions(emp_id, cust_id, trans_date, trans_amt, pt_mult_bonus)
VALUES (1, 5, '2023-07-17', 123.45, 2);
INSERT INTO transactions(emp_id, cust_id, trans_date, trans_amt)
VALUES (5, 6, '2023-07-18', 7.00);

/*
--------------- UNUSED Insert Statements ---------------
/*
The remaining tables are autofilled in by triggers, and thus not needed to be filled by insert statements. However, 
the below code was included for the case where the triggers were forgotten to be added to the database.
For the project, they were also included since insert statements are required for all tables. 
Note: the insert statements below are done through queries on other tables since that is what they are based on, 
however if needed, one could manually add data using the VALUES key word rather than a query. This is not shown below
because there is not a logical reason to do the inserts for these tables in that way. 
*/

--Insert values into trans_pts from the transactions
INSERT INTO trans_pts
SELECT trans_id, cust_id, trans_date, 
(trans_amt * pt_mult_bonus * pt_base_calc(cust_id))::numeric::int, 
(trans_amt * pt_mult_bonus * pt_base_calc(cust_id))::numeric::int - pts_redeemed from transactions;

--insert values into redeemed_hist
INSERT INTO redeemed_hist
SELECT trans_date, trans_id, cust_id, pts_redeemed, pts_redeemed / 100 
from transactions
where pts_redeemed > 0;

--insert values into cust_rewards_hist (updated via trigger function)
INSERT INTO cust_rewards_hist
SELECT  t.cust_id, DATE_PART('year', t.trans_date), SUM(t.trans_amt), SUM(pts.pts_trans), SUM(t.pts_redeemed)
FROM transactions AS t JOIN trans_pts AS pts USING (trans_id)
GROUP BY t.cust_id, DATE_PART('year', t.trans_date);

--cust_rewards
INSERT INTO cust_rewards (cust_id, total_current_year)
SELECT cust_id, SUM(trans_amt)
FROM transactions
WHERE  date_part('year', trans_date) = date_part('year', now())
GROUP BY cust_id;
--add values to rwd_level col
UPDATE cust_rewards
SET rwd_level = reward_fun(cust_id)
RETURNING *;

--cust_pts
INSERT INTO cust_pts (cust_id, pts_total, pts_redeemed_total, pts_remaining)
SELECT pts.cust_id, sum(pts.pts_trans), sum(t.pts_redeemed), sum(pts.pts_net)
from trans_pts as pts join transactions as t using (trans_id)
group by pts.cust_id;
--add values to pts_redeemable col
UPDATE cust_pts
SET pts_redeemable = redeemable_points(pts_remaining)
RETURNING *; 
*/