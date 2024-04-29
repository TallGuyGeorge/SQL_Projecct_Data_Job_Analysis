/*
Question: What skills are required for the top paying data analyst jobs?
- Use the top 10 highest paying Data Analyst jobs from the first query
- Add the specific skills required for these roles
- We will see a detailed look at which skills correlate closest to high paying jobs,
    helping job seekers to understand which skills to develop to earn these top salaries.
*/


WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
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
)

SELECT 
    top_paying_jobs.*,
    skills
FROM
    top_paying_jobs
INNER JOIN skills_job_dim
    ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC


/*
ChatGPT's response to a request to analyse:

Associate Director - Data Insights at AT&T:
Skills: SQL, Python, R, Azure, Databricks, AWS, Pandas, PySpark, Jupyter, Excel, Tableau, Power BI, PowerPoint
Data Analyst, Marketing at Pinterest Job Advertisements:
Skills: SQL, Python, R, Hadoop, Tableau
Data Analyst (Hybrid/Remote) at UCLA Health Careers:
Skills: SQL, Crystal, Oracle, Tableau, Flow
Principal Data Analyst (Remote) at SmartAsset:
Skills: SQL, Python, Go, Snowflake, Pandas, NumPy, Excel, Tableau, GitLab
Director, Data Analyst - Hybrid at Inclusively:
Skills: SQL, Python, Azure, AWS, Oracle, Snowflake, Tableau, Power BI, SAP, Jenkins, Bitbucket, Atlassian, Jira, Confluence
Principal Data Analyst, AV Performance Analysis at Motional:
Skills: SQL, Python, R, Git, Bitbucket, Atlassian, Jira, Confluence
Principal Data Analyst at SmartAsset:
Skills: SQL, Python, Go, Snowflake, Pandas, NumPy, Excel, Tableau, GitLab
ERM Data Analyst at Get It Recruit - Information Technology:
Skills: SQL, Python, R

Across these high-paying Data Analyst roles, SQL and Python skills are consistently emphasized.
Other important skills include proficiency in data visualization tools like Tableau,
familiarity with cloud platforms such as Azure and AWS, expertise in data manipulation libraries like Pandas and NumPy, 
as well as knowledge of specific databases or platforms like Snowflake and Oracle. 
Additionally, proficiency in version control tools like Git/GitLab and collaboration platforms like
Jira and Confluence is also valued.
*/