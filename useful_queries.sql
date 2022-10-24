-- files by repo
SELECT r.repo_name, COUNT(1) AS files
FROM 
      `jardim-data.rel_github.files` f
      JOIN `jardim-data.rel_github.repos` r ON f.repo_id=r.id
GROUP BY 1 ORDER BY 2 DESC

-- commits by repo
SELECT r.repo_name, COUNT(1) AS commits
FROM 
      `jardim-data.rel_github.commits` c
      JOIN `jardim-data.rel_github.repos` r ON c.repo_id=r.id
GROUP BY 1 ORDER BY 2 DESC


-- commits by file
SELECT f.path, r.repo_name, COUNT(1) AS commits
FROM 
      `jardim-data.rel_github.commits_files` cf
      JOIN `jardim-data.rel_github.files` f ON cf.file_id=f.id
      JOIN `jardim-data.rel_github.repos` r ON f.repo_id=r.id 
GROUP BY 1, 2 ORDER BY 3 DESC