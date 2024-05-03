# Project Data Analyst

# TLDR:
### Where to find the source tables?
The files are too big to fit the repo. They can be found [here](https://lukeb.co/sql_project_csvs).

### What software did you use to run your database?
- Database Management: [PostgreSQL](https://www.postgresql.org/)
- Query Creation: [Visual Studio Code](https://code.visualstudio.com/)


# Introduction
A huge thank you to [Luke Barousse](https://www.youtube.com/@LukeBarousse) and [Kelly Adams](https://www.kellyjadams.com/) for creating their course [SQL for Data Analytics - Learn SQL in 4 Hours](https://www.youtube.com/watch?v=7mz73uXD9DA&t=13285s). As an aspiring Data Analyst, this course has been an invaluable tool that gave me a chance to learn an improve my SQL skills, but also an introduction to GitHub and the ability to showcase my skills online.




# Background
When anyone begins the journey of entering the Data Analytics field, they are hit with a barrage of potential paths and options. In such a competitive field that requires so many skills, which ones are really make a difference when looking for a job? Which ones are companies actually looking for? Which will set you apart from others?

This project will focus on five questions:

1) What are the top paying Data Analyst jobs right now?
2) What skills are required to land these top roles?
3) What skills are the most requested for Data Analyst jobs?
4) What skills earn you the highest salary?
5) What skills are the most optimal to learn?

