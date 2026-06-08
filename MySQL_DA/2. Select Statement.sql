SELECT * 
FROM  parks_and_recreation.employee_demographics;



SELECT first_name,
last_name,
birth_date,
age,
(age+10)*10
#(age+10)*10-2
# PEMDAS(Parenthesis, Exponents, Multiplication, Division, Addition, Subtraction)  follows rukes like BODMAS 
FROM  parks_and_recreation.employee_demographics;

SELECT DISTINCT gender, first_name
FROM  parks_and_recreation.employee_demographics;

SELECT * FROM parks_and_recreation.employee_demographics 
WHERE first_name LIKE '____';

SELECT dem.first_name, dem.last_name,sal.salary, sal.employee_id
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
ON dem.employee_id=sal.employee_id
ORDER BY salary DESC;
-- WHERE  employee_demographics.employee_id=3; 

SELECT * 
FROM employee_demographics;

SELECT * 
FROM employee_salary;

SELECT *
FROM employee_demographics AS dem
RIGHT OUTER JOIN employee_salary AS sal
ON dem.employee_id=sal.employee_id;

-- SELF JOIN 

SELECT e1.employee_id AS emp_santa,
e1.first_name AS first_name_santa,
e1.last_name AS last_name_santa,
e2.employee_id AS emp_name,
e2.first_name AS first_name_emp,
e2.last_name AS last_name_emp
FROM employee_salary e1
JOIN employee_salary e2
ON e1.employee_id+1=e2.employee_id
;

-- JOINING MULTIPLE TABLES TOGETHER

SELECT *
FROM employee_demographics AS dem
INNER join employee_salary AS sal
	ON dem.employee_id=sal.employee_id;
OUTER JOIN	parks_departments AS pd
	ON sal.dept_id=pd.department_id;
    
SELECT * 
FROM parks_departments;

# UNIONS
SELECT first_name, last_name 
FROM employee_demographics
UNION ALL
SELECT employee_id, salary
FROM employee_salary;

SELECT first_name, last_name, 'Old Man' AS label
FROM employee_demographics
WHERE age>40 AND gender='Male'
UNION 
SELECT first_name, last_name, 'Old lady' AS label
FROM employee_demographics
WHERE age>40 AND gender='Female'
UNION
SELECT first_name, last_name, 'Highly Paid Employee' AS label
FROM employee_salary
WHERE salary>70000
; 

-- STRING Functions

SELECT LENGTH("Hi");

SELECT first_name,LENGTH(first_name)
FROM employee_demographics
ORDER BY 1; 

SELECT LOWER("SKYBluE") UPPERCASE;

SELECT first_name,UPPER(first_name)
FROM employee_demographics

SELECT * 
FROM employee_demographics;