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
I have made a few changes to the original query from the course:
- Changed the job location filter to also include London, UK as a location as that is where I am based
- Added an extra check in the job title as I saw that some jobs listed in job_title_short are listed as Data Analyst jobs, but in the job_title column they can be listed as other roles such as Data Scientist.
- Added a column with the salary converted from USD to GBP at a rough conversion rate of 1 USD = 0.8 GBP. 
*/

SELECT
    jpf.job_id,
    jpf.job_title,
    jpf.job_location,
    jpf.job_schedule_type,
    jpf.salary_year_avg,
    ROUND(jpf.salary_year_avg * 0.8, 0) AS salary_year_avg_gbp,
    jpf.job_posted_date::DATE,
    cd.name AS company_name
FROM
    job_postings_fact AS jpf
LEFT JOIN
    company_dim AS cd ON jpf.company_id = cd.company_id
WHERE
    jpf.job_title_short = 'Data Analyst'
    AND
    jpf.job_title LIKE '%Data Analyst%'
    AND
    jpf.job_location IN('Anywhere', 'London, UK')
    AND
    jpf.salary_year_avg IS NOT NULL
ORDER BY
    jpf.salary_year_avg DESC
LIMIT 10;


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