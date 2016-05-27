--Required features created as stored procedures.  Numbered and listed following the order specified in requirements document.


--1.

CREATE OR REPLACE PROCEDURE new_customer (cuser_name IN customer.username%TYPE, c_password IN customer.password%TYPE, c_address IN customer.address%TYPE, c_city IN customer.city%TYPE, c_state IN customer.stateabbv%TYPE, c_zip IN customer.zipcode%TYPE, c_country IN customer.country%TYPE, c_phone IN customer.phone%TYPE) AS
		
	--create variables to check if user is already registered and a counter to increment new customer ID
	is_registered int;
	cust_id int;
	
	BEGIN
		--use aggregate function COUNT to see if username is presenet in the table
		SELECT COUNT(username) INTO is_registered FROM customer WHERE username = cuser_name;
		--if else conditional to check if user is registered
		IF is_registered = 1 THEN
			dbms_output.put_line('You are already registered.');
		ELSE
			--select the highest custid and iterate by 1 to insert new custID
			SELECT MAX(custID) INTO cust_id FROM customer;
			cust_id := cust_id + 1;
			--insert new customer details into the database
			INSERT INTO customer VALUES(cust_id, cuser_name, c_password, c_address, c_city, c_state, c_zip, c_country, c_phone);
			dbms_output.put_line(cuser_name || ' has successfully registered.');
		END IF;
	
	--exception caught if user violates any of the constraints in columns for input
	EXCEPTION
		WHEN OTHERS THEN
			dbms_output.put_line('Maximum characters exceeded for a field.  All fields have a 50 character maximum.  Please try again.');
			
	END new_customer;
	
	
--2.

CREATE OR REPLACE PROCEDURE search_phones (min_price IN phone.price%TYPE, max_price IN phone.price%TYPE) AS
	
	--variables to handle the values fetched from the cursor
	p_brand phone.brand%TYPE;
	p_model phone.model%TYPE;
	p_price phone.price%TYPE;
	p_operatingsys phone.operatingsys%TYPE;
	p_screensize phone.screensize%TYPE;
	p_camerareso phone.camerareso%TYPE;
	p_network phone.network%TYPE;
	p_memory phone.memory%TYPE;
	p_storage phone.storage%TYPE;
	p_battery phone.battery%TYPE;
	p_color phone.color%TYPE;
	p_stock phone.stock%TYPE;
	
	--create cursor to select all phones and necessary values from table based on user price range
	CURSOR c1
	IS
		SELECT brand, model, price, operatingsys, screensize, camerareso, network, memory, storage, battery, color, stock
		FROM phone
		WHERE price >= min_price AND price <= max_price;
	
	BEGIN
		--if else conditional to check if max_price exceeds min_price and inform user if so
		IF max_price < min_price THEN
			dbms_output.put_line('Not a valid price range.  Please select another price range.');
		ELSE
			--open cursor
			OPEN c1;
			LOOP
				--fetch values into local variables for output
				FETCH c1 INTO p_brand, p_model, p_price, p_operatingsys, p_screensize, p_camerareso, p_network, p_memory, p_storage, p_battery, p_color, p_stock;
				EXIT WHEN c1%NOTFOUND;
				dbms_output.put_line(p_brand || ' ' || p_model || ' ' || p_price || ' ' || p_operatingsys || ' ' || p_screensize || ' ' || p_camerareso || ' ' || p_network || ' ' || p_memory || ' ' || p_storage || ' ' || p_battery || ' ' || p_color || ' ' || p_stock);
			END LOOP;
			--close cursor
			CLOSE c1;
		END IF;
		
		--catch any other exception and prompt user to try again
		EXCEPTION
			WHEN OTHERS THEN
				dbms_output.put_line('Not a valid price range.  Please try again.');
				
	END search_phones;
	
--3.

