
SELECT 
    job_id,
    job_title_short,
    company_id,
    salary_year_avg,
    CASE 
        WHEN salary_year_avg >= 120000 THEN 'High'
        WHEN salary_year_avg BETWEEN 70000 AND 119999 THEN 'Standard'
        WHEN salary_year_avg IS NOT NULL THEN 'Low'
        ELSE 'Unknown'
    END AS salary_category
FROM job_postings_fact
WHERE LOWER(job_title_short) LIKE '%data analyst%'  -- Filter for Data Analysis roles
ORDER BY salary_year_avg DESC;  -- Order from highest to lowest
