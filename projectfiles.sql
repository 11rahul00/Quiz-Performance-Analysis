CREATE DATABASE quiz;
USE quiz;

CREATE TABLE data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    question_id INT,
    points INT,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    username VARCHAR(50)
);

-- Q.1 List all distinct users and their stats (return user_name, total_submissions, points earned)
SELECT 
    username,
    COUNT(id) AS total_submissions,
    SUM(points) AS points_earned
FROM data
GROUP BY username
ORDER BY total_submissions DESC;

-- Q.2 Calculate the daily average points for each user.
-- each day
-- each user and their daily avg points
-- group by day and user
SELECT 
    DATE_FORMAT(submitted_at, '%d-%m') AS day,
    username,
    AVG(points) AS daily_avg_points
FROM data
GROUP BY day, username
ORDER BY username;

-- Q.3 Find the top 3 users with the most correct submissions for each day.
-- each day
-- most correct submissions
WITH daily_submissions AS (
    SELECT 
        DATE_FORMAT(submitted_at, '%d-%m') AS daily,
        username,
        SUM(CASE WHEN points > 0 THEN 1 ELSE 0 END) AS correct_submissions
    FROM data
    GROUP BY daily, username
),
users_rank AS (
    SELECT 
        daily,
        username,
        correct_submissions,
        DENSE_RANK() OVER (PARTITION BY daily ORDER BY correct_submissions DESC) AS rank1
    FROM daily_submissions
)
SELECT 
    daily,
    username,
    correct_submissions
FROM users_rank
WHERE rank1 <= 3;

-- Q.4 Find the top 5 users with the highest number of incorrect submissions.
SELECT 
    username,
    SUM(CASE WHEN points < 0 THEN 1 ELSE 0 END) AS incorrect_submissions
FROM data
GROUP BY username
ORDER BY incorrect_submissions DESC
LIMIT 5;

-- Q.5 Find the top 10 performers for each week.
WITH weekly_performance AS (
    SELECT 
        WEEK(submitted_at) AS week_no,
        username,
        SUM(points) AS total_points_earned,
        DENSE_RANK() OVER (PARTITION BY WEEK(submitted_at) ORDER BY SUM(points) DESC) AS rank2
    FROM data
    GROUP BY week_no, username
)
SELECT * FROM weekly_performance WHERE rank2 <= 10;






