# Social Media Analytics — SQL Project

A practical SQL project exploring user activity, post performance, audience relationships, hashtags and posting patterns in a social media dataset. The project was assigned as an SQL + GenAI mini project; the analysis is documented as business questions, with GenAI treated as a support tool rather than the focus of the work.

## Project overview

The goal was to turn a set of marketing and platform questions into SQL queries that can help a social media team understand engagement and activity.

### Questions explored

- Which users are most active when posts and comments are counted together?
- Which posts attract the most likes?
- Which countries have the highest average likes per post?
- Which hashtags are used across many posts?
- Which users have the largest follower audiences?
- Which users follow accounts but have no recorded likes or comments?
- Which hashtags generate the most likes and comments?
- What hours and weekdays have the most posts?
- Which accounts have no recorded posts, likes or comments?
- Which countries have the most high-follower accounts?

Bonus analysis covers user-level engagement rate, mutual followers, hashtags used by top influencers and a country-level engagement leaderboard.

## Tools and SQL concepts

- MySQL
- `JOIN` and `LEFT JOIN`
- `GROUP BY` and aggregate functions
- `HAVING`, subqueries and a common table expression (CTE)
- `COUNT(DISTINCT ...)` to reduce join-multiplication errors
- Date and time functions such as `HOUR()`, `DAYNAME()` and `DAYOFWEEK()`
- `NULLIF()` to guard against division by zero

## Repository structure

```text
social-media-analytics-sql/
├── README.md
├── sql/
│   ├── social_media_analysis_queries.sql
│   └── social_media_analytics_dataset.sql
└── docs/
    └── project-notes.md
```

## How to run the project

1. Install or open MySQL Workbench or another MySQL-compatible SQL client.
2. Run `sql/social_media_analytics_dataset.sql` to create and populate the `Social_Media` database.
3. Open `sql/social_media_analysis_queries.sql`.
4. Execute the queries in order, or run each section separately.
5. Compare the returned results with the business question and record any useful findings.

> The dataset setup script is provided for reproducibility. It contains synthetic project records.

## A note on the analysis

I approached each task by translating the business question into a measurable definition, identifying the relevant tables and relationships and then selecting the joins and aggregations needed. For example, “most active” is defined here as the combined count of posts and comments, while hashtag engagement is calculated as likes plus comments on posts carrying that hashtag.

These definitions matter: changing the definition of “influencer” or “engagement” can change the ranking. In this project, the country-level average in the main query is average likes per post, not a complete engagement rate.

## Key findings

The initial results I recorded were:
- `vthomas` had the highest follower count in the results I reviewed.
- Tuesday was the busiest posting day.
- Guinea had the highest average likes per post.

## What I learned

- How to combine related tables without losing users who have no matching activity.
- Why the level of aggregation matters when joining posts, likes and comments.
- How to use subqueries and CTEs to break a multi-step analysis into manageable parts.
- How to use GenAI as a learning and debugging aid, then inspect the query logic and result meaning rather than treating generated SQL as automatically correct.

## Limitations

- The dataset is synthetic, so findings should not be treated as real-world platform behaviour.
- The project uses likes and comments as engagement signals; it does not include impressions, reach or view counts.
- The “top influencer” country analysis uses a top-100 follower-count cutoff. That is an operational definition for this exercise, not a universal industry standard.

## Author

**Mohammad Hummad Siddiqui**  
Aspiring Data Analyst | SQL • Excel • Power BI • Python
