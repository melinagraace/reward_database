########## Imports ##########

from flask import Flask, render_template, request, session, url_for 
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.ext.automap import automap_base



########## APP SET UP ##########

app = Flask(__name__) #create flask object

app.app_context().push() ## added myself when problem solving. 

app.config['SECRET_KEY'] = 'a secret security squirrel'

# For database connection
app.config['SQLALCHEMY_DATABASE_URI']='postgresql://postgres:password@localhost/rewards_database' #creates link to database, where password is the password and rewards_database is the database. 

#create SQLAlchemy object, used to connect to database. 
db = SQLAlchemy(app) 

Base = automap_base()
Base.prepare(db.engine, reflect = True) #connection to database
customers = Base.classes.customers
transactions = Base.classes.transactions
cust_interests = Base.classes.cust_interests

customer_summary = db.Table('customer_summary', db.metadata, autoload_with = db.engine) # Views are done through this method from source 4



########## APP ROUTING ##########

##### Customer lookup #####
@app.route('/') # route to home page
def first_page():
    return render_template('first_page.html') #return this file 

@app.route('/customer', methods = ['post'])
def customer():
      cust_phone = request.form['cust_phone']
      new_cust = db.session.query(customers).filter(customers.cust_phone == cust_phone) 
      for id in new_cust:
          id_save = id.cust_id
          session['cust_id'] = id_save #call this with: session.get('cust_id')
      try: #if an id is found, this will work. 
            cust_summary_save = db.session.query(customer_summary).filter(customer_summary.c.cust_id == id_save)
            for cust in cust_summary_save: 
                  session['pts_avail']=cust[4]
            return render_template('success.html', heading = 'Customer Information', title = 'Customer', cust_sum = cust_summary_save) 
      except: #if no id is found, the above will fail and instead the error page will pop up. 
            return render_template('error.html', location = 'loading customer', cause = "No customer found under", pts_avail = cust_phone, 
                                   rec = "Enter new phone number or create a new customer instead.", cust = True)



##### Add transactions #####
@app.route('/transaction')
def transaction():
      return render_template('transaction.html')

@app.route('/submit_trans', methods =['POST'])
def submit_trans():
      try: 
            # Get info from form 
            emp_id = request.form['emp_id']
            trans_amt = request.form['trans_amt']
            if request.form['pts_redeemed'] == "":
                  pts_redeemed = 0
            else: 
                  pts_redeemed = request.form['pts_redeemed'] 
            if request.form['pt_mult_bonus'] == "":
                  pt_mult_bonus = 1.0
            else: 
                  pt_mult_bonus = request.form['pt_mult_bonus']


            if int(pts_redeemed) > session.get('pts_avail'): 
                  return render_template('error.html', location = 'adding new transaction', cause = 'Cannot redeem more points than on account. Maximum redeemable points:', 
                                         pts_avail = session.get('pts_avail'), rec = 'Redeem less points on transaction page.', trans = True)
            #the below was incorporated by the transaction html code to only allow it to be intervals of 100
            #elif int(pts_redeemed) % 100 != 0: #error because can only redeem points hundreds at a time. 
            #      return render_template('error.html', location = 'adding new transaction', cause = 'Can only redeem points in intervals of 100.')
            elif float(trans_amt) < (3 * float(pts_redeemed) / 100):
                  return render_template('error.html', location = 'adding new transaction', cause = 'Redeemed points must be less than total transaction amount.',
                                         rec = 'Redeem less points on transaction page.', trans = True)
            else:

                  trans_to_add = transactions(emp_id = emp_id, cust_id = session.get('cust_id'), trans_amt = trans_amt, pts_redeemed = pts_redeemed, pt_mult_bonus = pt_mult_bonus)
                  db.session.add(trans_to_add)
                  db.session.commit()

                  cust_summary_save = db.session.query(customer_summary).filter(customer_summary.c.cust_id == session.get('cust_id'))
                  for cust in cust_summary_save: 
                        session['pts_avail']=cust[4]
      
                  return render_template('success.html', heading = 'Customer Information: Updated.', title = 'Updated', cust_sum = cust_summary_save,  trans_success = True) 
      except: 
            return render_template('error.html', location = 'adding new transaction', cause = 'unknown', 
                                   rec = 'Restart transaction checking employee number and other inputs.', trans = True)



##### Add a new customer #####
@app.route('/new_cust')
def new_cust():
      return render_template('new_cust.html') 

@app.route('/submit_cust', methods = ['POST', 'GET']) ## in the html: /submit is the action, method = "POST"; the first_name and last_name below reference 'name = ' in the html
def submit_cust():
      # Get info from form
      emp_id = request.form['emp_id']
      first_name = request.form['first_name']
      last_name = request.form['last_name']
      cust_phone = request.form['cust_phone']
      cust_email = request.form['cust_email']
      cust_address = request.form['cust_address']
      clothes_yn = request.form['clothes']
      jewelry_yn = request.form['jewelry']
      home_yn = request.form['home']


      # Check phone number: SQL will throw an error if the phone number is repeated
      x = db.session.query(customers).filter(customers.cust_phone == cust_phone).first()
      if x != None:
            print('cust already exists')
            id_save = x.cust_id
            session['cust_id'] = id_save
            cust_summary_save = db.session.query(customer_summary).filter(customer_summary.c.cust_id == id_save)
            for cust in cust_summary_save:
                  session['pts_avail']=cust[4]
            return render_template('success.html', heading = 'Customer found.', title = 'Customer', cust_sum = cust_summary_save, 
                                   cust_found = True, cust_phone = cust_phone)
      else: 
            print('new customer!')
      
      # Check phone number length: 
      num_length = len(cust_phone.strip())
      if num_length != 10:
            return render_template('error.html', location = "Creating a new customer", cause = "Phone number length wrong.", 
                                   rec = "Start new customer form again, ensuring phone number is correct length with area code and no additional characters.")
  
      try:
            # Add new customer to database
            cust_to_add = customers(first_name = first_name, last_name = last_name, cust_phone = cust_phone, cust_email = cust_email, cust_address = cust_address)
            db.session.add(cust_to_add) #create object from form input

            # get the customer id from the customers table
            new_cust = db.session.query(customers).filter(customers.cust_phone == cust_phone)
            for id in new_cust:
                  id_save = id.cust_id
                  print(id_save)
                  print('--')

            session['cust_id'] = id_save

            # turn the yes and no to boolean values
            if clothes_yn == 'yes':
                  clothes_bool = True
            else: 
                  clothes_bool = False

            if jewelry_yn == 'yes':
                  jewelry_bool = True
            else: 
                  jewelry_bool = False

            if home_yn == 'yes':
                  home_bool = True
            else: 
                  home_bool = False
    
            # Add customer interests to database 
            cust_int_add = cust_interests(emp_id = emp_id, cust_id = id_save, clothes_yn = clothes_bool, jewelry_yn = jewelry_bool, home_yn = home_bool)
            db.session.add(cust_int_add)

            db.session.commit()

            # select customer summary 
            cust_summary_save = db.session.query(customer_summary).filter(customer_summary.c.cust_id == id_save)
            for cust in cust_summary_save:
                  session['pts_avail']=cust[4]

            return render_template('success.html', heading = 'New customer added.', title = 'New customer', cust_sum = cust_summary_save)
    
      except: #General error not covered by above. 
            return render_template('error.html', location = 'creating a new customer', cause = 'Unknown.', rec = 'Start new customer form again.', cust = True)


    

