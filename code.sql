-- #1 familiarity


-- ## number of distinct campaigns


SELECT COUNT(DISTINCT utm_campaign) AS campaigns
FROM page_visits;


-- ## number of distinct sources

SELECT COUNT(DISTINCT utm_source) AS sources
FROM page_visits;


-- ## one to find how they are related.

SELECT utm_campaign AS campaigns,
       utm_source AS sources,
       COUNT(*) AS cnt
FROM page_visits
GROUP BY 2, 1;


-- ## What pages are on the CoolTShirts website

SELECT DISTINCT page_name
FROM page_visits;


-- # 2 journey


-- ## How many first touches is each campaign responsible for?

WITH firsts AS (
     SELECT user_id,
            MIN(timestamp) AS touch
     FROM page_visits
     GROUP BY user_id)
SELECT utm_campaign AS campaign,
       COUNT(DISTINCT v.user_id) AS cnt
FROM page_visits v
     JOIN firsts f
          ON f.user_id = v.user_id
          AND touch = timestamp
GROUP BY 1;


-- ## How many last touches is each campaign responsible for?

WITH lasts AS (
     SELECT user_id,
            MAX(timestamp) AS touch
     FROM page_visits
     GROUP BY user_id)
SELECT utm_campaign AS campaign,
       COUNT(DISTINCT v.user_id) AS cnt
FROM page_visits v
     JOIN lasts l
          ON l.user_id = v.user_id
          and touch = timestamp
GROUP BY 1;


-- ## How many visitors make a purchase?

SELECT COUNT(DISTINCT user_id) AS purchasers
FROM page_visits
WHERE page_name LIKE '4%';


-- ## How many last touches on the purchase page is each campaign responsible for?

WITH lasts AS (
     SELECT user_id,
            MAX(timestamp) AS touch
     FROM page_visits
     WHERE page_name LIKE '4%'
     GROUP BY user_id)
SELECT utm_campaign AS campaign,
       COUNT(DISTINCT v.user_id) AS cnt
FROM page_visits v
     JOIN lasts l
          ON l.user_id = v.user_id
          AND touch = timestamp
GROUP BY 1;


-- ## What is the typical user journey?

SELECT utm_campaign AS campaign,
       SUBSTR(page_name, 1, 1) AS page,
       COUNT(DISTINCT user_id) AS cnt
FROM page_visits
GROUP BY 1, 2;
