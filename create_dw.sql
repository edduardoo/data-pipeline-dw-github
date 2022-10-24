------------------------------------------------------------------------------------------------------
---------------- CREATING TABLE dates ----------------------------------------------------------------
CREATE OR REPLACE TABLE `jardim-data.dw_github.dates` AS 
WITH min_max_dates AS (
      SELECT 
            MIN(DATE(created_at)) min_date, 
            MAX(DATE(created_at)) max_date
      FROM 
            `jardim-data.rel_github.commits`
), 
dates AS (
      SELECT day
      FROM UNNEST(
            GENERATE_DATE_ARRAY((SELECT min_date FROM min_max_dates), 
                                (SELECT max_date FROM min_max_dates), 
                                INTERVAL 1 DAY)
            ) as day
)
SELECT 
      day AS date,
      DATE_TRUNC(day, MONTH) AS month,
      FORMAT_DATETIME("%B", DATETIME(day)) AS month_name, 
      DATE_TRUNC(day, WEEK) AS first_day_of_week,
      EXTRACT(DAYOFWEEK FROM day) AS day_of_week,
      FORMAT_DATE('%A', day) AS day_of_week_name,
FROM dates


------------------------------------------------------------------------------------------------------
---------------- CREATING TABLE repos ----------------------------------------------------------------
-- TODO: implement slowly changing dimension
CREATE OR REPLACE TABLE `jardim-data.dw_github.repos` AS 
SELECT * 
FROM 
      `jardim-data.rel_github.repos`


------------------------------------------------------------------------------------------------------
---------------- CREATING TABLE users ----------------------------------------------------------------
-- TODO: implement slowly changing dimension
CREATE OR REPLACE TABLE `jardim-data.dw_github.users` AS 
SELECT * 
FROM 
      `jardim-data.rel_github.users`