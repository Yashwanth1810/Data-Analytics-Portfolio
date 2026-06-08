#-- WHERE Clause

SELECT * 
FROM parks_and_recreation.employee_salary;

SELECT * 
FROM parks_and_recreation.employee_salary
WHERE first_name='Leslie'; #AND last_name='Traeger';

SELECT * 
FROM parks_and_recreation.employee_salary
WHERE salary<=50000;

SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE birth_date>'1985-01-01'
OR NOT gender='male';

SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE (first_name='Leslie' AND age=44) OR age>55;

SELECT birth_date from employee_demographics WHERE birth_date LIKE '1962-%-%';

SELECT  occupation,salary
FROM parks_and_recreation.employee_salary
GROUP BY occupation, salary;

SELECT gender, AVG(age), MAX(age), MIN(age), count(age)
FROM employee_demographics
GROUP BY gender;

-- ORDER BY

SELECT *
FROM employee_demographics
ORDER BY 5,4 DESC;

SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender
HAVING AVG(age)>40;

SELECT occupation, AVG(salary)
FROM employee_salary
WHERE occupation LIKE '%Manager%'
GROUP BY occupation
HAVING AVG(salary)>50000;

SELECT *
FROM parks_and_recreation.employee_demographics
ORDER BY age DESC
LIMIT 3;


-- ALIASING

SELECT first_name, Avg(age) avg_age,age A
from employee_demographics
GROUP BY first_name,age
HAVING avg_age>40;

SELECT REPLACE('a b                    c',' ','') AS RESULT;

SELECT * 
FROM employee_salary;

SELECT 	first_name,
LEFT(first_name,4),
RIGHT(last_name,4),
SUBSTRING(first_name,3,2),
BIRTH_DATE,
SUBSTRING(BIRTH_DATE,6,2) AS Birth_Month
FROM employee_demographics;

SELECT REPLACE('              A                B B                                    ',' ','');

SELECT LOCATE('h','Yashwanth');

SELECT LOCATE('An', first_name) FROM employee_demographics;

SELECT first_name, last_name,
CONCAT(first_name,' ',last_name) AS full_name 
FROM employee_demographics;

SELECT first_name,last_name, age,
CASE 
	WHEN age < 30 THEN 'Young'
    WHEN age BETWEEN 31 AND 50 THEN 'Old'
    WHEN age > 50 THEN 'Super Experienced'
END AS age_bracket
FROM employee_demographics;

SELECT first_name,last_name, salary,
CASE 
	WHEN salary<=50000 THEN salary*1.05
    WHEN salary>50000 THEN salary*1.07
    
END AS new_salary,
CASE
	WHEN dept_id=6 THEN salary*0.10
END AS finance_department_bonus
FROM employee_salary;

SELECT * 
FROM employee_demographics;

SELECT * 
FROM employee_salary;

SELECT * 
FROM parks_departments;

SELECT first_name, dept_id
FROM employee_salary  
WHERE dept_id=1;

SELECT * 
FROM employee_demographics demo
LEFT JOIN employee_salary sal
ON demo.employee_id=sal.employee_id
LEFT JOIN parks_departments dept
ON sal.dept_id=dept.department_id;
-- SELECT *
-- FROM employee_salary
-- JOIN
-- SELECT *
-- FROM parks_departments
;

SELECT *
FROM employee_demographics demo
LEFT OUTER JOIN employee_salary sal
ON demo.employee_id=sal.employee_id
LEFT OUTER JOIN parks_departments pd
ON sal.dept_id=pd.department_id;

SELECT *
FROM actor a
INNER JOIN film_actor f
ON a.actor_id=f.actor_id ;

SELECT * 
FROM actor;

SELECT * 
FROM address;

SELECT * 
FROM category;

SELECT * 
FROM city;

SELECT *
FROM country;

SELECT * 
FROM customer;

SELECT * 
FROM film;

SELECT * 
FROM film_actor;

SELECT first_name, last_name, department_name
FROM employee_salary sal
LEFT JOIN parks_departments pd
ON sal.dept_id=pd.department_id
WHERE dept_id=1;

-- SUBQUERIES

SELECT *
FROM employee_demographics
WHERE employee_id IN(
					SELECT employee_id
                    FROM employee_salary
                    WHERE dept_id=1);
                    
SELECT first_name, salary,
(SELECT AVG(salary) AS avg_sal
FROM employee_salary)
FROM employee_salary;

SELECT gender, AVG(age), MIN(age), MAX(age), COUNT(age)
FROM employee_demographics
GROUP BY gender;

SELECT AVG(max_age)
FROM (SELECT gender, 
AVG(age) AS avg_age, 
MIN(age) AS min_age, 
MAX(age) AS max_age, 
COUNT(age) AS count_age
FROM employee_demographics
GROUP BY gender) AS agg_query
;

-- WINDOW FUNCTIONS
SELECT   demo.first_name, demo.last_name, gender, AVG(salary)
 FROM employee_demographics demo
 LEFT JOIN employee_salary sal
 ON demo.employee_id=sal.employee_id
 GROUP BY demo.first_name, demo.last_name,gender;
 
 SELECT  demo.first_name, demo.last_name,gender, salary, SUM(salary) OVER(PARTITION BY gender ORDER BY demo.employee_id ) AS Rolling_Total
 FROM employee_demographics demo
 LEFT JOIN employee_salary sal
 ON demo.employee_id=sal.employee_id
 ;
 
 SELECT  demo.first_name, demo.last_name,gender, salary, ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC ) AS row_num,
 RANK() OVER(PARTITION BY gender ORDER BY salary DESC ) AS rank_num,
 DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC ) AS dense_rank_num
 FROM employee_demographics demo
