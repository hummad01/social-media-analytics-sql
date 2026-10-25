-- ==============================================================
-- SQL Mini Project: Social Media Analytics
-- Dataset : Social_Media
-- Analyst: Mohammad Hummad Siddiqui
-- ==============================================================

USE Social_Media;

-- ==============================================================
-- Q1. Most Active Users (Posts + Comments)
-- ==============================================================
-- Objective : Find top 10 users based on combined number of posts and comments.
-- Business question:
-- "Which users are most active when we count both their posts and their comments?"
-- Write your query below 👇
-- --------------------------------------------------------------
-- Your Code ...

SELECT 
    u.user_id,
    u.username,
    u.country,
    COUNT(DISTINCT p.post_id)    AS total_posts,
    COUNT(DISTINCT c.comment_id) AS total_comments,
    COUNT(DISTINCT p.post_id) + COUNT(DISTINCT c.comment_id) AS total_activity
FROM users u
LEFT JOIN posts    p ON u.user_id = p.user_id
LEFT JOIN comments c ON u.user_id = c.user_id
GROUP BY u.user_id, u.username, u.country
ORDER BY total_activity DESC
LIMIT 10; 

-- Solution Summary -- 

-- This query uses LEFT JOINs to combine posts and comments per user,
-- then aggregates with COUNT(DISTINCT ...) to avoid duplicates, ranking the top 10 by total activity.

-- ==============================================================
-- Q2. Most Liked Posts and Creators
-- ==============================================================
-- Objective : Identify posts with maximum likes along with their creator.
-- Business question:
-- "Which posts attracted the most likes, and who published them?"
-- --------------------------------------------------------------
-- Your Code ...

SELECT 
    p.post_id,
    p.content,
    u.username        AS creator,
    u.country,
    COUNT(l.like_id)  AS total_likes
FROM posts p
JOIN users u ON p.user_id = u.user_id
LEFT JOIN likes l ON p.post_id = l.post_id
GROUP BY p.post_id, p.content, u.username, u.country
ORDER BY total_likes DESC
LIMIT 10;

-- Solution Summary -- 

-- This query joins posts with users to get the creator's name, then counts likes
-- per post using LEFT JOIN on likes, ordering by most liked to show top 10 posts.

-- ==============================================================
-- Q3. Top Countries by Average Engagement
-- ==============================================================
-- Objective : Find countries with the highest average likes per post.
-- Business question:
-- "On average, which countries receive the most likes per post?"
-- --------------------------------------------------------------
-- Your Code ...

SELECT 
    u.country,
    COUNT(DISTINCT p.post_id) AS total_posts,
    COUNT(l.like_id) AS total_likes,
    ROUND(COUNT(l.like_id) / COUNT(DISTINCT p.post_id), 2) AS avg_likes_per_post
FROM users u
JOIN posts p ON u.user_id = p.user_id
LEFT JOIN likes l ON p.post_id = l.post_id
GROUP BY u.country
ORDER BY avg_likes_per_post DESC
LIMIT 5;

-- Solution Summary -- 

-- This query aggregates likes and posts per country, then divides total likes by
-- total posts to compute the average engagement, surfacing the top 5 countries.

-- ==============================================================
-- Q4. Trending Hashtags (Used in >20 Posts)
-- ==============================================================
-- Objective : Find hashtags that appear in more than 20 posts.
-- Business question:
-- "Which hashtags appear in more than 20 posts?"
-- --------------------------------------------------------------
-- Your Code ...

SELECT 
    h.hashtag_id,
    h.tag_name,
    h.category,
    COUNT(ph.post_id) AS usage_count
FROM hashtags h
JOIN post_hashtags ph ON h.hashtag_id = ph.hashtag_id
GROUP BY h.hashtag_id, h.tag_name, h.category
HAVING COUNT(ph.post_id) > 20
ORDER BY usage_count DESC;

-- Solution Summary -- 

-- This query joins hashtags with post_hashtags to count how many posts each tag appears in,
-- using HAVING to filter only those used in more than 20 posts.

-- ==============================================================
-- Q5. Top Influencers (Users with Most Followers)
-- ==============================================================
-- Objective : List users with the highest follower count.
-- Business question:
-- "Who has the largest follower audience on the platform?"
-- --------------------------------------------------------------
-- Your Code ...

SELECT 
    u.user_id,
    u.username,
    u.country,
    COUNT(f.follower_id) AS follower_count
