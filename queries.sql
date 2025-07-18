-- -----------------------------------------------------
-- Database Analysis Queries for Infectious Diseases Data
-- -----------------------------------------------------

-- 1. SQL-запит для перевірки кількості завантажених записів
SELECT COUNT(*) AS total_records
FROM infectious_cases_original;

-- 2. SQL-запит для перевірки кількості мігрованих записів
SELECT COUNT(*) AS total_records
FROM infectious_cases;

-- 3. SQL-запит для аналізу Number_rabies за Entity/Code
SELECT 
    e.entity,
    e.code,
    AVG(ic.number_rabies) AS avg_rabies,
    MIN(ic.number_rabies) AS min_rabies,
    MAX(ic.number_rabies) AS max_rabies,
    SUM(ic.number_rabies) AS total_rabies
FROM infectious_cases ic
JOIN entities e ON ic.entity_id = e.entity_id
WHERE ic.number_rabies IS NOT NULL
GROUP BY e.entity, e.code
ORDER BY avg_rabies DESC
LIMIT 10; 

-- 4. SQL-запит для перевірки дат
SELECT
    year,
    year_start_date,
    today_date,
    years_difference
FROM infectious_cases
LIMIT 10;