JOIN employee_salary sal
 ON demo.employee_id=sal.employee_id
 ;
 
 -- CTEs Common Table Expressions
 
 WITH CTE_Example AS 
 (
 SELECT gender, 
 AVG(salary) avg_sal, 
 MIN(salary) min_sal, 
 MAX(salary) max_sal, 
 COUNT(salary) num_of_emp
 FROM employee_demographics demo
INNER JOIN employee_salary sal
 ON demo.employee_id=sal.employee_id
 GROUP BY gender
 )
 SELECT AVG(avg_sal)
 FROM CTE_Example
 ;
 
 
 SELECT AVG(avg_sal), MAX(max_sal)
 FROM
 (
 SELECT gender, 
 AVG(salary) avg_sal, 
 MIN(salary) min_sal, 
 MAX(salary) max_sal, 
 COUNT(salary) count_sal
 FROM employee_demographics demo
JOIN employee_salary sal
 ON demo.employee_id=sal.employee_id
 GROUP BY gender
 ) example_subquery;
 
 
 WITH CTE_Example (Gender, AVG_Sal, Min_Sal, Max_Sal, COUNT_Sal)  AS
 (
 SELECT gender, 
 AVG(salary) avg_sal, 
 MIN(salary) min_sal, 
 MAX(salary) max_sal, 
 COUNT(salary) count_sal
 FROM employee_demographics demo
JOIN employee_salary sal
 ON demo.employee_id=sal.employee_id
 GROUP BY gender
 ) 
 SELECT *
 FROM CTE_Example
 ;
 
 SELECT AVG(avg_sal)
 FROM CTE_Example
 ;
 
 
 
 
 
 
 
 -- CREATING MULTIPLE CTEs
 
WITH CTE_Example AS
 (
 SELECT gender, birth_date, employee_id
 FROM employee_demographics
 WHERE birth_date> '1985-01-01'
 ),
 CTE_Example2 AS 
 (
 SELECT employee_id, salary 
 FROM employee_salary
 WHERE salary>50000
 )
 SELECT *
 FROM CTE_Example
 JOIN CTE_Example2
 ON CTE_Example.employee_id=CTE_Example2.employee_id;
 
 SELECT AVG(avg_sal)
 FROM CTE_Example
 ;
 
 -- TEMPORARY TABLES
 
 CREATE TEMPORARY TABLE temp_table
 (
 first_name VARCHAR(50),
 last_name VARCHAR(50),
 fav_movie VARCHAR(50)
 );
 
 SELECT * FROM temp_table;
 
 INSERT INTO temp_table VALUES('Yashwanth', 'S', 'Pushpa 1- The Rise');
 
SELECT * FROM temp_table;
 
 CREATE TEMPORARY TABLE salary_over_50k
 SELECT *
 From employee_salary
 WHERE salary>=50000;
 
 SELECT * FROM salary_over_50k ORDER BY salary DESC;
 
 SELECT * 
 FROM employee_salary 
 WHERE salary>50000;
 
 
 
 CREATE PROCEDURE hugeE_salaries()
 SELECT * 
 FROM employee_salary 
 WHERE salary>=50000;
 
CALL hugeE_salaries();
 
 DELIMITER $$
 CREATE PROCEDURE huge_salaries3()
 BEGIN
	 SELECT * 
	 FROM employee_salary 
	 WHERE salary>=50000;
	 SELECT * 
	 FROM employee_salary 
	 WHERE salary>=10000;
 END $$
 DELIMITER ;
 CALL huge_salaries3()
 
 
 DELIMITER $$
 CREATE PROCEDURE huge_salaries4()
 BEGIN
	 SELECT * 
	 FROM employee_salary 
	 WHERE salary>=50000;
	 SELECT * 
	 FROM employee_salary 
	 WHERE salary>=10000;
 END $$
 DELIMITER ;
 
 CALL huge_salaries4()
 
 
 DELIMITER $$
 CREATE PROCEDURE huge_salaries6(huggymuffin INT)
 BEGIN
	 SELECT salary
	 FROM employee_salary 
	 WHERE employee_id=huggymuffin;
 END $$
 DELIMITER ;
 
 CALL huge_salaries6(1);
 
 
 
--  TRIGGERS and EVENTS

SELECT * 
FROM employee_demographics;

SELECT * 
FROM employee_salary;
 
DELIMITER $$
CREATE TRIGGER employee_trigger
	AFTER INSERT ON employee_salary
	FOR EACH ROW
BEGIN 
	INSERT INTO employee_demographics (employee_id, first_name, last_name)
    VALUES (NEW.employee_id,NEW.first_name,new.last_name);
END $$
DELIMITER ;


INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES (13, 'Yashwanth', 'S', 'Data Analyst', 35000, NULL);
 
 -- EVENTS
 
 SELECT *
 FROM employee_demographics;
 DELIMITER $$
 CREATE EVENT del_retirees
 ON SCHEDULE EVERY 30 SECOND
 DO
 BEGIN
		 DELETE
		FROM employee_demographics
		WHERE age >= 60 ;
END $$
DELIMITER ;
 
SHOW VARIABLES LIKE  'event%';

SELECT * 
FROM employee_demographics;
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
  
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 