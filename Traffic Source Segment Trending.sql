SELECT 
    DATE_FORMAT(MIN(s.created_at), '%M %d %Y') AS StartDate,
    COUNT(DISTINCT CASE
            WHEN device_type = 'mobile' THEN s.website_session_id
            ELSE NULL
        END) AS Mobile,
    COUNT(DISTINCT CASE
            WHEN device_type = 'desktop' THEN s.website_session_id
            ELSE NULL
        END) AS Desktop
FROM
    mavenfuzzyfactory.website_sessions s
WHERE
    s.created_at BETWEEN '2012-04-15' AND '2012-06-09'
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
GROUP BY WEEK(s.created_at)