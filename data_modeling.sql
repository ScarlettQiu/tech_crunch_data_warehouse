CREATE DATABASE techcrunch; #to create a new schema named techcrunch

SHOW DATABASES; #double check whether the newly created database is in the server

USE techcrunch; #define the database we will use

#-------Create tables---------------------------------------

DROP TABLE IF EXISTS company; #make sure there is not error when creating the table
CREATE TABLE company (
         id INT NOT NULL,
         name VARCHAR(255),
         numEmps INT,
         city VARCHAR(45),
         category VARCHAR(45) #create the table company with its columns and types
);

DROP TABLE IF EXISTS state; #make sure there is not error when creating the table state
CREATE TABLE state (
         id INT NOT NULL,
         state VARCHAR(45) #create the table state with its columns and types
);

DROP TABLE IF EXISTS currency; #make sure there is not error when creating the table currency
CREATE TABLE currency (
         id INT NOT NULL,
         currency VARCHAR(45) #create the table currency with its columns and types
);

DROP TABLE IF EXISTS funding_round; #make sure there is not error when creating the table funding_round
CREATE TABLE funding_round (
         id INT NOT NULL,
         round VARCHAR(45) #create the table funding_round with its columns and types
);


DROP TABLE IF EXISTS fundraising_event; #make sure there is not error when creating the table fundraising_event
CREATE TABLE fundraising_event (
         id INT NOT NULL,
         funded_date VARCHAR(45), 
         raised_amt INT,
         currency_id INT,
         company_id INT,
         round_id INT #create the table fundraising_event with its columns and types
);

DROP TABLE IF EXISTS address; #make sure there is not error when creating the table address
CREATE TABLE address (
         id INT NOT NULL,
         state_id INT,
         comp_id INT #create the table address with its columns and types
);


#--------Define Primary Key, Foreign Key, Constraints--------------------------

#Add primary key to the company table and modify the primary key to be auto incremented 
ALTER TABLE company
ADD PRIMARY KEY (id), #define primary key
MODIFY id INT NOT NULL AUTO_INCREMENT; #add auto_increment to primary key

#Add primary key to the state table and modify the primary key to be auto incremented 
ALTER TABLE state
ADD PRIMARY KEY (id), #define primary key
MODIFY id INT NOT NULL AUTO_INCREMENT; #add auto_increment to primary key

#Add primary key to the currency table and modify the primary key to be auto incremented 
ALTER TABLE currency
ADD PRIMARY KEY (id), #define primary key
MODIFY id INT NOT NULL AUTO_INCREMENT;#add auto_increment to primary key

#Add primary key to the funding_round table and modify the primary key to be auto incremented 
ALTER TABLE funding_round
ADD PRIMARY KEY (id), #define primary key
MODIFY id INT NOT NULL AUTO_INCREMENT; #add auto_increment to primary key

#Define primary key, foreign key and constraints to the fundraising_event table
ALTER TABLE fundraising_event
ADD PRIMARY KEY (id), #define primary key
MODIFY id INT NOT NULL AUTO_INCREMENT, #add auto_increment to primary key
ADD CONSTRAINT fk_currency #define constraint
FOREIGN KEY (currency_id) REFERENCES currency(id), #define foreign key and its reference table column
ADD CONSTRAINT fk_company #define constraint
FOREIGN KEY (company_id) REFERENCES company(id), #define foreign key and its reference table column
ADD CONSTRAINT fk_round #define constraint
FOREIGN KEY (round_id) REFERENCES funding_round(id) #define foreign key and its reference table column
ON UPDATE CASCADE #to enable that when parent primary key changed, the value in this table will also change accordingly
ON DELETE CASCADE; #to enable that when rows deleted in parent table, the corresponding rows in this table also deleted

#Define primary key, foreign key and constraints to the address table
ALTER TABLE address
ADD PRIMARY KEY (id), #define primary key
MODIFY id INT NOT NULL AUTO_INCREMENT, #add auto_increment to primary key
ADD CONSTRAINT fk_state #define constraint
FOREIGN KEY (state_id) REFERENCES state(id), #define foreign key and its reference table column
ADD CONSTRAINT fk_comp #define constraint
FOREIGN KEY (comp_id) REFERENCES company(id) #define foreign key and its reference table column
ON UPDATE CASCADE #to enable that when parent primary key changed, the value in this table will also change accordingly
ON DELETE CASCADE; #to enable that when rows deleted in parent table, the corresponding rows in this table also deleted


#-----Before executing following SQL commands, the dataset "techcrunch" should be imported in to MySQL first-------------

#import dataset techcrunch into mysql workbench first, then execute below commands
SELECT * FROM raw; #check the distinct values in numEmps

#disable SQL Safe updates mode, so that we could update the column with no WHERE clause
SET SQL_SAFE_UPDATES = 0;

#update raw table numEmps column's blank cell into null
UPDATE
  raw
SET 
  numEmps = CASE numEmps WHEN '' THEN NULL ELSE numEmps END;

#change the numEmps column's type into integer
ALTER TABLE raw
MODIFY COLUMN numEmps INT; #change data type of the column numEmps to int in a table raw


#-------Insert values into tables-------------------

INSERT INTO company (name, numEmps, city, category)
   SELECT DISTINCT company, numEmps, city, category FROM raw; #insert distinct values through selecting values from raw table
   
INSERT INTO currency (currency)
   SELECT DISTINCT raisedCurrency FROM raw; #insert distinct values through selecting values from raw table
   
INSERT INTO funding_round (round)
   SELECT DISTINCT round FROM raw; #insert distinct values through selecting values from raw table
   
INSERT INTO state (state)
   SELECT DISTINCT state FROM raw; #insert distinct values through selecting values from raw table

#Create a temporary view
DROP VIEW IF EXISTS temp; #to make sure no errors when creating the view temp
CREATE VIEW temp AS
  SELECT company, r.state, fundedDate, raisedAmt, raisedCurrency, r.round, c.id AS company_id, s.id AS state_id, u.id AS currency_id, f.id AS round_id FROM raw r
  JOIN company c on r.company = c.name
  JOIN state s on r.state = s.state
  JOIN currency u on r.raisedCurrency = u.currency
  JOIN funding_round f on r.round = f.round; #creating the view temp by selecting columns from joining tables

SELECT * FROM temp; #double check the value in temp

#insert distinct values through selecting values from view temp
INSERT INTO fundraising_event (funded_date, raised_amt, currency_id, company_id, round_id)
   SELECT DISTINCT fundedDate, raisedAmt, currency_id, company_id, round_id FROM temp;

#insert distinct values through selecting values from view temp
INSERT INTO address (comp_id, state_id)
   SELECT DISTINCT company_id, state_id FROM temp;
 
#change the column funded_date to date type
UPDATE fundraising_event
SET funded_date = str_to_date(funded_date, '%d-%M-%Y'); #define the format as ‘%d-%M-%Y’ in the str_to_date function

#double check the updated table
SELECT * FROM fundraising_event;

#Drop the table not needed anymore
DROP TABLE raw;

#Drop the temporary view
DROP VIEW temp;
