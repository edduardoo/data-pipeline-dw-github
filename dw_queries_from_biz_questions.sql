-- what was the repo with more commits in a given month? 
SELECT 
      r.repo_name, 
      d.month,
      SUM(c.commits_count) AS commits_count
FROM
      `jardim-data.dw_github.commits_by_date` c
      JOIN `jardim-data.dw_github.repos` r ON c.repo_id=r.id
      JOIN `jardim-data.dw_github.dates` d ON c.date_id=d.date
WHERE d.month = '2022-09-01'
GROUP BY 1, 2
ORDER BY 3 DESC


-- what was the month with more commits for a given repo in the last year?
SELECT       
      d.month,
      SUM(c.commits_count) AS commits_count
FROM
      `jardim-data.dw_github.commits_by_date` c
      JOIN `jardim-data.dw_github.repos` r ON c.repo_id=r.id
      JOIN `jardim-data.dw_github.dates` d ON c.date_id=d.date
WHERE 
   d.month >= '2021-09-01'
   AND r.repo_name = 'pandas-dev/pandas'
GROUP BY month
ORDER BY 2 DESC

-- what are the main contributors for a given repo in the last year?
SELECT       
      u.name,
      SUM(c.commits_count) AS commits_count
FROM
      `jardim-data.dw_github.commits_by_date` c
      JOIN `jardim-data.dw_github.repos` r ON c.repo_id=r.id
      JOIN `jardim-data.dw_github.dates` d ON c.date_id=d.date
      JOIN `jardim-data.dw_github.users` u ON c.author_id=u.id
WHERE 
   d.month >= '2021-09-01'
   AND r.repo_name = 'tensorflow/tensorflow'
GROUP BY name
ORDER BY 2 DESC