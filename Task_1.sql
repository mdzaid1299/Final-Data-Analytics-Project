-- Initial Table Setup
CREATE TABLE employee_data (
    emp_no INT PRIMARY KEY,
    gender VARCHAR(10),
    marital_status VARCHAR(20),
    age_band VARCHAR(20),
    age INT,
    department VARCHAR(50),
    education VARCHAR(50),
    education_field VARCHAR(50),
    job_role VARCHAR(50),
    business_travel VARCHAR(20),
    employee_count INT,
    attrition VARCHAR(10),
    attrition_label VARCHAR(20),
    job_satisfaction INT,
    active_employee INT
);

-- Data Import
COPY employee_data
FROM 'F:/datascience/Mohammad Zaid_CuvetteDs/Mohammad Zaid_Sql/Analyzing Employee Trends.csv'
DELIMITER ',' 
CSV HEADER;

-- 1. GENERAL EMPLOYEE OVERVIEW

-- Q1.1: What is the total number of employees in the dataset?
SELECT COUNT(*) AS total_employees
FROM employee_data;

-- Q1.2: What are the unique job roles and their employee counts?
SELECT job_role, COUNT(*) AS employee_count
FROM employee_data
GROUP BY job_role
ORDER BY employee_count DESC;

-- Q1.3: What is the percentage of male and female employees?
SELECT 
    gender, 
    COUNT(*) AS employee_count, 
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM employee_data)), 2) AS percentage
FROM employee_data
GROUP BY gender;

-- Q1.4: How many employees are in each age band?
SELECT age_band, COUNT(*) AS employee_count
FROM employee_data
GROUP BY age_band
ORDER BY employee_count DESC;

-- Q1.5: What are the ages of the youngest and oldest employees?
SELECT MIN(age) AS youngest_employee, MAX(age) AS oldest_employee
FROM employee_data;

-- Q1.6: What is the average age of employees?
SELECT ROUND(AVG(age), 2) AS average_age
FROM employee_data;

-- Q1.7: How many employees are in each education category?
SELECT education, COUNT(*) AS employee_count
FROM employee_data
GROUP BY education
ORDER BY employee_count DESC;

-- Q1.8: What are the education fields and their employee counts?
SELECT education_field, COUNT(*) AS employee_count
FROM employee_data
GROUP BY education_field
ORDER BY employee_count DESC;

-- Q1.9: How many employees travel frequently, rarely, or never?
SELECT business_travel, COUNT(*) AS employee_count
FROM employee_data
GROUP BY business_travel
ORDER BY employee_count DESC;

-- 2. ATTRITION ANALYSIS

