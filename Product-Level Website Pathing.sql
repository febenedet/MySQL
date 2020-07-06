-- STEP 1

CREATE TEMPORARY TABLE products_pageviews1

SELECT 
    website_session_id,
    website_pageview_id,
    created_at,
    CASE
        WHEN created_at < '2013-01-06' THEN 'A. Pre_Product_2'
        WHEN created_at >= '2013-01-06' THEN 'B. Post_Product_2'
        ELSE 'Check Logic'
    END AS time_period
FROM
    mavenfuzzyfactory.website_pageviews
WHERE
    created_at < '2013-04-06'
        AND created_at > '2012-10-06'
        AND pageview_url = '/products';
       
-- STEP 2

 CREATE TEMPORARY TABLE sessions_w_next_pageveiew_id      
      SELECT 
    p_pv.time_period,
    p_pv.website_session_id,
    MIN(w_pv.website_pageview_id) AS min_next_pageview_id
FROM
    products_pageviews1 p_pv
        LEFT JOIN
    website_pageviews w_pv ON (w_pv.website_session_id = p_pv.website_session_id)
        AND (w_pv.website_pageview_id > p_pv.website_pageview_id)
GROUP BY 1 , 2;

-- STEP 3

CREATE TEMPORARY TABLE sessions_w_next_pageview_url
SELECT 
    sessions_w_next_pageveiew_id.time_period,
    sessions_w_next_pageveiew_id.website_session_id,
    website_pageviews.pageview_url AS next_pageview_url
FROM
    sessions_w_next_pageveiew_id
        LEFT JOIN
    website_pageviews ON website_pageviews.website_pageview_id = sessions_w_next_pageveiew_id.min_next_pageview_id;
    
   -- STEP 4 
    
   SELECT 
    time_period,
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE
            WHEN next_pageview_url IS NOT NULL THEN website_session_id
            ELSE NULL
        END) AS w_next_pg,
    COUNT(DISTINCT CASE
            WHEN next_pageview_url IS NOT NULL THEN website_session_id
            ELSE NULL
        END) / COUNT(DISTINCT website_session_id) AS pct_w_next_pg,
    COUNT(DISTINCT CASE
            WHEN next_pageview_url = '/the-original-mr-fuzzy' THEN website_session_id
            ELSE NULL
        END) AS to_mrfuzzy,
    COUNT(DISTINCT CASE
            WHEN next_pageview_url = '/the-original-mr-fuzzy' THEN website_session_id
            ELSE NULL
        END) / COUNT(DISTINCT website_session_id) AS pct_to_mrfuzzy,
    COUNT(DISTINCT CASE
            WHEN next_pageview_url = '/the-forever-love-bear' THEN website_session_id
            ELSE NULL
        END) AS to_lovebear,
    COUNT(DISTINCT CASE
            WHEN next_pageview_url = '/the-forever-love-bear' THEN website_session_id
            ELSE NULL
        END) / COUNT(DISTINCT website_session_id) AS pct_to_lovebear
FROM
    sessions_w_next_pageview_url
GROUP BY 1

-- RESULTS
-- Percent of /products pageviews that clicked to Mr.Fuzzy has gone down since the launch of the product Love Bear
-- Overall clickthrough rate has gone up
-- Seems to be generating additional product interest overall