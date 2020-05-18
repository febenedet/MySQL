SELECT 
count(distinct s.website_session_id) as NumberOfSessions,
week(s.created_at),
date_format(min(s.created_at),"%M %d %Y") as StartDate

FROM mavenfuzzyfactory.website_sessions s

where 
utm_source = 'gsearch' and
utm_campaign = 'nonbrand' and
s.created_at < '2012-05-12'
 
 group by 2