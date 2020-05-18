SELECT 
utm_source,
utm_campaign,
http_referer,
count(distinct website_session_id) as NumberOfSessions

FROM mavenfuzzyfactory.website_sessions s
where s.created_at < '2012-04-12'

group by utm_source,
utm_campaign,
http_referer