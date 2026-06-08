-- Data Cleaning

SELECT *
FROM layoffs;

-- 1. Remove Duplicates means remove double names in the columns which are same as it is the exact copy of the other
-- 2. Standardize the Data MEANS assigning the correct data type to the columns in the table for eg. DATE should be assigned with date data type, layoffs should be assigned with int data type and so on
-- 3. Look at null values or blank values
-- 4. Remove any columns or rows

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
 FROM layoffs;
 
 SELECT *,
 ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`)AS row_num
 FROM layoffs_staging;
 
 WITH duplicate_cte AS 
 (
 SELECT *,
 ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`)AS row_num
 FROM layoffs_staging
 )
 DELETE 
 FROM duplicate_cte 
 WHERE row_num>1;
 
 CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2
WHERE row_num>1; 
 
 INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;
 
 
 
 
 
 SELECT * 
 FROM duplicate_cte
 WHERE row_num>1;
 
--  SELECT *
--  FROM layoffs_staging
--  WHERE company='Casper';
--  
-- DELETE
--  FROM duplicate_cte
--  WHERE row_num>1;
--  
-- SELECT * 
--  FROM duplicate_cte
--  WHERE row_num>1; 

SELECT *
FROM layoffs_staging2
WHERE row_num>1; 

SELECT *
FROM layoffs_staging
WHERE row_num>1; 

DELETE
FROM layoffs_staging2
WHERE row_num>1;

SELECT *
FROM layoffs_staging2;

-- Standardizing Data

SELECT company,TRIM(company)
FROM layoffs_staging2;
 
 UPDATE layoffs_staging2
 SET company=TRIM(company);
 
 SELECT DISTINCT industry
 FROM layoffs_staging2
 ORDER BY 1;
 
 SELECT * 
 FROM layoffs_staging2
 WHERE industry LIKE 'Crypto%';
 
 UPDATE layoffs_staging2
 SET industry='Crypto'
 WHERE industry LIKE 'Crypto%';
 
 SELECT * 
 FROM layoffs_staging2
 WHERE industry LIKE 'Crypto%';
 
 SELECT DISTINCT industry
 FROM layoffs_staging2;
 
 SELECT *
 FROM layoffs_staging2
 WHERE industry LIKE 'Fin%';
 
 UPDATE layoffs_staging2 
 SET industry='Finance' 
 WHERE industry LIKE 'Fin%';
 
 SELECT *
 FROM layoffs_staging2;
 
 SELECT DISTINCT country
 FROM layoffs_staging2
 ORDER BY country;
 
 SELECT *
 FROM layoffs_staging2
 WHERE country LIKE 'United States%';
 
 UPDATE layoffs_staging2
 SET country ='United States'
 WHERE country LIKE 'United States%';
 
 SELECT DISTINCT country 
 FROM layoffs_staging2
 ORDER BY country;
 
 SELECT `date`
 FROM layoffs_staging2;
 
 SELECT `date`,
 STR_TO_DATE(`date`,'%m/%d/%Y')
 FROM layoffs_staging2;
 
 UPDATE layoffs_staging2
 SET `date`=STR_TO_DATE(`date`,'%m/%d/%Y');
 
 SELECT date
 FROM layoffs_staging2;
 
 ALTER TABLE layoffs_staging2
 MODIFY `date` DATE;
 
 SELECT *
 FROM layoffs_staging2
 WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT DISTINCT industry
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE industry=NULL 
OR industry='';

SELECT *
FROM layoffs_staging2
WHERE company='Airbnb';

UPDATE layoffs_staging2
SET industry='Travel'
WHERE company LIKE 'Airbnb';

UPDATE layoffs_staging2
SET industry=NULL 
WHERE industry='';

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company=t2.company 
AND t1.location=t2.location
WHERE (t1.industry IS NULL 
OR t1.industry='')
AND t2.industry IS NOT NULL;


UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company=t2.company 
SET t1.industry=t2.industry
WHERE (t1.industry IS NULL )
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';

SELECT *
 FROM layoffs_staging2
 WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


DELETE
FROM layoffs_staging2
 WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP row_num;