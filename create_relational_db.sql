------------------------------------------------------------------------------------------------------
---------------- CREATING TABLE users ----------------------------------------------------------------
CREATE OR REPLACE TABLE `jardim-data.rel_github.users` AS
WITH users_temp AS (
      SELECT                  
            TO_HEX(MD5(author.email)) AS id,
            author.name AS name, 
            author.email AS email,
            ROW_NUMBER() OVER (PARTITION BY author.email ORDER BY author.time_sec DESC) AS version
      FROM `jardim-data.dl_github.commits` 
)
SELECT * EXCEPT(version) FROM users_temp WHERE version = 1

------------------------------------------------------------------------------------------------------
---------------- CREATING TABLE repos ----------------------------------------------------------------
CREATE OR REPLACE TABLE `jardim-data.rel_github.repos` AS
SELECT 
      TO_HEX(MD5(repo_name)) AS id, 
      repo_name, 
      license
FROM `bigquery-public-data.github_repos.licenses`
WHERE repo_name IN (          
          'apache/airflow',
          'tensorflow/tensorflow',
          'kubernetes/kubernetes',
          'pandas-dev/pandas',
          'microsoft/vscode',          
          'hashicorp/terraform', 
          'facebook/react')


------------------------------------------------------------------------------------------------------
---------------- CREATING TABLE files  ---------------------------------------------------------------
CREATE OR REPLACE TABLE `jardim-data.rel_github.files` AS
WITH commits_files AS ( 
  SELECT
        commit,                         
        TO_HEX(MD5(CONCAT(repo_name_flat, d.new_path))) AS id,
        TO_HEX(MD5(repo_name_flat)) AS repo_id,
        d.new_path AS path        
  FROM `jardim-data.dl_github.commits`,
       UNNEST(difference) AS d  
)
SELECT DISTINCT id, repo_id, path FROM commits_files

------------------------------------------------------------------------------------------------------
---------------- CREATING TABLE commits --------------------------------------------------------------
CREATE OR REPLACE TABLE `jardim-data.rel_github.commits` AS
SELECT
      commit AS id,         
      TO_HEX(MD5(author.email)) AS author_id,
      TO_HEX(MD5(repo_name_flat)) AS repo_id,
      TIMESTAMP_SECONDS(author.time_sec) as created_at,
      author.tz_offset,                       
FROM `jardim-data.dl_github.commits`

------------------------------------------------------------------------------------------------------
---------------- CREATING TABLE commits_files --------------------------------------------------------
CREATE OR REPLACE TABLE `jardim-data.rel_github.commits_files` AS
WITH commits_files AS ( 
  SELECT
        commit,                         
        TO_HEX(MD5(CONCAT(repo_name_flat, d.new_path))) AS file_id,                
  FROM `jardim-data.dl_github.commits`,
       UNNEST(difference) AS d  
)
SELECT DISTINCT commit AS commit_id, file_id FROM commits_files



