# Project notes

## Data model

The database contains seven tables:

- `users`: registered accounts and country
- `posts`: user-created posts and timestamps
- `comments`: comments attached to posts and their authors
- `likes`: likes attached to posts and the users who liked them
- `followers`: follower/followed-account relationships
- `hashtags`: hashtag names and categories
- `post_hashtags`: bridge table mapping posts to hashtags

## Interpretation notes

- “Most active” in Q1 means posts + comments authored by a user.
- Q3 calculates average likes per post by country; this is not the same as a complete engagement rate.
- Q7 counts likes and comments on posts associated with each hashtag.
- Q10 defines the influencer group as the top 100 accounts by follower count before grouping those accounts by country.
- Results depend on the supplied dataset and should be rechecked by running the queries.

## SQL Techniques Applied

- **Joins:** Combined users, posts, comments, likes, followers and hashtags to analyse related activity.
- **Aggregation:** Used `COUNT()`, `SUM()` and `AVG()` to calculate activity and engagement metrics.
- **Subqueries and CTEs:** Structured multi-step analytical questions.
- **LEFT JOIN:** Identified users without recorded activity.
- **Date functions:** Analysed posting patterns by hour and weekday.
- **Data accuracy:** Considered duplicate rows and aggregation levels when joining multiple tables.
