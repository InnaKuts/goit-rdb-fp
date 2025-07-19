-- -----------------------------------------------------
-- Database Schema for Infectious Diseases System
-- Based on CSV dataset analysis
-- -----------------------------------------------------

DROP SCHEMA IF EXISTS `pandemic`;
CREATE SCHEMA IF NOT EXISTS `pandemic` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `pandemic`;

-- -----------------------------------------------------
-- Table `infectious_cases_original`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `infectious_cases_original`;
CREATE TABLE IF NOT EXISTS `infectious_cases_original` (
  `entity` VARCHAR(100) NOT NULL,
  `code` VARCHAR(10) NULL,
  `year` INT NOT NULL,
  `number_yaws` DECIMAL(12,2) NULL,
  `polio_cases` DECIMAL(12,2) NULL,
  `cases_guinea_worm` DECIMAL(12,2) NULL,
  `number_rabies` DECIMAL(12,2) NULL,
  `number_malaria` DECIMAL(12,2) NULL,
  `number_hiv` DECIMAL(12,2) NULL,
  `number_tuberculosis` DECIMAL(12,2) NULL,
  `number_smallpox` DECIMAL(12,2) NULL,
  `number_cholera_cases` DECIMAL(12,2) NULL
);

-- -----------------------------------------------------
-- Load data from CSV file
-- -----------------------------------------------------

-- Load infectious cases data
LOAD DATA LOCAL INFILE 'data/infectious_cases.csv' 
INTO TABLE `infectious_cases_original` 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES
(`entity`, `code`, `year`, @number_yaws, @polio_cases, @cases_guinea_worm, 
 @number_rabies, @number_malaria, @number_hiv, @number_tuberculosis, 
 @number_smallpox, @number_cholera_cases)
SET 
  `number_yaws` = NULLIF(@number_yaws, ''),
  `polio_cases` = NULLIF(@polio_cases, ''),
  `cases_guinea_worm` = NULLIF(@cases_guinea_worm, ''),
  `number_rabies` = NULLIF(@number_rabies, ''),
  `number_malaria` = NULLIF(@number_malaria, ''),
  `number_hiv` = NULLIF(@number_hiv, ''),
  `number_tuberculosis` = NULLIF(@number_tuberculosis, ''),
  `number_smallpox` = NULLIF(@number_smallpox, ''),
  `number_cholera_cases` = NULLIF(@number_cholera_cases, '');

-- -----------------------------------------------------
-- Normalized Tables
-- -----------------------------------------------------

-- Table `entities` - stores unique entity-code pairs
DROP TABLE IF EXISTS `entities`;
CREATE TABLE IF NOT EXISTS `entities` (
  `entity_id` INT NOT NULL AUTO_INCREMENT,
  `entity` VARCHAR(100) NOT NULL,
  `code` VARCHAR(10) NULL,
  PRIMARY KEY (`entity_id`),
  UNIQUE KEY `uk_entity_code` (`entity`, `code`)
);

-- Table `infectious_cases` - normalized cases data
DROP TABLE IF EXISTS `infectious_cases`;
CREATE TABLE IF NOT EXISTS `infectious_cases` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `entity_id` INT NOT NULL,
  `year` INT NOT NULL,
  `number_yaws` DECIMAL(12,2) NULL,
  `polio_cases` DECIMAL(12,2) NULL,
  `cases_guinea_worm` DECIMAL(12,2) NULL,
  `number_rabies` DECIMAL(12,2) NULL,
  `number_malaria` DECIMAL(12,2) NULL,
  `number_hiv` DECIMAL(12,2) NULL,
  `number_tuberculosis` DECIMAL(12,2) NULL,
  `number_smallpox` DECIMAL(12,2) NULL,
  `number_cholera_cases` DECIMAL(12,2) NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_entity_year` (`entity_id`, `year`),
  FOREIGN KEY (`entity_id`) REFERENCES `entities` (`entity_id`)
);

-- -----------------------------------------------------
-- Data Migration
-- -----------------------------------------------------

-- Populate entities table with unique entity-code pairs
INSERT INTO entities (entity, code)
SELECT DISTINCT entity, code 
FROM infectious_cases_original;

-- Migrate data to normalized infectious_cases table
INSERT INTO infectious_cases (
  entity_id, year, 
  number_yaws, polio_cases, cases_guinea_worm,
  number_rabies, number_malaria, number_hiv,
  number_tuberculosis, number_smallpox, number_cholera_cases
)
SELECT 
  e.entity_id, o.year,
  o.number_yaws, o.polio_cases, o.cases_guinea_worm,
  o.number_rabies, o.number_malaria, o.number_hiv,
  o.number_tuberculosis, o.number_smallpox, o.number_cholera_cases
FROM infectious_cases_original o
JOIN entities e ON o.entity = e.entity AND COALESCE(o.code, '') = COALESCE(e.code, '');

-- -----------------------------------------------------
-- Add Date Calculation Columns
-- -----------------------------------------------------

-- Add column for January 1st date
ALTER TABLE infectious_cases
ADD COLUMN year_start_date DATE NULL,
ADD COLUMN today_date DATE NULL,
ADD COLUMN years_difference INT NULL;

SET @current_date = CURDATE();

UPDATE infectious_cases 
SET 
    year_start_date = STR_TO_DATE(CONCAT(year, '-01-01'), '%Y-%m-%d'),
    today_date = @current_date,
    years_difference = TIMESTAMPDIFF(YEAR, year_start_date, @current_date);

-- -----------------------------------------------------
-- Create Function for Year Difference Calculation
-- -----------------------------------------------------

DELIMITER //

CREATE FUNCTION calculate_years_difference(input_year INT) 
RETURNS INT
NO SQL
BEGIN
    DECLARE input_date DATE;
    SET input_date = STR_TO_DATE(CONCAT(input_year, '-01-01'), '%Y-%m-%d');
    RETURN TIMESTAMPDIFF(YEAR, input_date, CURDATE());
END //

DELIMITER ;