# Tools I used
In order to perform this analysis, I used the following tools:
- SQL: Allowed me to store my dataset, perform queries and unlock critical insights.
- [PostgreSQL](https://www.postgresql.org/): An open source relational database, allowing me to store and manage my databases.
- [Visual Studio Code](https://code.visualstudio.com/): Where I created and executed my queries.
- [Git](https://git-scm.com/) and [GitHub](https://github.com/): Where my project is hosted so I can share my progress and findings. It also helped me with version control.
- [ChatGPT](https://chat.openai.com/): This helped me to draw conclusions from my analysis and helped me produce results tables of my findings for this readme.

The source tables for my project were taken from Luke Barousse's website. They are unfortunately too large to store in my project folder, but you can download them [here](https://lukeb.co/sql_project_csvs).

# Analysis
As stated at the top of this page, I used this data to answer five questions. I will go through each one and look at the insights they provided.

### 1) What are the top paying Data Analyst jobs right now?

Starting off with a straightforward question. What is the end goal of being a Data Analyst. While money isn't everything, the highest paying jobs will provide me with key information on what is available and what companies are willing to pay for the best in the industry.

For this, my focus was jobs that were specifically Data Analyst positions and either based in London or were remote jobs. This criteria will be applied in most of the questions here, with the only exceptions being when we look at the job market as a whole.

```sql
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
```
As you can see from my code here. I took a few extra steps to ensure accuracy in my results. When I first ran the query, I noticed that while the job_title_short column listed some roles as Data Analysts, the role name in the job_title column. Therefore, I added an extra check to ensure that these jobs were definitely Data Analyst positions. I also converted the salary, which was listed in this database in USD, to GBP (1 USD = 0.8 GBP) to reflect my local currency and to get a better understanding as to what my potential earnings could be.

The results of this query are as follows:

| Job ID   | Job Title                              | Job Location | Schedule Type | Avg. Salary (USD) | Avg. Salary (GBP) | Posted Date | Company Name                     |
|----------|----------------------------------------|--------------|---------------|-------------------|-------------------|-------------|---------------------------------|
| 226942   | Data Analyst                           | Anywhere     | Full-time     | 650,000.0         | 520,000           | 2023-02-20  | Mantys                          |
| 99305    | Data Analyst, Marketing                | Anywhere     | Full-time     | 232,423.0         | 185,938           | 2023-12-05  | Pinterest Job Advertisements     |
| 1021647  | Data Analyst (Hybrid/Remote)           | Anywhere     | Full-time     | 217,000.0         | 173,600           | 2023-01-17  | Uclahealthcareers                |
| 168310   | Principal Data Analyst (Remote)        | Anywhere     | Full-time     | 205,000.0         | 164,000           | 2023-08-09  | SmartAsset                      |
| 731368   | Director, Data Analyst - HYBRID        | Anywhere     | Full-time     | 189,309.0         | 151,447           | 2023-12-07  | Inclusively                     |
| 310660   | Principal Data Analyst, AV Performance Analysis | Anywhere     | Full-time     | 189,000.0         | 151,200           | 2023-01-05  | Motional                        |
| 1749593  | Principal Data Analyst                 | Anywhere     | Full-time     | 186,000.0         | 148,800           | 2023-07-11  | SmartAsset                      |
| 387860   | ERM Data Analyst                       | Anywhere     | Full-time     | 184,000.0         | 147,200           | 2023-06-09  | Get It Recruit - Information Technology |
| 1781684  | DTCC Data Analyst                      | Anywhere     | Full-time     | 170,000.0         | 136,000           | 2023-10-06  | Robert Half                     |
| 1525451  | Manager, Data Analyst                  | Anywhere     | Full-time     | 167,000.0         | 133,600           | 2023-04-18  | Uber                            |


Using this table, i drew the following conclusions:
- While the highest salary was an incredible £520,000 per year, the rest of the top ten offered between £185,000 and £133,000 per year
- All of the top ten were remote jobs, which implies that in order to get the highest salary, I should focus on jobs offered outside of London.

### 2) What skills are required to land these top roles?

Using the results from my first query, I wanted to find out what skills were listed in the job listings as required skills for this job.

```SQL
WITH top_paying_jobs AS (
    SELECT
        jpf.job_id,
        jpf.job_title,
        jpf.salary_year_avg,
        ROUND(jpf.salary_year_avg * 0.8, 0) AS salary_year_avg_gbp,
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
    salary_year_avg DESC;
```

From looking at the results table, I could see plenty of instances of familiar skills, such as Python, SQL and Tableau. As the full table was difficult to produce more detailed insights than this, I exported the results into ChatGPT and asked it to run analysis on this. It produced the following answer:

```
"Let's analyze it to identify the most common skills needed for Data Analyst jobs. Here's what I've found:

SQL: SQL appears to be the most common skill across all the job postings. It's mentioned in almost every entry.
Python: Python is another highly requested skill, appearing frequently in the job postings.
Tableau: Tableau is also quite prevalent, indicating a need for data visualization skills.
Excel: Excel is mentioned in several job postings, suggesting that proficiency in Excel is often required for Data Analyst roles.
R: While not as common as SQL and Python, R is still mentioned in a significant number of job postings.
Other skills like Hadoop, Oracle, Azure, AWS, Git, Snowflake, Pandas, Numpy, and others are mentioned but with less frequency compared to the top five mentioned above.

Based on this analysis, if you're looking to pursue a career in data analysis, focusing on SQL, Python, Tableau, Excel, and possibly R could be beneficial. These skills seem to be in high demand across various Data Analyst job postings."
```

### 3) What skills are the most requested for Data Analyst jobs?

For our third question, we look to the Data Analyst job market as a whole. What skills are most popular for the average Data Analyst job?

```sql
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
LIMIT 5;
```
The results from this table are as follows:

| Skills   | Demand Count |
|----------|--------------|
| sql      | 71,048       |
| excel    | 51,986       |
| python   | 43,108       |
| tableau  | 36,229       |
| power bi | 30,440       |

As you can clearly see, SQL is by far the most requested skill for Data Analysts. Excel skills are also highly valued, followed by the ever-versitile Python and finally two examples of data visualisation software in Tableau and Power BI.
This gives me a very clear indicator of what is needed to know when being a Data Analyst, and what skills I should focus on next.

### 4) What skills earn you the highest salary?

This query finds the average salary for each skill listed in our dataset for Data Analyst jobs. Once we've learned our core Data Analyst skills, this query will help us to focus on what we could focus on learning next to boost our salary expectations:

```sql
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
```

| Skills     | Average Salary | Demand Count |
|------------|----------------|--------------|
| dplyr      | 196,250        | 2            |
| couchbase  | 160,515        | 1            |
| datarobot  | 155,486        | 1            |
| vmware     | 147,500        | 1            |
| golang     | 145,000        | 1            |
| dynamodb   | 140,000        | 2            |
| twilio     | 138,500        | 2            |
| perl       | 132,794        | 15           |
| bitbucket  | 128,600        | 5            |
| gitlab     | 122,020        | 5            |
| watson     | 121,838        | 3            |
| notion     | 116,710        | 5            |
| confluence | 113,220        | 53           |
| redis      | 112,725        | 3            |
| scala      | 112,184        | 38           |
| angular    | 111,693        | 9            |
| shell      | 111,473        | 35           |
| electron   | 111,175        | 2            |
| airflow    | 110,283        | 59           |
| plotly     | 110,049        | 21           |
| atlassian  | 109,999        | 12           |
| pytorch    | 109,902        | 7            |
| php        | 109,253        | 27           |
| unix       | 109,065        | 27           |
| seaborn    | 108,267        | 8            |


As we can see from this table, many of these skills are listed at the top because they don't appear on job listings very often. I can think of two main reasons for this:
- They are highly specialised skills - Being very complicated and requiring a lot of training.
- They are rarely used skills - Not many people have learned these skills so it is harder to find people with these skills.

### 5) What skills are the most optimal to learn?

The aim of this query is to find skills that are both popular and have a high average salary, thus finding a job with the best of both worlds. To achieve this, we have specified with a HAVING clause that a job will only be included in the results when there are more than 10 jobs that demand that skill.

```sql
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
```

The results are in:

| Skill     | Demand Count | Average Salary |
|-----------|--------------|----------------|
| go        | 27           | 115,320        |
| confluence| 11           | 114,210        |
| hadoop    | 22           | 113,193        |
| snowflake | 37           | 112,948        |
| azure     | 34           | 111,225        |
| bigquery  | 13           | 109,654        |
| aws       | 32           | 108,317        |
| java      | 17           | 106,906        |
| ssis      | 12           | 106,683        |
| jira      | 20           | 104,918        |
| oracle    | 37           | 104,534        |
| looker    | 49           | 103,795        |
| nosql     | 13           | 101,414        |
| python    | 236          | 101,397        |
| r         | 148          | 100,499        |
| redshift  | 16           | 99,936         |
| qlik      | 13           | 99,631         |
| tableau   | 230          | 99,288         |
| ssrs      | 14           | 99,171         |
| spark     | 13           | 99,077         |
| c++       | 11           | 98,958         |
| sas       | 63           | 98,902         |
| sql server| 35           | 97,786         |
| javascript| 20           | 97,587         |


From this query, we have learned that:
- Cloud based technologies are very much in demand and command salaries well in excess of $100,000
- Python, r and Tableu are a great mix of very in demand and very well paid.


# What I learned 

This project was incredibly helpful in my journey to be a data analyst. The main skills I gained using this were:
- SQL: While I am not new to SQL, I was able to put what I had into good practice as well adding to my existing knowledge base.
- Git and GitHub: I learned how to upload my project files, how others can collaborate on my projects and how I can share my projects with anyone.
- ChatGPT: I have made use of ChatGPT in this course, primarily for:
    - Analysis: Providing insights from complicated queries
    - Visualisation: Creating tables way quicker than I ever could


# Conclusions
