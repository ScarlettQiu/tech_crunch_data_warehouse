# tech_crunch_data_warehouse  

## Summary  
This project aims to provide an instruction on how to use MySQL server and MySQL Workbench to do data modeling using the third normal form rule, create a database based on the ERD created in MySQL Workbench, and design SQL queries to solve business problems. The first part will be the database normalization in which I will use MySQL Workbench to create a database ERD. The second part will mainly be the SQL query design. I will create 3 SQL SELECT queries to solve 3 business problems.  

## Introduction  
### Dataset Introduction   
The sample dataset I chose for this project is “techcrunch” which contains information on start-up companies raising funds events. There are 9 variables in the dataset:  
•	company: company name  
•	numEmps: number of employers  
•	category: company type   
•	city: the city where the company is located in   
•	state: the state where the company is located in  
•	fundedDate: the date when the company was funded  
•	raisedAmt: the amount of money the company raised  
•	raisedCurrency: the currency of the fundraising  
•	round: the funding rounds  

## Entity Relationship Diagram of TechCrunch Database  
Below is the ERD I created using MySQL Workbench.  

#### Diagram 1: ERD of TechCrunch Database  
 
![image](https://user-images.githubusercontent.com/93269907/230159045-aed88d35-395c-4e2f-a316-17a2a26da5c0.png)
  
  
Consistent with the previous design, there are 6 tables in this ERD: company, state, currency, funding_round, address, fundraising_event.  

The primary key of the company is id which is unique and not null. The rest attributes name, numEmps, city, and category depend on the primary key and do not depend on each other.   

In the state table, id is the primary key which is unique and has no null value.   

Table currency has 2 attributes: id (primary key) and currency.  

Table funding_round has 2 attributes: id(primary key and round.   

The table address connects the table state and company using the foreign key state_id and company_id.   

One company has one registered address, and one address could only have one company. Therefore the relationship between company table and address table is one-to-one. The foreign key to connect these 2 tables is comp_id.   

One address belongs to one state and one state could have multiple company addresses. Therefore the relationship between these 2 tables is one-to-many. The foreign key to connect these 2 tables is state_id.   

One company could have one or more than one fundraising events, and one fundraising event only belongs to one company. So the relationship between the company and the fundraising table is one-to-many. The foreign key to connect these 2 tables is company_id.   

One fundraising event would involve only one currency for the amount raised, but one currency could be used in multiple fundraising events’ funding. Therefore the relationship between these 2 tables is one-to-many. The foreign key to connect these 2 tables is currency_id.   

One fundraising event has only one funding round defined, while one funding round may involve multiple fundraising events. Therefore the relationship between these 2 tables is one-to-many. The foreign to connect these 2 tables is round_id.  


