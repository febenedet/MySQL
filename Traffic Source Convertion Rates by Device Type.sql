SELECT 
    device_type,
    COUNT(DISTINCT s.website_session_id) AS NumberOfSessions,
    COUNT(DISTINCT order_id) AS orders,
    COUNT(DISTINCT order_id) / COUNT(DISTINCT s.website_session_id) AS SessionToOrderConvRate
FROM
    mavenfuzzyfactory.website_sessions s
        LEFT JOIN
    orders o ON (s.website_session_id = o.website_session_id)
WHERE
    s.created_at < '2012-05-11'
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
GROUP BY device_type