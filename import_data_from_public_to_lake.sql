CREATE TABLE `jardim-data.dl_github.commits` AS
WITH repos AS (
  SELECT
    *
  FROM
    `bigquery-public-data.github_repos.commits` ,
    UNNEST(repo_name) AS repo_name_flat  
)
SELECT * 
FROM repos 
WHERE repo_name_flat IN (          
          'apache/airflow',
          'tensorflow/tensorflow',
          'kubernetes/kubernetes',
          'pandas-dev/pandas',
          'microsoft/vscode',          
          'hashicorp/terraform', 
          'facebook/react'          
          )