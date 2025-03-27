
SELECT 
    AVG(salary_year_avg) AS avg_yearly_salary,
    AVG(salary_hour_avg) AS hourly_avg_salary,
    job_posted_date::DATE AS job_date,
    job_schedule_type
FROM job_postings_fact
WHERE 
    job_posted_date >= '2023-06-02'  -- Ensures results start from June 2, 2023
GROUP BY 
    job_schedule_type, job_date
ORDER BY 
    job_date;


SELECT
    COUNT(*) AS month_count,  -- Counting the number of job postings
    EXTRACT(MONTH FROM job_posted_date) AS month,
    MIN(job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'WAT') AS first_posted_date
FROM job_postings_fact
GROUP BY EXTRACT(MONTH FROM job_posted_date)  -- Ensure the same expression in GROUP BY
ORDER BY month_count DESC;  -- Ordering by count of job postings


SELECT 
    company_dim.company_id, 
    company_dim.name AS company_name
FROM 
    company_dim
INNER JOIN job_postings_fact AS job_postings 
    ON company_dim.company_id = job_postings.company_id
WHERE 
    EXTRACT(QUARTER FROM job_postings.job_posted_date) = 2  -- Filter for Q2 (April - June)
    AND EXTRACT(YEAR FROM job_postings.job_posted_date) = 2023
GROUP BY 
    company_dim.company_id, company_dim.name
HAVING 
    COUNT(*) = COUNT(CASE WHEN job_postings.job_health_insurance = TRUE THEN 1 END)
ORDER BY company_name;    


SELECT 
    company_dim.company_id, 
    company_dim.name AS company_name
FROM 
    company_dim
INNER JOIN job_postings_fact AS job_postings 
    ON company_dim.company_id = job_postings.company_id
WHERE 
    EXTRACT(QUARTER FROM job_postings.job_posted_date) = 2
    AND EXTRACT(YEAR FROM job_postings.job_posted_date) = 2023
GROUP BY 
    company_dim.company_id, company_dim.name
HAVING 
    BOOL_AND(job_postings.job_health_insurance) -- Ensures all jobs have health insurance
ORDER BY company_name;


