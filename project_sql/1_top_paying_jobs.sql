/*
Question: What are the top-paying data analyst jobs?
- Identify the top 10 highest-paying Data Analyst roles that are available remotely.
- Focus on job postings with specified salaries (remove nulls).
- Why? Highlight the top-paying opportunities for Data Analysts
*/

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date::DATE,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst'
    AND
    job_location = 'Anywhere'
    AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;

/*
The only modification I need to make to tailor this query to my own needs is to also include jobs that are London based.
As the highest paid London based job is only the 11th highest in this list, it didn't affect the final results table.
*/

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date::DATE,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst'
    AND
    job_location IN('Anywhere', 'London, UK')
    AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10


-- What's the yearly salary of the top 10 highest-paying Data Analyst jobs in London, UK in GBP?
SELECT jpf.job_title, cd.name, ROUND(jpf.salary_year_avg * 0.8, 0) AS salary_year_avg_gbp
FROM public.job_postings_fact AS jpf
JOIN public.company_dim as cd
    ON jpf.company_id = cd.company_id
WHERE jpf.job_location = 'London, UK'
AND jpf.job_title_short = 'Data Analyst'
AND jpf.job_title LIKE '%Data Analyst%'
AND jpf.salary_year_avg IS NOT NULL
ORDER BY jpf.salary_year_avg DESC
LIMIT 10;