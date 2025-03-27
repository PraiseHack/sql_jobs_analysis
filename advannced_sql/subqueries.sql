
-- Subquery
SELECT name 
FROM company_dim
WHERE company_id IN (
    SELECT 
        DISTINCT company_id 
    FROM job_postings_fact
);


-- CTE
WITH DataAnalystJobs AS (
    SELECT 
        company_id, 
        job_title_short, 
        salary_year_avg
    FROM job_postings_fact
    WHERE 
        job_title_short = 'Data Analyst'
)
SELECT 
    company_id, 
    AVG(salary_year_avg) AS avg_salary
FROM DataAnalystJobs
GROUP BY 
    company_id;


-- Subquery 2
SELECT 
    name AS company_name
FROM company_dim
WHERE company_id IN (
    SELECT 
        DISTINCT company_id 
    FROM job_postings_fact
    WHERE 
        job_title_short = 'Data Analyst'
);


-- CTE 2

WITH CategorizedSalaries AS (
    SELECT 
        company_id,
        job_title,
        salary_year_avg,
        CASE 
            WHEN salary_year_avg < 50000 THEN 'Low'
            WHEN salary_year_avg BETWEEN 50000 AND 90000 THEN 'Standard'
            ELSE 'High'
        END AS salary_category
    FROM job_postings_fact
    WHERE job_title_short = 'Data Analyst'
)
SELECT 
    salary_category, 
    COUNT(*) AS job_count
FROM CategorizedSalaries
GROUP BY salary_category
ORDER BY job_count DESC;

--CTE 3
WITH AvgSalaryByCompany AS (
    SELECT 
        company_id, 
        AVG(salary_year_avg) AS avg_salary
    FROM job_postings_fact
    WHERE job_title_short = 'Data Analyst'
    GROUP BY company_id
)
SELECT 
    c.name AS company_name, 
    a.avg_salary
FROM AvgSalaryByCompany a
JOIN company_dim c ON a.company_id = c.company_id
ORDER BY a.avg_salary DESC


-- CTE 4

WITH company_job_count AS (
    SELECT
        company_id,
        count(*) AS total_jobs
    FROM
        job_postings_fact
    GROUP BY
        company_id        
)
SELECT
    company_dim.name AS company_name,
    company_job_count.total_jobs
FROM
    company_dim 
LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
ORDER BY 
 total_jobs DESC        