-- Q2.1: What is the overall attrition rate?
SELECT 
    ROUND((SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS overall_attrition_rate
FROM employee_data;

-- Q2.2: How many current employees and ex-employees are there?
SELECT 
    attrition_label, 
    COUNT(*) AS employee_count
FROM employee_data
GROUP BY attrition_label;

-- Q2.3: What is the attrition rate for each department?
SELECT 
    department,
    ROUND((SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS attrition_rate
FROM employee_data
GROUP BY department
ORDER BY attrition_rate DESC;

-- Q2.4: What are the attrition rates for different job roles?
SELECT 
    job_role,
    ROUND((SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS attrition_rate
FROM employee_data
GROUP BY job_role
ORDER BY attrition_rate DESC;

-- Q2.5: Which age band has the highest attrition rate?
SELECT 
    age_band,
    ROUND((SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS attrition_rate
FROM employee_data
GROUP BY age_band
ORDER BY attrition_rate DESC
LIMIT 1;

-- Q2.6: What are the attrition rates by gender?
SELECT 
    gender,
    ROUND((SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS attrition_rate
FROM employee_data
GROUP BY gender;

-- Q2.7: How do attrition rates compare across job satisfaction levels?
SELECT 
    job_satisfaction,
    ROUND((SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS attrition_rate
FROM employee_data
GROUP BY job_satisfaction
ORDER BY job_satisfaction;

-- Q2.8: Which departments have employees leaving with low job satisfaction?
SELECT 
    department,
    job_satisfaction,
    COUNT(*) AS low_satisfaction_leavers
FROM employee_data
WHERE attrition = 'Yes' AND job_satisfaction IN (1, 2)
GROUP BY department, job_satisfaction
ORDER BY low_satisfaction_leavers DESC;

-- 3. JOB SATISFACTION ANALYSIS

-- Q3.1: What is the average job satisfaction score company-wide?
SELECT 
    ROUND(AVG(job_satisfaction), 2) AS avg_job_satisfaction
FROM employee_data;

-- Q3.2: What are the average job satisfaction scores for current vs ex-employees?
SELECT 
    attrition_label,
    ROUND(AVG(job_satisfaction), 2) AS avg_job_satisfaction
FROM employee_data
GROUP BY attrition_label;

-- Q3.3: Which department has the highest job satisfaction?
SELECT 
    department,
    ROUND(AVG(job_satisfaction), 2) AS avg_job_satisfaction
FROM employee_data
GROUP BY department
ORDER BY avg_job_satisfaction DESC
LIMIT 1;

-- Q3.4: How does job satisfaction vary by education level?
SELECT 
    education,
    ROUND(AVG(job_satisfaction), 2) AS avg_job_satisfaction
FROM employee_data
GROUP BY education
ORDER BY avg_job_satisfaction DESC;

-- Q3.5: Which job roles have the lowest satisfaction scores?
SELECT 
    job_role,
    ROUND(AVG(job_satisfaction), 2) AS avg_job_satisfaction
FROM employee_data
GROUP BY job_role
ORDER BY avg_job_satisfaction ASC
LIMIT 5;

-- Q3.6: How does travel frequency affect job satisfaction?
SELECT 
    business_travel,
    ROUND(AVG(job_satisfaction), 2) AS avg_job_satisfaction
FROM employee_data
GROUP BY business_travel
ORDER BY avg_job_satisfaction DESC;

-- Q3.7: What is the average job satisfaction by age band?
SELECT 
    age_band,
    ROUND(AVG(job_satisfaction), 2) AS avg_job_satisfaction
FROM employee_data
GROUP BY age_band
ORDER BY avg_job_satisfaction DESC;

-- Q3.8: How does marital status affect job satisfaction?
SELECT 
    marital_status,
    ROUND(AVG(job_satisfaction), 2) AS avg_job_satisfaction
FROM employee_data
GROUP BY marital_status
ORDER BY avg_job_satisfaction DESC;

-- Q3.9: Who are the top 5 most satisfied employees?
SELECT 
    emp_no,
    job_satisfaction
FROM employee_data
ORDER BY job_satisfaction DESC
LIMIT 5;

-- Q3.10: How do R&D, Sales, and HR compare in job satisfaction?
SELECT 
    department,
    ROUND(AVG(job_satisfaction), 2) AS avg_job_satisfaction
FROM employee_data
WHERE department IN ('R&D', 'Sales', 'HR')
GROUP BY department
ORDER BY avg_job_satisfaction DESC;

-- 4. DEPARTMENT-LEVEL ANALYSIS

-- Q4.1: How many employees are in each department?
SELECT 
    department,
    COUNT(*) AS employee_count
FROM employee_data
GROUP BY department
ORDER BY employee_count DESC;

-- Q4.2: What is the average age by department?
SELECT 
    department,
    ROUND(AVG(age), 2) AS avg_age
FROM employee_data
GROUP BY department
ORDER BY avg_age DESC;

-- Q4.3: What are the departmental attrition rates?
SELECT 
    department,
    ROUND((SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS attrition_rate
FROM employee_data
GROUP BY department
ORDER BY attrition_rate DESC;

-- Q4.4: What is the gender distribution in each department?
SELECT 
    department,
    gender,
    ROUND((COUNT(*) * 100.0) / SUM(COUNT(*)) OVER (PARTITION BY department), 2) AS gender_proportion
FROM employee_data
GROUP BY department, gender
ORDER BY department, gender_proportion DESC;

-- Q4.5: What is the most common job role in each department?
WITH role_rank AS (
    SELECT 
        department,
        job_role,
        COUNT(*) AS role_count,
        ROW_NUMBER() OVER (PARTITION BY department ORDER BY COUNT(*) DESC) AS rank
    FROM employee_data
    GROUP BY department, job_role
)
SELECT 
    department,
    job_role,
    role_count
FROM role_rank
WHERE rank = 1;

-- Q4.6: What proportion of employees travel frequently in each department?
SELECT 
    department,
    ROUND(AVG(CASE WHEN business_travel = 'Travel_Frequently' THEN 1 ELSE 0 END), 2) AS avg_frequent_travelers
FROM employee_data
GROUP BY department
ORDER BY avg_frequent_travelers DESC;

-- Q4.7: How many active employees are in each department?
SELECT 
    department,
    SUM(active_employee) AS active_employees
FROM employee_data
GROUP BY department
ORDER BY active_employees DESC;

-- Q4.8: How do attrition rates vary by department and travel frequency?
SELECT 
    department,
    business_travel,
    ROUND((SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS attrition_rate
FROM employee_data
GROUP BY department, business_travel
ORDER BY department, attrition_rate DESC;

-- Q4.9: Which departments have a majority of employees aged 35-44?
WITH age_band_analysis AS (
    SELECT 
        department,
        COUNT(*) AS employees_in_age_band,
        ROUND((COUNT(*) * 100.0) / SUM(COUNT(*)) OVER (PARTITION BY department), 2) AS proportion_in_age_band
    FROM employee_data
    WHERE age_band = '35 - 44'
    GROUP BY department
)
SELECT 
    department,
    employees_in_age_band,
    proportion_in_age_band
FROM age_band_analysis
WHERE proportion_in_age_band > 50
ORDER BY proportion_in_age_band DESC;