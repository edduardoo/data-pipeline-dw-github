-- commits_by_contributor_last_year: abstracts the complexity of generating a sparse result set for contributions by month
CREATE OR REPLACE VIEW `jardim-data.dw_github.commits_by_contributor_last_year` AS
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
         u.name AS contributor,
         SUM(c.commits_count) AS commits_count
   FROM
         `jardim-data.dw_github.commits_by_date` c
         JOIN `jardim-data.dw_github.repos` r ON c.repo_id=r.id         
         JOIN `jardim-data.dw_github.users` u ON c.author_id=u.id         
   GROUP BY DATE_TRUNC(c.date_id, MONTH), contributor
),
cross_user_months AS (
   SELECT m.month, c.contributor
   FROM months m
        CROSS JOIN (SELECT DISTINCT contributor FROM commits_by_user_month) AS c
)
SELECT
   crs.month, 
   crs.contributor, 
   COALESCE(com.commits_count, 0) AS commits_count
FROM 
   cross_user_months crs
   LEFT JOIN commits_by_user_month com ON crs.month=com.month AND crs.contributor=com.contributor
