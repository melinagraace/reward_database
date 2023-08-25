# Rewards Database for Small Business
DTSC 691 Capstone <br>
Eastern University <br>
August 2023 <br>
Melina Wettstein <br>


## Goals of project
The business in this project is a small business selling clothes, jewelry, and home goods at a mid-to-high price points. They would like a rewards database to increase sales to repeat customers while building community. 
The goal of this project is to create a database with an interactive system that allows
input of customer information, tracking purchases, and most importantly, tracking their
rewards through points, to help increase customer loyalty and retention, and allow for
more targeted customer emails and personalized connection. The steps needed to
complete this are as follows:
- Formulate a rewards program recommendation for a small business with a
mid-to-high sales point
- Create a functioning relational database in PostgreSQL for easy customer look-up
and rewards redemption.
- Create an application via Flask to connect the SQL database to Python, for
employees to interact with the database, as described in Physical Requirements.
- Create a series of queries in SQL to allow the management team to target highly
loyal customers for sending emails and other promotions, to track employee sales,
and to determine sales of the store as a whole.

Note: There is a video explaining this project, SQL code, and python code found [here](https://youtu.be/IdvG19sGWjM). 

## Rewards program framework
There are three important elements to a successful rewards database, and all three motivate customers to return and build brand loyalty. First, the points must have percieved value, often this is done through points being directly redeemable for cash. Second, there should be an easily implemented coupon program that offers more incentive to return to the store. Finally, the rewards program should stretch beyond just the value of points, and insentivise return visits via building community. This involves offering special, non-monatary bonuses to top customers. An example of this is early-access to new products. 

The rewards program is based on points, where every dollar earns a base 1 point, with the more you spend correlating to more points per dollar. The rewards program has levels and each level has a threshold value you must spend in the year to be at that level. For example, at level 1, you earn 1 point per dollar immediately. At level 2, which you earn after spending $500, you begin earning 1.1 points per dollar. This increases up to 3 points per dollar. Each 100 points will be worth $3 and can be applied to any purchase of an amount greater than the value of points redeemed. Further, we are adding a constraint that points may only be redeemed in multiples of 100. This is common for this type of point-base program. 

We are also implementing a method to offer coupons in the form of additional bonus point multipliers. This may be offered for every in store purchase on specific days, or may be sent out via emails to specific customers. An example of this may say, "Come in this week and enjoy a bonus 5x points on every purchase." 

Finally, building a community beyond points. While this is more marketing, the SQL code included here includes several queries that may assist in management deciding who to send specialized emails to. This may be for special deals, but also for running special events showcasing new products or early-access. Part of this database includes requiring people to express their interests when signing up for the rewards program. This allows for personalized events and email promotions tailored to their interests. 

## Software
PostgreSQL <br>
Python:
#### Packages
    from flask import Flask, render_template, request, session, url_for
    from flask_sqlalchemy import SQLAlchemy
    from sqlalchemy.ext.automap import automap_base


## Setting up the database
To set up the database on your computer, first create a new database. In this case, I called mine `rewards_database`. Then, run the PostgreSQL code files in the following order: <br>
1. create_tables.sql <br>
2. functions.sql <br>
    Note: the example function calls are commented out because they will not work until information is actually added to the database. This is espically important for the procedure call at the bottom of this document.  <br>
3. triggers.sql <br>
4. insert_data.sql <br>
    Note: There are example insert statements for only 5 of the 10 tables because the remaining tables are autofilled via the triggers set up in step 3. The code for filling these tables is still present but commented out. Further, note that the only tables required to have data inserted prior to running the application are the employee table and the rewards_level table. The other insert statements are for illustration purposes only. <br>
5. view.sql <br>
6. Now, the optional code can be run, like the update and delete statements in update_delete.sql and the example queries in queries.sql. Note that some queries require the procedure in functions.sql to be run. For this, uncomment the code after adding all data to the database. The database is also ready to run via the flask application, which can be run following the steps below. 

## Setting up to run the application
### Setting up the virtual environment (if needed)
1. Go to the directory containing project files
2. Make virtual environment: `python3 -m venv venv`
3. Activate the virtual environment (code for mac): ` . venv/bin/activate`
4. Install necessary packages with pip install: <br>
`pip install psycopg2 flask flask-sqlalchemy`<br>
    <b>NOTE:</b> if issue with installing psycopg2 due to pg_config not being found:
    1. Add the file that contains pg_config to the path: `export PATH=$PATH:/Library/PostgreSQL/15/bin`
    2. Finally, install psycopg2: `pip install psycopg2`

### Load the virtual environment if it is already set up
1. Navigate to the directory containing the project and virtual environment. 
2. Activate the virtual environment:  `. venv/bin/activate`

### Run the application: 
`flask run`

## File structure
readme.md <br>
app.py <br>
<b>folder:</b> sql_code <br>
&emsp;&emsp; create_tables.sql <br>
&emsp;&emsp; functions.sql <br>
&emsp;&emsp; insert_data.sql <br>
&emsp;&emsp; queries.sql <br>
&emsp;&emsp; triggers.sql <br>
&emsp;&emsp; update_delete.sql <br>
&emsp;&emsp; view.sql <br>
 <b>folder:</b> static <br>
&emsp;&emsp; <b>folder:</b> css <br>
&emsp;&emsp;&emsp;&emsp; main.css <br>
<b>folder:</b> templates <br>
&emsp;&emsp; base.html <br>
&emsp;&emsp; error.html <br>
&emsp;&emsp; first_page.html <br>
&emsp;&emsp; new_cust.html <br>
&emsp;&emsp; success.html <br>
&emsp;&emsp; transaction.html <br>


