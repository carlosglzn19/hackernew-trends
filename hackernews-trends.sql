-- Start by getting a feel for the hacker_news table! Let’s find the most popular Hacker News stories

SELECT title,
        score
FROM hacker_news
ORDER BY score DESC
LIMIT 5;

/* 
Recent studies have found that online forums tend to be dominated by a small percentage of their users (1-9-90 Rule).

Is this true of Hacker News?

Is a small percentage of Hacker News submitters taking the majority of the points?

First, find the total score of all the stories.
*/

SELECT SUM(score) AS total_score
FROM hacker_news;

/* Next, we need to pinpoint the users who have accumulated a lot of points across their stories.

Find the individual users who have gotten combined scores of more than 200, and their combined scores.
*/

SELECT user,
       SUM(score) AS total_score
FROM hacker_news
GROUP BY user
HAVING total_score > 200
ORDER BY 2 DESC;

/* 
Oh no! While we are looking at the power users, some users are rickrolling — tricking readers into clicking on a link to a funny video and claiming that it links to information about coding.

The url of the video is:

https://www.youtube.com/watch?v=dQw4w9WgXcQ

How many times has each offending user posted this link?
*/

SELECT user, 
       COUNT(*)
FROM hacker_news
WHERE url LIKE '%watch?v=dQw4w9WgXcQ%'
GROUP BY 1
ORDER BY 2 DESC;

/*
 Hacker News stories are essentially links that take users to other websites.

Which of these sites feed Hacker News the most:

GitHub, Medium, or New York Times?

First, we want to categorize each story based on their source.
*/

SELECT CASE
    WHEN url LIKE '%github%'
      THEN 'GitHub'
    WHEN url LIKE '%medium.com%'
      THEN 'Medium'
    WHEN url LIKE '%nytimes.com%'
      THEN 'New York Times'
    ELSE 'Other'
    END AS 'Source'
FROM hacker_news;

/* Next, build on the previous query:

Add a column for the number of stories from each URL using COUNT().

Also, GROUP BY the CASE statement.
*/

SELECT CASE
    WHEN url LIKE '%github.com%'
      THEN 'GitHub'
    WHEN url LIKE '%medium.com%'
      THEN 'Medium'
    WHEN url LIKE '%nytimes.com%'
      THEN 'New York Times'
    ELSE 'Other'
    END AS 'Source',
    COUNT(*)
FROM hacker_news
GROUP BY 1
ORDER BY 2 DESC;

/* Every submitter wants their story to get a high score so that the story makes it to the front page, but…

What’s the best time of the day to post a story on Hacker News?

Before we get started, let’s run this query and take a look at the timestamp column */

SELECT timestamp
FROM hacker_news
LIMIT 10;

/*
Let’s write a query that returns three columns:

The hours of the timestamp
The average score for each hour
The count of stories for each hour
*/

SELECT strftime('%H', timestamp) AS 'Hour',
       AVG(score) AS avg_score,
       COUNT(*) AS number_stories
FROM hacker_news
GROUP BY 1
ORDER BY 1;

-- What's the best time to post a story?
 
SELECT strftime('%H', timestamp) AS 'Hour', 
   ROUND(AVG(score), 1) AS 'avg_score', 
   COUNT(*) AS 'number_stories'
FROM hacker_news
WHERE timestamp IS NOT NULL
GROUP BY 1
ORDER BY 1;