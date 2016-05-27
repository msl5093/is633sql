--setup script, creates tables and inserts sample data

SET SERVEROUTPUT ON

--create tables in order: phone, customer, orders, shipping, order_line for PK and FK integrity
--create table phone

create table phone (
	productID int,
	brand varchar(30),
	model varchar(30),
	price number,
	operatingsys varchar(30),
	screensize number,
	camerareso varchar(30),
	network varchar(10),
	memory number,
	storage number,
	battery number,
	color varchar(30),
	stock int,
	primary key (productID)
);

--create table customer

create table customer (
	custID int,
	username varchar(50),
	password varchar(50),
	address varchar(50),
	city varchar(30),
	stateabbv varchar(2),
	zipcode varchar(5),
	country varchar(30),
	phone varchar(12),
	primary key (custID)
);

--create table orders

create table orders (
	orderID int,
	custID int,
	orderdate date,
	ccnum varchar(16),
	expirydate date,
	primary key (orderID),
	foreign key (custID) references customer(custID)
);

--create table shipping

create table shipping (
	shipID int,
	shipmethod varchar(30),
	shipcost number,
	shipstatus varchar(30),
	shipdate date,
	primary key (shipID)
);

--create table order_line

create table order_line (
	orderID int,
	productID int,
	quantity int,
	total number(18,2),
	shipID int,
	foreign key (orderID) references orders(orderID),
	foreign key (productID) references phone(productID),
	foreign key (shipID) references shipping(shipID)
);

--insert sample data into phone table

INSERT INTO phone VALUES(1001, 'Apple', 'iPhone 6', 600, 'iOS 8', 4.7, '8 MP', '4G LTE', 2, 16, 8, 'gray', 10);
INSERT INTO phone VALUES(1002, 'Apple', 'iPhone 6 Plus', 700, 'iOS 8', 5.6, '8 MP', '4G LTE', 2, 16, 10, 'gray', 7);
INSERT INTO phone VALUES(1003, 'Apple', 'iPhone 5s', 500, 'iOS 7', 4.1, '6 MP', '4G', 1, 16, 6, 'gold', 3);
INSERT INTO phone VALUES(1004, 'Samsung', 'Galaxy S5', 400, 'Android 4.0', 5.6, '11 MP', '4G LTE', 2, 32, 8, 'blue', 12);
INSERT INTO phone VALUES(1005, 'Samsung', 'Galaxy Note 3', 500, 'Android 4.1', 5.6, '12 MP', '4G LTE', 3, 64, 10, 'blue', 2);
INSERT INTO phone VALUES(1006, 'Nokia', 'Lumia 1020', 400, 'Windows Phone 8.1', 5.8, '20 MP', '4G', 2, 32, 6, 'yellow', 5);
INSERT INTO phone VALUES(1007, 'Motorola', 'Nexus 6', 300, 'Android 5.0', 5.1, '12 MP', '4G LTE', 3, 32, 9, 'black', 8);
INSERT INTO phone VALUES(1008, 'Motorola', 'Nexus 5', 250, 'Android 4.1', 4.7, '8 MP', '4G', 2, 16, 7, 'black', 4);

--insert sample data into customer table

INSERT INTO customer VALUES(100, 'jsmith123@yahoo.com', 'abc123', '123 Front Street', 'Harrisburg', 'PA', '17111', 'United States', '717-555-1122');
INSERT INTO customer VALUES(101, 'tjohnson456@yahoo.com', 'zxc456', '456 North Street', 'Baltimore', 'MD', '12111', 'United States', '123-456-2948');
INSERT INTO customer VALUES(102, 'abarnes763@gmail.com', 'Password1', '789 Thrid Street', 'Pittsburgh', 'PA', '18882', 'United States', '717-987-9900');
INSERT INTO customer VALUES(103, 'tonyd432@gmail.com', 'P@ssw0rd2', '876 River Road', 'Johnstown', 'PA', '18883', 'United States', '814-444-9384');
INSERT INTO customer VALUES(104, 'nmarcus33@msn.com', '101abcd', '1223 North Front Street', 'Arlington', 'VA', '22443', 'United States', '737-313-1241');

--insert sample data into orders table

INSERT INTO orders VALUES (10001, 100, '13-NOV-14', '1111222233334444', '15-DEC-17');
INSERT INTO orders VALUES (10002, 101, '12-FEB-15', '9999888877776666', '14-JAN-19');
INSERT INTO orders VALUES (10003, 102, '09-MAR-15', '6666777733338888', '02-DEC-16');
INSERT INTO orders VALUES (10004, 103, '01-OCT-15', '7777123489761029', '15-DEC-18');
INSERT INTO orders VALUES (10005, 104, '07-OCT-14', '4596987301951837', '22-JUN-20');

--insert sample data into shipping table

INSERT INTO shipping VALUES (5001, 'REGULAR', 10, 'DELIVERED', '15-NOV-14');
INSERT INTO shipping VALUES (5002, 'REGULAR', 10, 'DELIVERED', '15-FEB-15');
INSERT INTO shipping VALUES (5003, 'EXPRESS', 20, 'DELIVERED', '10-MAR-15');
INSERT INTO shipping VALUES (5004, 'REGULAR', 10, 'SHIPPED', '03-OCT-15');
INSERT INTO shipping VALUES (5005, 'REGULAR', 10, 'NOT SHIPPED YET', '');

--insert sample data into order_line table

INSERT INTO order_line VALUES(10001, 1008, 1, 270.30, 5001);
INSERT INTO order_line VALUES(10002, 1001, 2, 1277.30, 5002);
INSERT INTO order_line VALUES(10003, 1004, 3, 1293.20, 5003);
INSERT INTO order_line VALUES(10004, 1002, 1, 747.30, 5004);
INSERT INTO order_line VALUES(10005, 1003, 2, 1065.30, 5005);