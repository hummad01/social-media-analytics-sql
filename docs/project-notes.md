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

## Human-centred query-writing approach

For each question:
1. Identify the business decision or curiosity behind the question.
2. Define the metric clearly (for example, posts + comments for activity).
3. Identify the tables and their join keys.
4. Decide the correct grouping level.
5. Check whether joins can multiply rows and whether `DISTINCT` is needed.
6. Run the query and interpret the returned result in plain language.
