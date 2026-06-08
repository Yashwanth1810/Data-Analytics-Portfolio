-- DATA CLEANING


SELECT * FROM world_layoffs.layoffs;


-- 1 remove duplicate
-- 2 standard data
-- 3 null values or blank values
-- 4 remove any column

select*
from layoffs;

-- creating  another table so that the original is not affected.

create table staging_layoffs
like layoffs;


-- checking out the new table created

select*
from staging_layoffs;

-- populating the table

insert into
staging_layoffs
select*
from layoffs;

-- check that the table is populated correctly
select*
from staging_layoffs;

-- checking for duplicates
select*
from staging_layoffs;

select*,
row_number() over(
partition by company, industry, total_laid_off, percentage_laid_off, `date`) as row_num
from staging_layoffs;

-- creating a cte on this 



WITH duplicate_cte as
(
select*,
row_number() over(
partition by company, industry, total_laid_off, percentage_laid_off, `date`) as row_num
from staging_layoffs
)
select *
from duplicate_cte
where row_num >1;

-- checking  company names before deletingt the duplicates

select*
from staging_layoffs
where company = "oda";


-- deleting duplicates isn't quiet easy because there are no columns for numbers in this datasety, so we would have to create another table
-- this time by highlighting the table-then click copy to clip board and then create statement and you past

CREATE TABLE `staging_layoffs2`(
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num`int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


select*
from staging_layoffs2;

insert into
staging_layoffs2
SELECT *,
ROW_NUMBER() OVER(
partition by company, industry, total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions) as row_num
from staging_layoffs;


select*
from staging_layoffs2
where row_num >1;

-- Then change select statement to delete

delete
from staging_layoffs2
where row_num > 1;-


-- checking that the table was deleted

select*
from staging_layoffs2
where row_num >1;

-- now check the entire table

select*
from staging_layoffs2;


-- STANDARDIZING DATA--FINDING ISSUES ON YOUR DATA AND FIXING IT

SELECT company,trim(company)
FROM staging_layoffs2;

-- trim(it removes the white spaces either on the left or right
update staging_layoffs2
set company = trim(company);


-- look at industry
SELECT distinct industry
FROM staging_layoffs2
order by 1;

-- crypto showed up in different ways so we would just update the crypto part

SELECT*
FROM staging_layoffs2
where industry like 'crypto%';


update staging_layoffs2
set industry = 'crypto'
where industry like 'crypto%';

SELECT distinct industry
FROM staging_layoffs2;

select*
from staging_layoffs2;


-- looking at location 

SELECT distinct location
FROM staging_layoffs2
order by 1;

select*
from staging_layoffs2
where country like 'united states'
order by 1;

-- TRIM - TO REMOVE SPACES OR ANY DOTS

select  distinct country, trim(trailing '.'from country)
from staging_layoffs2
order by 1;

-- update



UPDATE staging_layoffs2 
SET country= trim(trailing '.' from country)
where country like 'united states%';


select*
from staging_layoffs2;

select `date`, 
str_to_date(`date`, '%M%D%Y')
from staging_layoffs2;

update staging_layoffs2
set `date` =str_to_date(`date`, '%m/%d/%Y');

-- CHECK THAT IT WORKED

select `DATE`
FROM staging_layoffs2;

ALTER table staging_layoffs2
MODIFY COLUMN `DATE` DATE;

SELECT*
FROM staging_layoffs2;


-- LETS SEE THE NULL ON TOTAL_LAID_OFF

SELECT*
FROM staging_layoffs2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL
OR INDUSTRY = '';


-- checking out airbnb as it had empty space

SELECT*
from staging_layoffs2
WHERE company ='Airbnb';

-- lets populate the table joining itself on company and location because there have to be the same

select *
from staging_layoffs2 as t1
join staging_layoffs2 as t2
  on t1. company =t2.company
  and t1.location =t2.location
  where (t1.industry is null or t1.industry ='')
  and t2.industry is not null;
  
  update staging_layoffs2 t1
  join staging_layoffs2 t2
  on t1. company =t2.company
  and t1.location =t2.location
  set  t1.industry = t2.industry
  where (t1.industry is null or t1.industry = '')
  and t2.industry  is not null;
  
  select *
  from staging_layoffs2
  where company = 'airbnb';
 

-- lets look at total_laid_off and percentage _laid_off

SELECT*
FROM staging_layoffs2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL

-- we cant populate it as we do not have the total laid off and secondly there might never have been a laid off from these industries, so we delete it

SELECT*
FROM staging_layoffs2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


DELETE
FROM staging_layoffs2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


-- check table
select*
FROM staging_layoffs2;

alter table staging_layoffs2
DROP column ROW_NUM;

SELECT*
FROM staging_layoffs2;
 


WITH duplicate_cte as
SELECT *,
ROW_NUMBER() OVER(
partition by company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
from staging_layoffs
)
select *
from duplicate_cte
where row_num > 1;


