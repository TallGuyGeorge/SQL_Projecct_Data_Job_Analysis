/*
Question: What are the most optimal skills to learn (a skill that is both high demand and high paying)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Targeting skills that offer job security (in demand) and financial benefit,
    offering strategic insights for career development in data analysis.
*/

/*
This query can be put together using the last two created queries as CTEs
*/
WITH skills_demand AS(
    SELECT
        sd.skill_id,
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
        AND
        jpf.salary_year_avg IS NOT NULL
        AND
        job_work_from_home = TRUE
    GROUP BY
        sd.skill_id
), average_salary AS(
    SELECT
        sd.skill_id,
        sd.skills,
        ROUND(AVG(jpf.salary_year_avg), 0) AS average_salary
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
        AND
        job_work_from_home = TRUE
    GROUP BY
        sd.skill_id
)
SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    average_salary
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE
    demand_count > 10
ORDER BY
    average_salary DESC,
    demand_count DESC
LIMIT 25;

/*
That's a bit complicated, two CTES for four columns of data.
It can definitely be simplified.
*/

SELECT
    sd.skill_id,
    sd.skills,
    COUNT(sjd.job_id) AS demand_count,
    ROUND(AVG(jpf.salary_year_avg), 0) AS average_salary
FROM 
    job_postings_fact AS jpf
INNER JOIN
    skills_job_dim AS sjd ON jpf.job_id = sjd.job_id
INNER JOIN
    skills_dim AS sd ON sjd.skill_id = sd.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY
    sd.skill_id
HAVING
    COUNT(sjd.job_id) > 10
ORDER BY
    average_salary DESC,
    demand_count DESC
LIMIT 25;



