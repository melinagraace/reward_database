# Rewards Database for Small Business
DTSC 691 Project Submission <br>
Melina Wettstein

## Setting up the database
To set up the database on your computer, first create a new database. In this case, I called mine `rewards_database`. Then, run the sql code files in the following order: <br>
    Note: all code should run fully without errors. <br>
1. create_tables.sql <br>
2. functions.sql <br>
    Note: the example function calls are commented out because they will not work until information is actually added to the database.  <br>
3. triggers.sql <br>
4. insert_data.sql <br>
    Note: There are example insert statements for only 4 of the 10 tables because the remaining tables are autofilled via the triggers set up in step 3. The code for filling these tables is still present but commented out. <br>
5. view.sql <br>
6. Now, the optional code can be run, like the update and delete statements in update_delete.sql and the example queries in queries.sql. Note that some queries require the procedure in functions.sql to be run. For this, uncomment the code after adding all data to the database. The database is also ready to run via the flask application, which can be run following the steps below. 

## Setting up to run the application
### Setting up the virtual environment (if needed)
1. Go to directory for project (your file pathway here):<br> `cd /Users/melinawettstein/Desktop/final_project/app` 
2. Make virtual environment: `python3 -m venv venv`
3. Activate the virtual environment (code for mac): ` . venv/bin/activate`
4. Install necessary packages with pip install: <br>
`pip install psycopg2 flask flask-sqlalchemy`<br>
    <b>NOTE:</b> if issue with installing psycopg2 due to pg_config not being found:
    1. Add the file that contains pg_config to the path: `export PATH=$PATH:/Library/PostgreSQL/15/bin`
    2. Finally, install psycopg2: `pip install psycopg2`

### Load the virtual environment if it is already set up
`cd /Users/melinawettstein/Desktop/final_project/app` (your file path here) <br>
`. venv/bin/activate`

### Run the application: once in virtual environment and app folder
`flask run`

## File structure
readme.md <br>
<b>folder:</b> sql_code <br>
&emsp;&emsp; create_tables.sql <br>
&emsp;&emsp; functions.sql <br>
&emsp;&emsp; insert_data.sql <br>
&emsp;&emsp; queries.sql <br>
&emsp;&emsp; triggers.sql <br>
&emsp;&emsp; update_delete.sql <br>
&emsp;&emsp; view.sql <br>
<b>folder:</b> app <br>
&emsp;&emsp; app.py <br>
&emsp;&emsp; <b>folder:</b> static <br>
&emsp;&emsp;&emsp;&emsp; <b>folder:</b> css <br>
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; main.css <br>
&emsp;&emsp; <b>folder:</b> templates <br>
&emsp;&emsp;&emsp;&emsp; base.html <br>
&emsp;&emsp;&emsp;&emsp; error.html <br>
&emsp;&emsp;&emsp;&emsp; first_page.html <br>
&emsp;&emsp;&emsp;&emsp; new_cust.html <br>
&emsp;&emsp;&emsp;&emsp; success.html <br>
&emsp;&emsp;&emsp;&emsp; transaction.html <br>

## Code references
While the code written was all specific to this project, to initially learn flask, my code was started from a base of other people's code. Nothing in the code is entirely unedited, but I wanted to ensure proper credit for the beginning of the code. Specifically, the initial app.py file was started with code from Lumary on Youtube, as was the form in new_cust.html. The integration with an existing database in app.py was learned from Pretty Printed on Youtube. Finally, the html structure, specifically the code for base.html, was from FreeCodeCamp.org on Youtube. These are in the *References: For code* section of the final project submission document. 