FROM users u
LEFT JOIN followers f ON u.user_id = f.user_id
GROUP BY u.user_id, u.username, u.country
ORDER BY follower_count DESC
LIMIT 10;

-- Solution Summary -- 

-- This query performs a self-join pattern on the followers table, counting how many
-- rows reference each user as the followed account, then ranks by follower count.

-- ==============================================================
-- Q6. Followers Who Never Interacted
-- ==============================================================
-- Objective : Identify users who follow others but have never liked or commented.
-- Business question:
-- "Which users follow other accounts but have never liked or commented on content?"
-- --------------------------------------------------------------
-- Your Code ...

SELECT DISTINCT
    u.user_id,
    u.username,
    u.country
FROM users u
WHERE u.user_id IN (
        SELECT DISTINCT follower_user_id FROM followers
    )
  AND u.user_id NOT IN (
        SELECT DISTINCT user_id FROM likes
    )
  AND u.user_id NOT IN (
        SELECT DISTINCT user_id FROM comments
    )
ORDER BY u.username;

-- Solution Summary -- 

-- This query finds users who appear in the followers table (as a follower) but are
-- absent from both the likes and comments tables, using NOT IN subqueries for filtering.

-- ==============================================================
-- Q7. Hashtags with Highest Engagement
-- ==============================================================
-- Objective : Calculate total engagement (likes + comments) for each hashtag.
-- Business question:
-- "Which hashtags generate the most combined likes and comments?"
-- --------------------------------------------------------------
-- Your Code ...

SELECT 
    h.hashtag_id,
    h.tag_name,
    h.category,
    COUNT(DISTINCT l.like_id) AS total_likes,
    COUNT(DISTINCT c.comment_id) AS total_comments,
    COUNT(DISTINCT l.like_id) + COUNT(DISTINCT c.comment_id) AS engagement_score
FROM hashtags h
JOIN post_hashtags ph ON h.hashtag_id = ph.hashtag_id
JOIN posts p ON ph.post_id = p.post_id
LEFT JOIN likes l ON p.post_id = l.post_id
LEFT JOIN comments c ON p.post_id = c.post_id
GROUP BY h.hashtag_id, h.tag_name, h.category
ORDER BY engagement_score DESC
LIMIT 10;

-- Solution Summary -- 

-- This multi-table join links hashtags → post_hashtags → posts → likes/comments,
-- aggregating total likes and comments per hashtag to produce an engagement score.

-- ==============================================================
-- Q8. Busiest Posting Hours or Days
-- ==============================================================
-- Objective : Find which hour/day sees most posting activity.
-- Business question:
-- "When are users most likely to publish posts: by hour and by weekday?"
-- --------------------------------------------------------------
-- Your Code ...

-- By Hour of Day
SELECT 
    HOUR(created_at) AS posting_hour,
    COUNT(post_id) AS total_posts
FROM posts
GROUP BY HOUR(created_at)
ORDER BY total_posts DESC;

-- By Day of Week
SELECT 
    DAYNAME(created_at) AS day_of_week,
    DAYOFWEEK(created_at) AS day_number,
    COUNT(post_id) AS total_posts
FROM posts
GROUP BY DAYNAME(created_at), DAYOFWEEK(created_at)
ORDER BY total_posts DESC;

-- Solution Summary -- 

-- Two queries extract the hour and weekday from the created_at timestamp using MySQL date functions,
-- grouping and counting posts to identify peak activity periods.

-- ==============================================================
-- Q9. Inactive Users
-- ==============================================================
-- Objective : Find users who have never posted, liked, or commented.
-- Business question:
-- "Which accounts have no recorded posts, likes, or comments?"
-- --------------------------------------------------------------
-- Your Code ...

SELECT 
    u.user_id,
    u.username,
    u.country,
    u.join_date
FROM users u
LEFT JOIN posts p ON u.user_id = p.user_id
LEFT JOIN likes l ON u.user_id = l.user_id
LEFT JOIN comments c ON u.user_id = c.user_id
WHERE p.post_id IS NULL
  AND l.like_id IS NULL
  AND c.comment_id IS NULL
ORDER BY u.join_date;

-- Solution Summary -- 

-- This query uses three LEFT JOINs to all activity tables and
-- filters with IS NULL checks to identify users who have zero posts, likes and comments on record.

-- ==============================================================
-- Q10. Top Countries with Most Influencers
-- ==============================================================
-- Objective : Identify countries with the highest number of influencers.
-- Business question:
-- "Which countries are home to the largest number of high-follower accounts?"
-- --------------------------------------------------------------
-- Your Code ...

