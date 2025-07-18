-- -----------------------------------------------------
-- Database Analysis Queries for Infectious Diseases Data
-- -----------------------------------------------------

-- 1. SQL-запит для перевірки кількості завантажених записів
SELECT COUNT(*) AS total_records
FROM infectious_cases_original; 

-- 2. SQL-запит для перевірки кількості мігрованих записів
SELECT COUNT(*) AS total_records
FROM infectious_cases; 
