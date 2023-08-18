--------------- Create Tables ---------------

/* Tables are created below. All the constraints (primary and foreign keys, defaults, and unique 
constraints) are added in the initial table creation statements. Note that constraints on the 
transactions, such as ensuring more points aren't redeemed than on customer account, are made 
within the application code itself. */

CREATE TABLE customers(
	cust_id bigserial CONSTRAINT cust_pk PRIMARY KEY, 
	first_name varchar(25), 
	last_name varchar(50), 
	cust_phone char(10), 
	cust_email varchar(50), 
	cust_address varchar(200), 
	deleted bool DEFAULT FALSE,
	CONSTRAINT phone_unique UNIQUE (cust_phone)
);

CREATE TABLE employee(
	emp_id bigserial CONSTRAINT emp_pk PRIMARY KEY,
	first_name varchar(25), 
	last_name varchar(25),
	emp_phone char(10),
	emp_email varchar(50), 
	emp_address varchar(200),
	hourly_rate money DEFAULT 17.00, 
	current_emp bool DEFAULT TRUE
);

CREATE TABLE cust_interests(
	cust_id bigint REFERENCES customers(cust_id) ON DELETE CASCADE,
	emp_id bigint REFERENCES employee(emp_id),
	clothes_yn bool, 
	jewelry_yn bool, 
	home_yn bool,
	CONSTRAINT interests_pk PRIMARY KEY (cust_id)
);

CREATE TABLE transactions(
	trans_id bigserial CONSTRAINT trans_pk PRIMARY KEY, 
	emp_id bigserial REFERENCES employee(emp_id),
	cust_id bigserial REFERENCES customers(cust_id), 
	trans_date timestamp DEFAULT now(),
	trans_amt money, 
	pts_redeemed int DEFAULT 0, 
	pt_mult_bonus numeric(3, 1) DEFAULT 1.0
);

CREATE TABLE trans_pts(
	trans_id bigserial REFERENCES transactions(trans_id) ON DELETE CASCADE,
	cust_id bigserial REFERENCES customers(cust_id), 
	trans_date timestamp, 
	pts_trans int, 
	pts_net int,
	CONSTRAINT trans_pt_pk PRIMARY KEY (trans_id)
);

CREATE TABLE redeemed_hist(
	trans_id bigserial REFERENCES transactions(trans_id) ON DELETE CASCADE,
	cust_id bigserial REFERENCES customers(cust_id),
	trans_date timestamp, 
	pts_redeemed int, 
	discount money,
	CONSTRAINT red_hist_pk PRIMARY KEY (trans_id)
);

CREATE TABLE cust_pts(
	cust_id bigserial REFERENCES customers(cust_id) ON DELETE CASCADE, 
	pts_total int, 
	pts_redeemed_total int, 
	pts_remaining int, 
	pts_redeemable int DEFAULT 100, --bc start with 100 bonus pts
	CONSTRAINT cust_pts_pk PRIMARY KEY (cust_id)
);

CREATE TABLE reward_level(
	rwd_level smallint CONSTRAINT rwd_pk PRIMARY KEY,
	total_current_year money, 
	pt_mult_base numeric(3,1)
);

CREATE TABLE cust_rewards(
	cust_id bigserial REFERENCES customers(cust_id) ON DELETE CASCADE, 
	total_current_year money DEFAULT 0, 
	rwd_level smallint REFERENCES reward_level(rwd_level) DEFAULT 1,
	CONSTRAINT cust_rwd_pk PRIMARY KEY (cust_id)
);

CREATE TABLE cust_rewards_hist( 
	cust_id bigserial REFERENCES customers(cust_id),
	year smallint, 
	total_for_year money, 
	pts_acc_for_year int, 
	pts_red_for_year int,
	rwd_level_for_year int, 
	CONSTRAINT cust_rwd_hist_pk PRIMARY KEY (cust_id, year)
);


--DROP ALL TABLES: used for resetting the database when needed in testing. 
--DROP TABLE employee, customers, transactions, cust_interests, cust_pts, cust_rewards, cust_rewards_hist, redeemed_hist, reward_level, trans_pts CASCADE;