SELECT 
    u.country,
    COUNT(DISTINCT u.user_id) AS influencer_count
FROM users u
JOIN (
    SELECT 
        user_id,
        COUNT(follower_id) AS follower_count
    FROM followers
    GROUP BY user_id
    ORDER BY follower_count DESC
    LIMIT 100          -- consider top 100 as influencers;
) top_users ON u.user_id = top_users.user_id
GROUP BY u.country
ORDER BY influencer_count DESC
LIMIT 5;

-- Solution Summary -- 

-- This query first computes follower counts per user, then identifies influencers
-- as those above a threshold and aggregates by country to rank the top 5.

-- ==============================================================
-- BONUS CHALLENGES
-- ==============================================================
-- 1. Engagement rate = (likes + comments) / posts

SELECT 
    u.user_id,
    u.username,
    u.country,
    COUNT(DISTINCT p.post_id) AS total_posts,
    COUNT(DISTINCT l.like_id) AS total_likes,
    COUNT(DISTINCT c.comment_id) AS total_comments,
    ROUND(
        (COUNT(DISTINCT l.like_id) + COUNT(DISTINCT c.comment_id))
        / NULLIF(COUNT(DISTINCT p.post_id), 0)
    , 2) AS engagement_rate
FROM users u
LEFT JOIN posts p ON u.user_id = p.user_id
LEFT JOIN likes l ON p.post_id = l.post_id
LEFT JOIN comments c ON p.post_id = c.post_id
GROUP BY u.user_id, u.username, u.country
HAVING total_posts > 0
ORDER BY engagement_rate DESC
LIMIT 10;

-- 2. Mutual followers

SELECT DISTINCT
    u1.username AS user_a,
    u2.username AS user_b
FROM followers f1
JOIN followers f2 
    ON f1.user_id = f2.follower_user_id 
   AND f1.follower_user_id = f2.user_id
JOIN users u1 ON f1.user_id          = u1.user_id
JOIN users u2 ON f1.follower_user_id = u2.user_id
WHERE u1.user_id < u2.user_id   -- avoid duplicate pairs
ORDER BY u1.username;

-- 3. Most used hashtags by top 5 influencers

WITH top5 AS (
    SELECT u.user_id
    FROM users u
    JOIN followers f ON u.user_id = f.user_id
    GROUP BY u.user_id
    ORDER BY COUNT(f.follower_id) DESC
    LIMIT 5
)
SELECT 
    h.tag_name,
    h.category,
    COUNT(ph.post_id) AS usage_count
FROM top5 t
JOIN posts p ON t.user_id = p.user_id
JOIN post_hashtags ph ON p.post_id = ph.post_id
JOIN hashtags h ON ph.hashtag_id = h.hashtag_id
GROUP BY h.tag_name, h.category
ORDER BY usage_count DESC
LIMIT 10;

-- 4. Country-wise engagement leaderboard

SELECT 
    u.country,
    COUNT(DISTINCT p.post_id) AS total_posts,
    COUNT(DISTINCT l.like_id) AS total_likes,
    COUNT(DISTINCT c.comment_id) AS total_comments,
    COUNT(DISTINCT l.like_id) + COUNT(DISTINCT c.comment_id) AS total_engagement,
    ROUND(
        (COUNT(DISTINCT l.like_id) + COUNT(DISTINCT c.comment_id))
        / NULLIF(COUNT(DISTINCT p.post_id), 0)
    , 2) AS avg_engagement_per_post
FROM users u
LEFT JOIN posts p ON u.user_id = p.user_id
LEFT JOIN likes l ON p.post_id = l.post_id
LEFT JOIN comments c ON p.post_id = c.post_id
GROUP BY u.country
ORDER BY avg_engagement_per_post DESC;

-- --------------------------------------------------------------

-- ==============================================================
-- REFLECTION
-- ==============================================================
-- 1. How I used GenAI during the project

-- I used GenAI as a support tool to explore possible query structures and clarify 
-- how joins, aggregations, and subqueries could answer the business questions.

-- 2. What optimization tips did you learn?

-- I learned to break a question into smaller steps, choose the relevant joins, and aggregate at the right level. I also learned to use DISTINCT when joins could multiply rows.

-- 3. What business insights stood out to you?

-- In my analysis, vthomas had the highest follower count.
-- Tuesday had the highest number of posts.
-- Guinea had the highest average likes per post in the results I reviewed.

-- ==============================================================
