-- I don't entirely know what this shit does honestly but I made it work so who cares
USE MASTER
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'CLASSPROJECT') DROP DATABASE CLASSPROJECT
GO
IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'CLASSPROJECT') CREATE DATABASE CLASSPROJECT
GO
USE CLASSPROJECT
BEGIN TRANSACTION



-- Dropping Tables
DROP TABLE ORDERS;
DROP TABLE EMPLOYEE;
DROP TABLE SCHEDULE;
--DROP TABLE SHIFTS;
DROP TABLE CUSTOMER;
DROP TABLE LINE;
DROP TABLE PRODUCT;
DROP TABLE TRADEIN;



-- Creating Tables
CREATE TABLE EMPLOYEE (
	empId integer primary key,
	empLast varchar(15) not null,
	empFirst varchar(15) not null,
	empMiddle char(1),
	empEmail varchar(50),
	empPhone char(10) not null, -- Phone Number (no dashes)
	empAddress varchar(255) not null, -- Street Address (no City/State; that's what ZIP's for)
	empZip char(5) not null,
	empBirth date, -- Birth Date
	empHire date not null -- Hire Date
);

CREATE TABLE PRODUCT (
	productId integer primary key,
	productName varchar(255) not null,
	productNew integer not null, -- Count of how many new versions of the product are in stock
	productUsed integer not null, -- Count of used versions
	productRepair integer not null, -- Count of how many need to be repaired, but will be moved to used stock after repair (result of trade-in)
	productPriceN numeric(8, 2), -- Price of new versions
	productPriceU numeric(8, 2), -- Price of used versions
);

CREATE TABLE CUSTOMER (
	customerId integer primary key,
	customerLast varchar(15) not null,
	customerFirst varchar(15) not null,
	customerMiddle char(1),
	customerEmail varchar(50),
	customerPhone char(10)
);

/*CREATE TABLE SHIFTS (
	shiftId integer primary key,
	shiftDay integer not null, -- Day of the week (1-5, store isn't open on Saturdays and Sundays)
	shiftStart integer not null, -- Hour at which the shift starts
	shiftEnd integer not null -- Hour at which the shift ends
);*/

CREATE TABLE TRADEIN (
	tradeId integer primary key,
	customerId integer references CUSTOMER(customerId),
	productId integer references PRODUCT(productId) not null,
	tradeRep tinyint, -- Determines if the product was traded-in but required repair before being put into the stock
	tradePay numeric(9, 2)
);

CREATE TABLE ORDERS (
	orderId integer primary key,
	empId integer references EMPLOYEE(empId) not null, -- Employee who conducted the sale
	customerId integer references CUSTOMER(customerId), -- Can be null
	orderDate date default current_timestamp not null,
);

