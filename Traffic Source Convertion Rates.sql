SELECT 
count(distinct s.website_session_id) as NumberOfSessions,
count(distinct order_id) as orders,
count(distinct order_id) / count(distinct s.website_session_id) as SessionToOrderConvRate

FROM mavenfuzzyfactory.website_sessions s
left join orders o on (s.website_session_id = o.website_session_id)
where 
s.created_at < '2012-04-14' and
utm_source = 'gsearch' and
utm_campaign = 'nonbrand'

