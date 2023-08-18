--------------- Update and Delete Statements ---------------

/* UPDATE example: to show an example update statement, we will show the situation where a customer would like to update
their email address. This is a realistic update example because people's contacts change. 
In this case, let's say that Serafino realized her kid used their email address instead of hers, and would like it updated
from 'carebearlover145@gmail.com' to 'serafino.acciai@gmail.com'. In the update statement, we could specify this by cust_id, 
or by a combination of other columns. However, we choose to use cust_id, because if this were implemented into 
the application, we would likely do the searching for the correct customer prior to this step of actually updating the row 
in this table. Thus, let's assume we already underwent a searching step and determined that Serafino's cust_id is 1. */
UPDATE customers
SET cust_email = 'serafino.acciai@gmail.com'
WHERE cust_id = 1
RETURNING *; 

/* DELETE example: to show an example delete statement, we must first consider which tables make sense to delete.
First, employees. We want to keep track of employees and thus have a column called 'current_emp', which is default set to
true but can be updated to false if needed. Below, notice that we change employee 2 to no longer be an employee. This
maintains the information without deleting the employee on record. Note that we do not need to add any constraints stopping
previous employees to add transactions because what if we want to add a transaction retroactively. Further, in the logical use
of this database, there would be no case where an employee would be entered wrong, or where that would have large consequences.
Next consider customers. Similarly, we can change deleted from false to true to show the customer info as deleted without
losing all the information. Let's say that customer 2, Miranda Bell, no longer wants to be considered a customer, receive
emails, etc. This is shown below.
Now to actually utilize a delete statement, we will consider the transactions table. Let's consider a case where someone
mistakenly added the wrong amount for a transaction, wrong point redemption, or wrong point multiplier bonus. This would delete
everything from the table. In our table creation statements, we specified ON DELETE CASCADE so that the tables with associated
transaction ids would also be deleted. For example, let's consider transaction 10. In this transaction, the bonus point multiplier
was accidently typed as 10 instead of 1. Thus, the customer got way too many points for the transaction and thus the transaction
must be removed with the following delete statement. The next step would be to add the correct transaction info back into the
database via another insert statement. */
--Effectively delete employee record via an update statement
UPDATE employee
SET current_emp = FALSE
WHERE emp_id = 2;
--Effectively delete customer record via an update statement
UPDATE customers
SET deleted = TRUE
WHERE cust_id = 2;
--Delete a transaction
DELETE FROM transactions
WHERE trans_id = 10;