CREATE TABLE SCHEDULE (
	empId integer references EMPLOYEE(empId) primary key not null,
	--shiftId integer references SHIFTS(shiftId) not null,
	shiftDay integer not null, -- Day of the week (1-5, store isn't open on Saturdays and Sundays)
	shiftStart integer not null, -- Hour of the day (24 hour format)
	shiftEnd integer not null -- Hour of the day (24 hour format)
);

CREATE TABLE LINE (
	orderId integer references ORDERS(orderId) primary key not null,
	productId integer references PRODUCT(productId) not null,
	lineCon char(1) not null, -- Condition of the product (N for New, U for Used)
	lineRes tinyint, -- Whether the product is reserved or not
	lineRep tinyint, -- Whether the product is simply a repair request (not the same as trading-in a broken product that will be put into the stock after repair)
	linePrice numeric(9, 2)
);



-- Populating Tables
-- EmpId, Last, First, M, Email, Phone, Address, ZIP, Birth, HireDate
insert into EMPLOYEE values(100, 'Generic', 'Name', null, 'email@website.com', '5709991234', '111 The Road 999', '16933', null, '04-JUL-1776');
insert into EMPLOYEE values(101, 'Shmoe', 'Joe', null, 'fmail@website.com', '5701234567', '112 The Road 999', '16933', null, '14-JUL-1993');
insert into EMPLOYEE values(102, 'Doe', 'Jane', null, 'gmail@notgmail.com', '5702345678', '113 The Road 999', '16933', null, '29-DEC-1998');
insert into EMPLOYEE values(103, 'Doe', 'John', null, 'hmail@website.com', '5703456789', '114 The Road 999', '16933', null, '29-FEB-1992');
insert into EMPLOYEE values(104, 'Smith', 'John', null, 'imail@website.com', '5704567891', '115 The Road 999', '16933', null, '01-JAN-1981');

-- CustId, Last, First, M, Email, Phone
insert into CUSTOMER values(200, 'Conquest', 'John', null, null, null);
insert into CUSTOMER values(201, 'Patterson', 'Hank', null, 'hp@roundandbrown.com', null);
insert into CUSTOMER values(202, 'Pratt', 'Joe', null, 'jp@email.com', null);
insert into CUSTOMER values(203, 'Smith', 'Josh', null, 'js@email.com', null);
insert into CUSTOMER values(204, 'Something', 'Somari', null, 'somari@email.com', null);
insert into CUSTOMER values(205, 'Name', 'Some', null, 'somari@email.com', null);

-- ProdId, ProdName, NewStock, UseStock, RepairStock, NewPrice, UsePrice
insert into PRODUCT values(1000, 'Nintendo Entertainment System Console', 1, 4, 1, 289.99, 24.99);
insert into PRODUCT values(1001, 'Nintendo Entertainment System Gamepad', 6, 2, 0, 9.99, 2.49);
insert into PRODUCT values(1002, 'Sonic 3D Blast 6 NES Game', 0, 0, 0, null, 274.53);
insert into PRODUCT values(1003, 'PlayStation 2 Console ', 8, 2, 0, 294.49, 45.33);
insert into PRODUCT values(1004, 'Nintendo GameCube Console', 3, 6, 0, 242.49, 34.99);
insert into PRODUCT values(1005, 'XBox Console', 2, 5, 1, 349.99, 49.99);
insert into PRODUCT values(1006, 'Sega Master System Console', 1, 11, 0, 675.45, 81.61);
insert into PRODUCT values(1007, 'Super Nintendo Entertainment System Console', 0, 2, 0, 958.43, 39.99);
insert into PRODUCT values(1008, 'Sega Genesis Console', 1, 2, 0, 279.45, 19.99);
insert into PRODUCT values(1009, 'Nintendo 64 Console', 1, 3, 0, 215.42, 32.45);
insert into PRODUCT values(1010, 'PlayStation Console', 1, 3, 0, 162.98, 24.46);
insert into PRODUCT values(1011, 'Game.Com Console', 3, 2, 0, 69.99, 24.49);
insert into PRODUCT values(1012, 'Sonic Jam Game.Com Game', 0, 76, 0, null, 9.21);
insert into PRODUCT values(1013, 'Duke Nukem 3D Game.Com Game', 0, 52, 0, null, 11.54);
insert into PRODUCT values(1014, 'Super Mario Bros. 3 NES Game', 1, 3, 0, 215.54, 15.95);
insert into PRODUCT values(1015, 'Gun PS2 Game', 6, 1, 0, 24.49, 3.45);
insert into PRODUCT values(1016, 'Wario World GameCube Game', 1, 0, 0, 70.12, 22.45);
insert into PRODUCT values(1017, 'Sonic the Hedgehog SMS Game', 0, 2, 0, null, 39.44);
insert into PRODUCT values(1018, 'Comix Zone Genesis Game', 1, 2, 0, 91.74, 10.52);
insert into PRODUCT values(1019, 'Crazy Bus Genesis Game', 0, 1, 0, null, 999.99);
insert into PRODUCT values(1020, 'PlayStation 2 Gamepad', 2, 4, 0, 29.95, 4.99);
insert into PRODUCT values(1021, 'PlayStation 2 Multitap', 2, 0, 0, 14.49, null);
insert into PRODUCT values(1022, 'XBox Gamepad', 3, 3, 0, 29.95, 4.99);
insert into PRODUCT values(1023, 'Sega Master System Gamepad', 0, 2, 0, null, 0.99);
insert into PRODUCT values(1024, 'Super Nintendo Entertainment System Gamepad', 1, 2, 0, 105.74, 7.15);
insert into PRODUCT values(1025, 'Super Mario XXX Die... SNES Game', 0, 1, 0, null, 1.00);

-- OrderId, EmpId, CustId, Time
insert into ORDERS values(2000, 100, 200, '25-DEC-2015');
insert into ORDERS values(2001, 101, 201, '24-DEC-2015');
insert into ORDERS values(2002, 100, 202, '22-DEC-2015');
insert into ORDERS values(2003, 102, 203, '21-DEC-2015');
insert into ORDERS values(2004, 103, 204, '20-DEC-2015');
insert into ORDERS values(2005, 101, null, '15-JAN-2016');
insert into ORDERS values(2006, 102, 200, '15-JAN-2016');
insert into ORDERS values(2007, 101, null, '16-JAN-2016');
insert into ORDERS values(2008, 104, null, '17-JAN-2016');
insert into ORDERS values(2009, 104, 205, '18-JAN-2016');
insert into ORDERS values(2010, 105, null, '19-JAN-2016');
insert into ORDERS values(2011, 104, null, '19-JAN-2016');

-- EmpId, Day, Start, End
insert into SCHEDULE values(100, 1, 8, 15);
insert into SCHEDULE values(100, 2, 8, 15);
insert into SCHEDULE values(100, 3, 8, 15);
insert into SCHEDULE values(100, 4, 8, 15);
insert into SCHEDULE values(100, 5, 8, 15);
insert into SCHEDULE values(101, 1, 15, 22);
insert into SCHEDULE values(101, 2, 15, 22);
insert into SCHEDULE values(101, 3, 15, 22);
insert into SCHEDULE values(101, 4, 15, 22);
insert into SCHEDULE values(101, 5, 15, 22);
insert into SCHEDULE values(102, 1, 12, 18);
insert into SCHEDULE values(102, 2, 12, 18);
insert into SCHEDULE values(102, 3, 12, 18);
insert into SCHEDULE values(102, 4, 12, 18);
insert into SCHEDULE values(102, 5, 12, 18);
insert into SCHEDULE values(103, 1, 8, 15);
insert into SCHEDULE values(103, 2, 8, 15);
insert into SCHEDULE values(103, 3, 8, 15);
insert into SCHEDULE values(103, 4, 8, 15);
insert into SCHEDULE values(103, 5, 8, 15);
insert into SCHEDULE values(104, 1, 15, 22);
insert into SCHEDULE values(104, 2, 15, 22);
insert into SCHEDULE values(104, 3, 15, 22);
insert into SCHEDULE values(104, 4, 15, 22);
insert into SCHEDULE values(104, 5, 15, 22);

-- OrdId, ProdId, N/U, Reserve, Repair, Price
insert into LINE values(2000, 1000, 'U', 0, 0, 24.99);
insert into LINE values(2001, 1002, 'U', 0, 0, 274.53);
insert into LINE values(2002, 1003, 'U', 0, 0, 24.53);
insert into LINE values(2003, 1004, 'U', 0, 0, 74.53);
insert into LINE values(2004, 1001, 'U', 0, 0, 27.53);
insert into LINE values(2004, 1001, 'U', 0, 0, 27.53);
insert into LINE values(2005, 1007, 'N', 1, 0, 958.43);
insert into LINE values(2006, 1000, 'R', 0, 1, 11.51);
insert into LINE values(2007, 1011, 'N', 0, 0, 69.99);
insert into LINE values(2007, 1012, 'U', 0, 0, 9.21);
insert into LINE values(2007, 1013, 'U', 0, 0, 11.54);
insert into LINE values(2008, 1005, 'N', 0, 0, 349.99);
insert into LINE values(2008, 1022, 'N', 0, 0, 29.95);
insert into LINE values(2009, 1010, 'R', 0, 1, 9.12);
insert into LINE values(2010, 1016, 'U', 0, 0, 22.45);
insert into LINE values(2010, 1016, 'U', 0, 0, 22.45);
insert into LINE values(2010, 1016, 'U', 0, 0, 22.45);
insert into LINE values(2011, 1016, 'U', 1, 0, 22.45);

-- TradeId, CustId, ProdId, NeedRepair, Paid
insert into TRADEIN values(3000, 201, 1002, 0, 205.89);
insert into TRADEIN values(3001, 202, 1003, 0, 39.99);
insert into TRADEIN values(3002, 203, 1004, 0, 26.51);
insert into TRADEIN values(3003, 204, 1005, 0, 41.27);
insert into TRADEIN values(3004, 205, 1005, 1, 12.45);
insert into TRADEIN values(3005, 200, 1025, 0, 1.00);



-- I dunno what this does but I figured it was important
COMMIT;



-- Testing.
select * from ORDERS;
select * from EMPLOYEE;
select * from SCHEDULE;
select * from CUSTOMER;
select * from LINE;
select * from PRODUCT;
select * from TRADEIN;



-- Queries?
-- List employees and their hours who will be working before noon on Monday
SELECT EMPLOYEE.empLast, EMPLOYEE.empFirst, EMPLOYEE.empMiddle, SCHEDULE.shiftStart, SCHEDULE.shiftEnd
FROM EMPLOYEE INNER JOIN SCHEDULE ON EMPLOYEE.empId = SCHEDULE.empId
WHERE (SCHEDULE.shiftDay = 1 and SCHEDULE.shiftStart < 12);

-- List customers who requested a repair, what product they wanted repaired, and price of repair
SELECT CUSTOMER.customerLast, CUSTOMER.customerFirst, PRODUCT.productName, LINE.linePRICE
FROM CUSTOMER INNER JOIN
	(ORDERS INNER JOIN (LINE INNER JOIN PRODUCT ON LINE.productId = PRODUCT.productId) ON ORDERS.orderId = LINE.orderId)
	ON CUSTOMER.customerId = ORDERS.customerId
WHERE (LINE.lineRep = 1);

-- List trade-ins where the customer received $25 or more for their product
SELECT CUSTOMER.customerLast, CUSTOMER.customerFirst, TRADEIN.tradeId, TRADEIN.tradePay, PRODUCT.productName
FROM CUSTOMER INNER JOIN
	(TRADEIN INNER JOIN PRODUCT ON TRADEIN.productId = PRODUCT.productId)
	ON CUSTOMER.customerId = TRADEIN.customerId
WHERE (TRADEIN.tradePay >= 25);