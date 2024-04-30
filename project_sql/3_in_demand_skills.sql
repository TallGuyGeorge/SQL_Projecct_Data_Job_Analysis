/*
Question: What are the most in-demand skills for data analysts?
- Join job postings to inner join table similar to query 2
- Identify the top five in-demand skills for data analysts
- Focus on all job postings to get a picture for in demand skills for the whole market
*/

SELECT
    sd.skills,
    COUNT(sjd.job_id) AS demand_count
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
GROUP BY
    sd.skills
ORDER BY
    demand_count DESC
LIMIT 5

/*
This shows that the five most in demand skills across the whole Data Analyst job market are:
- SQL
- Excel
- Python
- Tableau
- Power BI
*/