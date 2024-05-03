/*
Question: What are the top skills based on salary?
- Look for the average salary associated with each skill for Data Analyst positions
- This will focus on roles with specified salaries, regardless of location
- It will reveal how different skills impact salary levels for Data Analysts and helps identify
    the most financially rewarding skills to acquire or improve.
*/

SELECT
    sd.skills,
    ROUND(AVG(jpf.salary_year_avg), 0) AS average_salary
    COUNT(jpf.job_id) AS demand_count
FROM
    job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Analyst'
    AND
    jpf.job_title LIKE '%Data Analyst%'
    AND
    jpf.salary_year_avg IS NOT NULL
GROUP BY
    sd.skills
ORDER BY
    average_salary DESC
LIMIT 25;

/*
The top 25 average paying skills are shown here. It tells us that the highest paying skills are mainly web 
development skills and this list excludes common skills such as SQL and Python as their average salary is
brought down by appearing across all skills
*/
