USE `pandemic`;

SELECT '1. SQL-запит для перевірки кількості завантажених записів' AS ' ';
SELECT COUNT(*) AS total_records
FROM infectious_cases_original;

SELECT '2. SQL-запит для перевірки кількості мігрованих записів' AS ' ';
SELECT COUNT(*) AS total_records
FROM infectious_cases;

SELECT '3. SQL-запит для аналізу Number_rabies за Entity/Code' AS ' ';
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

SELECT '4. SQL-запит для перевірки дат' AS ' ';
SELECT
    year,
    year_start_date,
    today_date,
    years_difference
FROM infectious_cases
LIMIT 10;

SELECT '5. SQL-запит для перевірки функції calculate_years_difference' AS ' ';
SELECT calculate_years_difference(1996) AS years_from_1996;
