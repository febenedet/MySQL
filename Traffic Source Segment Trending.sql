SELECT
date_format(min(s.created_at),"%M %d %Y") as StartDate,
-- week(s.created_at)
count(distinct case when device_type = 'mobile' then s.website_session_id else null end) as Mobile,
count(distinct case when device_type = 'desktop' then s.website_session_id else null end) as Desktop

from mavenfuzzyfactory.website_sessions s
where
s.created_at between '2012-04-15' AND '2012-06-09' and
utm_source = 'gsearch' and
utm_campaign = 'nonbrand'

group by week(s.created_at)