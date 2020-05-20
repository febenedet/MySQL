-- BUSINESS CONTEXT
-- Mini Conversion funnel, from lauder-2 to /cart
-- Find how many people reach each step, and also dropoff rates
-- Looking ar /lauder-2 traffic only
-- Looking at customers who like Mr Fuzzy only
-- Looking at specifc date range

-- STEPS
-- 1) Select all pageviws for relevant sessions
-- 2) Identify each relevant pageview as specific funnel step
-- 3) Create the session-level conversion funnel view
-- 3) Aggregate the data to assess funmel performance


SELECT
	website_session_id,
    MAX(products_page) AS products_made_it,
    MAX(mrfuzzy_page) AS mrfuzzy_made_it,
	MAX(cart_page) AScart_made_it

-- SUBQUERY

FROM (
SELECT 
	s.website_session_id,
	pv.pageview_url,
	pv.created_at as PageView_created_at,
	CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page,
	CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page,
	CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page
FROM website_sessions s
	LEFT JOIN website_pageviews pv on pv.website_session_id = s.website_session_id
WHERE s.created_at BETWEEN '2014-01-01' AND '2014-02-01' 
	AND pv.pageview_url IN ('/lander-2', '/products', '/the-original-mr-fuzzy', '/cart')
ORDER BY
	s.website_session_id,
    pv.created_at
    
    ) AS pageview_level
    GROUP BY
		website_session_id;
        
        
CREATE TEMPORARY TABLE sessions_level_made_it_flags_demo
SELECT
	website_session_id,
    MAX(products_page) AS products_made_it,
    MAX(mrfuzzy_page) AS mrfuzzy_made_it,
	MAX(cart_page) AS cart_made_it

-- SUBQUERY

FROM (
SELECT 
	s.website_session_id,
	pv.pageview_url,
	pv.created_at as PageView_created_at,
	CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page,
	CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page,
	CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page
FROM website_sessions s
	LEFT JOIN website_pageviews pv on pv.website_session_id = s.website_session_id
WHERE s.created_at BETWEEN '2014-01-01' AND '2014-02-01' 
	AND pv.pageview_url IN ('/lander-2', '/products', '/the-original-mr-fuzzy', '/cart')
ORDER BY
	s.website_session_id,
    pv.created_at
    
    ) AS pageview_level
    GROUP BY
		website_session_id;
        
-- SELECT * FROM sessions_level_made_it_flags_demo


SELECT 
	COUNT(distinct website_session_id) AS sessions,
    COUNT(distinct CASE WHEN products_made_it = 1 then website_session_id ELSE NULL END) AS to_products,
    COUNT(distinct CASE WHEN products_made_it = 1 then website_session_id ELSE NULL END)/COUNT(distinct website_session_id) AS lander_clickthrough_rate,
    COUNT(distinct CASE WHEN mrfuzzy_made_it = 1 then website_session_id ELSE NULL END) AS to_mrfuzzy,
    COUNT(distinct CASE WHEN mrfuzzy_made_it = 1 then website_session_id ELSE NULL END)/COUNT(distinct CASE WHEN products_made_it = 1 then website_session_id ELSE NULL END) AS products_clickthrough_rate,
    COUNT(distinct CASE WHEN AScart_made_it = 1 then website_session_id ELSE NULL END) AS to_cart,
    COUNT(distinct CASE WHEN AScart_made_it = 1 then website_session_id ELSE NULL END)/COUNT(distinct CASE WHEN mrfuzzy_made_it = 1 then website_session_id ELSE NULL END) AS mr_fuzzy_clickthrough_rate
    
FROM sessions_level_made_it_flags_demo sm
