
WITH remote_job_skills AS (
SELECT
    skill_id,
    count(*) AS skills_count
FROM
    skills_job_dim AS skills_to_job
INNER JOIN job_postings_fact AS job_postings ON skills_to_job.job_id = job_postings.job_id
WHERE
    job_postings.job_work_from_home = TRUE AND
    job_postings.job_title_short = 'Data Analyst'
GROUP BY
    skill_id
)
SELECT
    skills.skill_id,
    skills AS skill_name,
    skills_count 
FROM
    remote_job_skills          
INNER JOIN skills_dim AS skills ON remote_job_skills.skill_id = skills.skill_id
ORDER BY
    skills_count
LIMIT 5;    