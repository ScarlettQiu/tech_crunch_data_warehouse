#----SQL Queries--------------------------

SELECT @@sql_mode; #check the sql mode

# Q1: which company has the highest amount raised in one seed round (among USD currency)
SELECT name, highest, round FROM company c #select the columns which need to be shown in the result
JOIN ( 
SELECT company_id, MAX(raised_amt) AS highest, round FROM fundraising_event fe #Join company with a subquery
JOIN funding_round fr ON fe.round_id = fr.id 
JOIN currency u ON fe.currency_id = u.id   #inner join the tables currency, funding_round and fundraising_event
WHERE round = 'seed' AND currency = 'USD' #set the conditions regarding the round and currency
GROUP BY company_id, round) AS a #count the max by company and round
ON c.id = a.company_id #the foreign key to join the subquey and company table
ORDER BY highest DESC #order the result by highest in descending order
LIMIT 1 #only show the first result
;

#Q2: List the top 5 states which have the most tech companies joined in fundraising events
SELECT state, COUNT(fe.company_id) AS NumCompany FROM state s #select the columns and count the number of companies using company_id
JOIN address a ON s.id = a.state_id
JOIN company c ON a.comp_id = c.id
JOIN fundraising_event fe on c.id = fe.company_id #from inner join tables state, address, company and fundraising_event 
GROUP BY state #count the company number by state
ORDER BY NumCompany DESC #order the result by the number of companies in descending order
LIMIT 5; #show the top 5 results

#Q3: how many software and web companies had round c fundraising?
SELECT round, category, COUNT(company_id) AS NumCompany FROM fundraising_event fe #select the columns and count the number of companies using company_id
JOIN funding_round fr ON fe.round_id = fr.id 
JOIN company c ON fe.company_id =c.id #from inner joined tables company, funding_round, company, category
WHERE category IN ('software', 'web') AND round = 'c' #set the condition that category should be either software or web, round should be c
GROUP BY round, category #count the number of companies by round and then by category
ORDER BY NumCompany; #order the result by number of companies

