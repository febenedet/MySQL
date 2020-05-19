CREATE TEMPORARY TABLE FirstPageView

SELECT 
website_pageview_id,
MIN(website_pageview_id) as MinPageViewID

FROM mavenfuzzyfactory.website_pageviews
GROUP BY website_session_id;

SELECT 
wpv.pageview_url as LandingPage,
COUNT(DISTINCT fpv.website_pageview_id) as SessionsHittingThisLander

FROM FirstPageView fpv
	LEFT JOIN website_pageviews wpv
		ON fpv.MinPageViewID = wpv.website_pageview_id

GROUP BY 1
ORDER BY 1 asc