CREATE OR REPLACE PROCEDURE new_order (o_productID IN phone.productID%TYPE, o_quantity IN order_line.quantity%TYPE, o_shipmethod IN shipping.shipmethod%TYPE, o_ccnum IN orders.ccnum%TYPE, o_expirydate IN orders.expirydate%TYPE) AS
		
	--variables to fetch input from database and to validate if  product exists and the amount in stock
	product_exists int;
	check_stock int;
	o_id int;
	o_model phone.model%TYPE;
	o_price phone.price%TYPE;
	o_shipcost number;
	o_total number;
		
	BEGIN
		--validate that product exists by querying database for presence of the productID
		SELECT COUNT(productID) INTO product_exists FROM phone WHERE productID = o_productID;
		IF product_exists = 0 THEN
			dbms_output.put_line('The product does not exist, please select another.');
		ELSE
			--select all the necessary values from the database
			SELECT model, price, stock INTO o_model, o_price, check_stock FROM phone WHERE productID = o_productID;
			--check if there is enough of a product in stock to proceed with the order and inform user if there is not
			IF o_quantity > check_stock THEN
				dbms_output.put_line('Order: ' || o_quantity || ' exceeds amount in stock.  Current amount available is: ' || check_stock || '.  Please submit a new order with a valid quantity.');
			ELSE
				--find the largest orderID in database and increment by 1 to assign new unique orderID
				SELECT MAX(orderID) INTO o_id FROM orders;
				o_id := o_id + 1;
				--if else conditional to check shipping cost
				IF o_shipmethod = 'REGULAR' THEN
					o_shipcost := 10;
				ELSE
					o_shipcost := 20;
				END IF;
				--update stock of phone being ordered based on the order quantity
				UPDATE phone SET stock = check_stock - o_quantity WHERE productID = o_productID;
				--calculate the order total
				o_total := ((o_price * o_quantity) + o_shipcost) * 1.06;
				dbms_output.put_line('Your order details: Date: ' || sysdate || ' ID: ' || o_id || ' Model: ' || o_model || ' Quantity: ' || o_quantity || ' Shipping method: ' || o_shipmethod || ' Total: ' || o_total);
			END IF;
		END IF;
	END new_order;
	
--4.

CREATE OR REPLACE PROCEDURE update_shipping (o_ID IN orders.orderID%TYPE, o_newshipstatus IN shipping.shipstatus%TYPE) AS
		
	--variables to fetch input from database
	o_shipdate shipping.shipdate%TYPE;
	o_shipID shipping.shipID%TYPE;
		
	BEGIN
		--select shipID into local variable from join between shipping and order_line tables
		SELECT shipping.shipID INTO o_shipID FROM order_line, shipping WHERE order_line.shipID = shipping.shipID AND order_line.orderID = o_ID;
		--update shipping status in shipping table based on shipID obtained through join on order_line table with orderID
		UPDATE shipping SET shipstatus = o_newshipstatus WHERE shipID = o_shipID;
		--check if new shippingstatus is SHIPPED and update shipdate if so, otherwise select shipdate from database for output
		IF o_newshipstatus = 'SHIPPED' THEN
			UPDATE shipping SET shipdate = sysdate WHERE shipID = o_shipID;
			o_shipdate := sysdate;
		ELSE
			SELECT shipping.shipdate INTO o_shipdate FROM order_line, shipping WHERE order_line.shipID = shipping.shipID AND order_line.orderID = o_ID;
		END IF;
		dbms_output.put_line('Ship status updated to : ' || o_newshipstatus || ' ship date: ' || o_shipdate);
	END update_shipping;
	
--5.

CREATE OR REPLACE PROCEDURE check_shipping (o_ID IN orders.orderID%TYPE) AS
		
	--variables to fetch input from database
	o_shipstatus shipping.shipstatus%TYPE;
	o_shipdate shipping.shipdate%TYPE;
		
	BEGIN
		--select shipping status and date from database from join between shipping and order_line tables
		SELECT shipping.shipstatus, shipping.shipdate INTO o_shipstatus, o_shipdate FROM order_line, shipping WHERE order_line.shipID = shipping.shipID AND order_line.orderID = o_ID;
		dbms_output.put_line('Ship status: ' || o_shipstatus || ' ship date: ' || o_shipdate || ' orderID: ' || o_ID);
	
	--exception to catch when no data is found for the orderID provided
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			dbms_output.put_line('OrderID not valid.  Please try again.');
	END check_shipping;