-- 1) Find the FIRST Page View ID for relevant sessions
-- 2) Identify the landing page for each session
-- 3) Count Page Viee for each session, identifying bounces
-- 4) Summarize total sessions and bounced sessions by Landing Page

CREATE TEMPORARY TABLE FindFirstPageView
SELECT
pv.website_session_id as PageID,
min(pv.website_pageview_id) as First_Access_ID
FROM website_pageviews pv
	INNER JOIN website_sessions ws
		ON ws.website_session_id = pv.website_session_id
GROUP BY pv.website_session_id;

--------

CREATE TEMPORARY table LandingPage1
select 
ffpv.PageID as PageID,
pv.pageview_url as URL_Landing_Page

from FindFirstPageView ffpv
	left join website_pageviews pv on pv.website_pageview_id = ffpv.First_Access_ID;
    
-----------
CREATE TEMPORARY table BouncedSessionsOnly
SELECT 
lp.PageID,
lp.URL_Landing_Page,
count(distinct pv.website_pageview_id) as count_of_pages_viewd

FROM  LandingPage1 lp
 	LEFT JOIN website_pageviews pv ON pv.website_session_id = lp.PageID

GROUP BY 
lp.PageID,
lp.URL_Landing_Page
    
HAVING
	COUNT(pv.website_session_id) = 1;
    
-----

SELECT
lp.URL_Landing_Page,
count(distinct lp.PageID) as sessions,
count(distinct bs.PageID) as bounced_sessions,
count(distinct bs.PageID)/count(distinct lp.PageID) as bounce_rate

FROM LandingPage1 lp
 	LEFT JOIN BouncedSessionsOnly bs ON lp.PageID = bs.PageID
    
group by
    lp.URL_Landing_Page
    
ORDER BY 
	lp.PageID
    ;
