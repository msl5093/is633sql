--tests for each feature

--1.

/*

	The following statements will test the new_customer procedure.  If a user is already registered, they will receive a message that they are already registered.  The next statement will register a user with valid inputs and display a message that registration is successful.  Finally, the last statement will attempt to register while violating one of the column constraints and display a message to the user to try again.  Outputs will be the messages to the user and some changes to the customer table.  Select queries will be placed at the beginning of the statements and the end to show changes to the table.  Output for successful registration: the message "<username> has successfully registered."  Output for user already registered: the message "You are already registered."  Output for exception: "Maximum characters exceeded for a field.  All fields have a 50 character maximum.  Please try again."

*/

SELECT * FROM customer;
EXEC new_customer('test1012@yahoo.com', 'password456', '123 8th Street', 'Harrisburg', 'PA', '17111', 'United States', '717-555-1234');
EXEC new_customer('testuser1112@gmail.com', 'password789', '123 N Front Street', 'Harrisburg', 'PA', '17111', 'United States', '717-555-4444');
EXEC new_customer('testuser1112@gmail.com', 'password789', '123 N Front Street', 'Harrisburg', 'PA', '17111', 'United States', '717-555-4444');
EXEC new_customer('testbaduser@gmail.com', 'abceffffffffffffffffffffffffffffffffffffffffffffffffff', '123 N Front Street', 'Harrisburg', 'PA', '17111', 'United States', '717-555-4444');
SELECT * FROM customer;


--2.

/*
	The following three statements will test the search_phones procedure.  Three different statements will validate the procedure.  The first two will give two different valid price ranges to show different outputs.  The last statement will give a higher minimum price than maximum price, the output of which will be a message to the user that they need to give a valid price range and try again.  Outputs for a valid phone price range include:  phone brand, model, price, operating system, screen size, camera resolution, network, memory, storage, battery, color, and amount in stock.  Outputs for an invalid price range will be a message to the user: "Not a valid price range.  Please select another price range."
*/

EXEC search_phones(100, 300);
EXEC search_phones(400, 800);
EXEC search_phones(500, 100);


--3.

/*
	The following statements will test the new_order procedure.  Five different statements will validate the procedure.  The first three will be tests for valid orders with valid inputs.  The outputs will be a messages with the relevant order details including the computed totals.  These will also include changes to the phone table as outputs.  The fourth statement will attempt an invalid order where quantity requested exceeds the amount in stock.  The output will be a message to the user that there is not enough of the product in stock to fulfill the order with no changes to any tables.  Finally, the last statement will attempt an invalid order for a product that does not exist.  The output will be a message to the user that the product they have selected is not valid and to try again.  Select statements will be placed at the beginning and end of these test statements to show changes to the phone table.  Outputs for a valid order: "Your order details: Date: <order date> ID: <order ID> Model: <phone model> Quantity: <order quantity> Shipping method: <shipping method> Total: <order total>."  Output for an invalid order will be either product does not exist: "Product does not exist.  Please select another." or when the requested quantity exceeds the amount in stock: "Order: <requested quantity> exceeds amount in stock.  Current amount available is: <phone stock>.  Please submit a new order with a valid quantity.."
*/

SELECT * FROM phone;
EXEC new_order(1001, 1, 'REGULAR', '1234567891234567', '15-DEC-17');
EXEC new_order(1002, 4, 'REGULAR', '1234567891234567', '15-DEC-17');
EXEC new_order(1003, 2, 'EXPRESS', '1234567891234567', '15-DEC-17');
EXEC new_order(1001, 20, 'REGULAR', '1234567891234567', '15-DEC-17');
EXEC new_order(5555, 2, 'REGULAR', '1234567891234567', '15-DEC-17');
SELECT * FROM phone;


--4.

/*
	The following statements will test the update_shipping procedure.  The first two will update the shipping status from NOT YET SHIPPED to SHIPPED in order to validate that shipdate successfully updates to sysdate.  The remaining statements will validate a ship status change that does not effect the ship date.  Outputs will include messages to the user of the new ship status as well as the ship date, regardless of whether it was changed or not.  Each statement will include changes to the shipping table and select statements will be included prior to and following the execution of these test statements to show the changes.  Output will be a message to the user: "Ship status updated to : <new shipping status> ship date: <ship date, either sysdate if ship status changed to SHIPPED, existing ship date if any other status>."
*/

SELECT * FROM shipping;
EXEC update_shipping(10005, 'SHIPPED');
EXEC update_shipping(10004, 'SHIPPED');
EXEC update_shipping(10001, 'DELIVERED');
EXEC update_shipping(10002, 'DELIVERED');
SELECT * FROM shipping;


--5.

/*
	The following statements will test the check_shipping procedure.  The first three statements will check the shipping statuses for valid orderIDs.  The outputs will be messages to the user with the relevant details.  The final two statements will test the procedure with invalid orderIDs as caught by the NO_DATA_FOUND exception.  The outputs will be messages to the user that these are not valid orderIDs.  No changes to any tables will result from these statements.  Outputs will include the following messages to the user:  for a valid order ID: "Ship status: <ship status> ship date: <ship date> orderID: <order ID>" and for an invalid order ID: "OrderID not valid.  Please try again."
*/


EXEC check_shipping(10001);
EXEC check_shipping(10002);
EXEC check_shipping(10003);
EXEC check_shipping(99999);
EXEC check_shipping(123456789);