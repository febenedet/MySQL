SELECT 
    COUNT(DISTINCT s.website_session_id) AS NumberOfSessions,
    WEEK(s.created_at),
    DATE_FORMAT(MIN(s.created_at), '%M %d %Y') AS StartDate
FROM
    mavenfuzzyfactory.website_sessions s
WHERE
    utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
        AND s.created_at < '2012-05-12'
GROUP BY 2