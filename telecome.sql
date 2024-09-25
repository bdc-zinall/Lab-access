CREATE DATABASE telecome;
USE telecome;
# First create tables that have no foreign keys

CREATE TABLE city (
city_id INT NOT NULL AUTO_INCREMENT,
city_name VARCHAR(45) NOT NULL,
population INT NOT NULL,
mean_income FLOAT NOT NULL CHECK (mean_income >= 0),
PRIMARY KEY (city_id)
);

CREATE TABLE customer (
customer_id INT NOT NULL AUTO_INCREMENT,
first_name VARCHAR(45) NOT NULL,
last_name VARCHAR(45) NOT NULL,
date_of_birth DATE NOT NULL,
gender VARCHAR(10) NOT NULL,
city_id INT NOT NULL,
PRIMARY KEY (customer_id),
FOREIGN KEY (city_id) REFERENCES city(city_id)
);

CREATE TABLE plan (
plan_id INT NOT NULL AUTO_INCREMENT,
plan_name VARCHAR(15) NOT NULL,
free_minutes VARCHAR(45) NOT NULL,
free_sms VARCHAR(45) NOT NULL,
free_mbs VARCHAR(45) NOT NULL,
PRIMARY KEY (plan_id)
);

CREATE TABLE contract (
contract_id INT NOT NULL AUTO_INCREMENT,
phone_number VARCHAR(15) NOT NULL,
contract_desc VARCHAR(255) NOT NULL,
start_date DATE NOT NULL,
end_date DATE NOT NULL,
customer_id INT NOT NULL,
plan_id INT NOT NULL,
PRIMARY KEY (contract_id),
FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
FOREIGN KEY (plan_id) REFERENCES plan(plan_id)
);

CREATE TABLE calls (
call_id INT NOT NULL AUTO_INCREMENT,
date_time_of_call DATETIME NOT NULL,
called_phone_number VARCHAR(15) NOT NULL,
duration INT NOT NULL,
contract_id INT NOT NULL,
PRIMARY KEY (call_id),
FOREIGN KEY (contract_id) REFERENCES contract(contract_id)
);

# -------------------------------------------------------------------------------------------------------------------------------------------------------------

# Insert a few records into the tables to test your queries below.

# TABLE CITY
INSERT INTO city(city_id,city_name,population,mean_income) VALUES 
(1, 'Athens',664046,16587),
(2, 'Karpenisi', 13105, 5467),
(3, 'Heraklion', 312514, 12388),
(4, 'Nafplio', 14203, 4385),
(5, 'Corinth', 48132, 11965);

SELECT * FROM city;

# TABLE CUSTOMER
INSERT INTO customer(customer_id, first_name, last_name, date_of_birth,gender,city_id) VALUES
(1,'Daphne', 'Dimitriou','1976-12-31','female',1),
(2,'Ioanna','Stavrou','1969-06-18','female',2),
(3,'Constantinos','Georgiou','1977-06-13','male',3),
(4,'Theodora','Papadopoulou','2000-12-25','female',4),
(5,'Demetrios','Theodorou','1991-02-13','male',5),
(6,'Gregorios','Economou','1992-07-16','male',1),
(7,'Markos','Petrides','1968-12-09','male',2),
(8,'Thalia','Vasiliou','1990-08-12','female',3);

SELECT * FROM customer;

# TABLE PLAN
INSERT INTO plan(plan_id, plan_name, free_minutes, free_sms, free_mbs) VALUES
(1,'Student',1200,1200,600),
(2,'Call+',600,100,500),
(3, 'Datalicious',500,500,2000),
(4, 'Mobile_Plus',2000,600,1000),
(5, 'Freedom',1000,600,800);

SELECT * FROM plan;

# TABLE CONTRACT
INSERT INTO contract(contract_id, phone_number, contract_desc, start_date, end_date, customer_id, plan_id) VALUES
(1,'6945825551','personal','2017-05-24','2019-05-24',1,1),
(2,'6941627544','corporate','2018-01-18','2019-03-27',2,2),
(3,'6912345551','personal','2019-08-02','2020-08-02',3,3),
(4,'6974125558','corporate','2017-01-01','2019-12-15',4,4),
(5,'6945328879','personal','2018-12-18','2019-12-18',5,5),
(6,'6955324428','corporate','2019-12-18','2020-10-12',6,1),
(7,'6970326079','personal','2018-12-18','2019-11-28',7,2),
(8,'6969853264','personal','2018-12-18','2019-12-30',8,3),
(9,'6965987412','corporate','2018-12-18','2019-02-05',1,4),
(10,'6598745236','personal','2018-12-18','2019-04-08',2,5),
(11,'6958741236','corporate','2018-12-18','2019-12-08',3,1);

