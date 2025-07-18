-- -----------------------------------------------------
-- Database Schema for Infectious Diseases System
-- Based on CSV dataset analysis
-- -----------------------------------------------------

DROP SCHEMA IF EXISTS `goit-rdb-fp`;
CREATE SCHEMA IF NOT EXISTS `goit-rdb-fp` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `goit-rdb-fp`;

-- -----------------------------------------------------
-- Table `infectious_cases`
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

