

--Number of distinct campaigns
SELECT COUNT(DISTINCT utm_campaign) AS 'Distinct Campaigns'
FROM page_visits;


--Number of distinct sources
SELECT COUNT(DISTINCT utm_source) AS 'Distinct Sources'
FROM page_visits;


--Relationship between campaigns and sources***
SELECT DISTINCT utm_campaign AS 'Campaign', 
	utm_source AS 'Source'
FROM page_visits;


--Distinct page names
SELECT DISTINCT page_name AS 'Page Name'
FROM page_visits;


--First touch attribution
WITH first_touch AS (
 SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attr AS (
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM first_touch ft
  JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)
SELECT ft_attr.utm_source as source,
       ft_attr.utm_campaign as campaign,
       COUNT(*) as count
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;


--Last touch attribution
WITH last_touch AS (
SELECT user_id,
       MAX(timestamp) AS 'last_touch_at'
    FROM page_visits
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source as source,
       lt_attr.utm_campaign as campaign,
       COUNT(*) as count
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;


--Visitors that make a purchase
SELECT page_name as page, 
	COUNT(*) as count
FROM page_visits
WHERE page_name = '4 - purchase'
GROUP BY page;


--Number of visitors per page
SELECT page_name as page,
	COUNT(*) as count
FROM page_visits
GROUP BY page;


--Last touch on purchase for each campaign
WITH last_touch AS (
SELECT user_id,
       MAX(timestamp) AS 'last_touch_at'
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source as source,
       lt_attr.utm_campaign as campaign,
       COUNT(*) as count
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;


--Tracking the typical user journey
SELECT *
FROM page_visits
ORDER BY user_id ASC
LIMIT 100;
