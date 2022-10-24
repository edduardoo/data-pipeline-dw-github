CREATE OR REPLACE TABLE FUNCTION `jardim-data.dw_github.monthly_commits_by_contributor`(par_contributor STRING) AS
WITH months AS (
   SELECT DISTINCT month
   FROM `jardim-data.dw_github.dates`
   WHERE
      month >= DATE_SUB(DATE_TRUNC(CURRENT_DATE, MONTH), INTERVAL 1 YEAR)
   ORDER BY month
),
commits_by_user_month AS (
   SELECT       
         DATE_TRUNC(c.date_id, MONTH) AS month,         
         SUM(c.commits_count) AS commits_count
   FROM
         `jardim-data.dw_github.commits_by_date` c
         JOIN `jardim-data.dw_github.repos` r ON c.repo_id=r.id         
         JOIN `jardim-data.dw_github.users` u ON c.author_id=u.id
   WHERE
         u.name = par_contributor
   GROUP BY DATE_TRUNC(c.date_id, MONTH)
)
SELECT
   m.month,
   COALESCE(com.commits_count, 0) AS commits_count
FROM 
   months m
   LEFT JOIN commits_by_user_month com ON m.month=com.month