SELECT * FROM contract;


# TABLE CALLS
INSERT INTO calls(call_id, date_time_of_call, called_phone_number, duration, contract_id) VALUES
(1,'2018-02-14 03:54','6970156809',72000,1),
(2,'2018-06-10 09:45','6974123214',18,2),
(3,'2017-10-09 22:10','6956321563',36000,3),
(4,'2017-02-14 09:38','6985236471',7500,4),
(5,'2018-06-10 09:55','6985236541',8,5),
(6,'2018-01-09 22:14','6974123214',42000,6),
(7,'2017-01-22 18:20','6951234785',1500,7),
(8,'2018-07-23 15:10','6987415236',38000,8),
(9,'2018-06-06 09:09','6985236541',14,9),
(10,'2017-07-17 11:11','6953628745',1530,10),
(11,'2018-10-09 22:20','6974123214',36000,1),
(12,'2018-06-20 10:10','6951236745',28,2),
(13,'2017-11-09 22:14','6974123214',4752,3),
(14,'2017-10-22 18:20','6958231473',42896,4),
(15,'2018-11-05 22:14','6914758239',2333,5),
(16, '2018-06-09 22:20','6974123214',36000,6),
(17,'2018-01-08 11:30','6985236541',33,7),
(18,'2017-07-12 19:10','6987415236',33000,8),
(19,'2018-01-07 04:10','6951234785',2500,9),
(20,'2018-02-14 14:14','6958231473',2365,11);

SELECT * FROM calls;

--------------------------------------------------------------------------------------------------------------------
-- 1. SELECT, FROM, WHERE:
-- Query to Select Customers From Athens:
SELECT first_name, last_name, date_of_birth
FROM customer
WHERE city_id = (SELECT city_id FROM city WHERE city_name = 'Athens');

-- Query to Get Contracts Expiring in 2019:
SELECT phone_number, contract_desc, end_date
FROM contract
WHERE end_date BETWEEN '2019-01-01' AND '2019-12-31';

--------------------------------------------------------------------------------------------------------------------
-- 2. GROUP BY, HAVING:
-- Query to Count the Number of Contracts per Plan:
SELECT plan.plan_name, COUNT(contract.contract_id) AS contract_count
FROM contract
JOIN plan ON contract.plan_id = plan.plan_id
GROUP BY plan.plan_name;

-- Query to Find Cities With More Than 1 Customer:
SELECT city.city_name, COUNT(customer.customer_id) AS customer_count
FROM city
JOIN customer ON city.city_id = customer.city_id
GROUP BY city.city_name
HAVING customer_count > 1;

---------------------------------------------------------------------------------------------------------------------
-- 3. ORDER BY:
-- Query to Find the Longest Call Made:
SELECT called_phone_number, duration
FROM calls
ORDER BY duration DESC
LIMIT 1;

-- Query to List All Customers Alphabetically:
SELECT first_name, last_name
FROM customer
ORDER BY last_name, first_name;

---------------------------------------------------------------------------------------------------------------------
-- 4. JOIN Operations:
-- Query to Get Customers With Their City Name and Plan:
SELECT customer.first_name, customer.last_name, city.city_name, plan.plan_name
FROM customer
JOIN city ON customer.city_id = city.city_id
JOIN contract ON customer.customer_id = contract.customer_id
JOIN plan ON contract.plan_id = plan.plan_id;

----------------------------------------------------------------------------------------------------------------------
-- 5. Filtering Data:
-- Query to Get Contracts with "personal" Descriptions That Ended in 2019:
SELECT phone_number, start_date, end_date
FROM contract
WHERE contract_desc = 'personal' AND end_date BETWEEN '2019-01-01' AND '2019-12-31';

-- Query to Find Calls Longer Than 1 Hour:
SELECT called_phone_number, duration
FROM calls
WHERE duration > 3600; -- More than 1 hour (3600 seconds)

---------------------------------------------------------------------------------------------------------------------
-- 6. INSERT (Create):
-- Insert a New City:
INSERT INTO city (city_name, population, mean_income)
VALUES ('Patras', 214580, 12500);

----------------------------------------------------------------------------------------------------------------------
-- 7. UPDATE (Update):
-- Update a Customer's Phone Number:
UPDATE contract
SET phone_number = '6958741234'
WHERE contract_id = 1;

----------------------------------------------------------------------------------------------------------------------









