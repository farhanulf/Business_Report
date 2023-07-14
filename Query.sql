-- 4. 
SELECT 
    YEAR(created_at) AS yr,
    MONTH(created_at) AS mo,
    COUNT(DISTINCT CASE
            WHEN utm_source = 'gsearch' THEN website_session_id
        END) AS 'gsearch_paid_sessions',
    COUNT(DISTINCT CASE
            WHEN utm_source = 'bsearch' THEN website_session_id
        END) AS 'bsearch_paid_sessions',
    COUNT(DISTINCT CASE
            WHEN
                utm_source IS NULL
                    AND http_referer IS NOT NULL
            THEN
                website_session_id
        END) AS 'organic_paid_sessions',
    COUNT(DISTINCT CASE
            WHEN
                utm_source IS NULL
                    AND http_referer IS NULL
            THEN
                website_session_id
        END) AS 'direct_type_paid_sessions'
FROM
    website_sessions
WHERE
    created_at BETWEEN '2012-03-01' AND '2012-11-27'
GROUP BY 1 , 2;

-- 1

SELECT 
    YEAR(website_sessions.created_at) AS yr,
    MONTH(website_sessions.created_at) AS mo,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS conv_rate
FROM
    website_sessions
        LEFT JOIN
    orders ON orders.website_session_id = website_sessions.website_session_id
WHERE
    website_sessions.created_at BETWEEN '2012-03-01' AND '2012-11-27'
        AND website_sessions.utm_source = 'gsearch'
GROUP BY 1,2;

-- 2 
SELECT 
    YEAR(website_sessions.created_at) AS yr,
    MONTH(website_sessions.created_at) AS mo,
    COUNT(DISTINCT CASE
            WHEN website_sessions.utm_campaign = 'nonbrand' THEN website_sessions.website_session_id
        END) AS 'nonbrand_sessions',
    COUNT(DISTINCT CASE
            WHEN website_sessions.utm_campaign = 'nonbrand' THEN orders.order_id
        END) AS 'nonbrand_orders',
    COUNT(DISTINCT CASE
            WHEN website_sessions.utm_campaign = 'brand' THEN website_sessions.website_session_id
        END) AS 'brand_sessions',
    COUNT(DISTINCT CASE
            WHEN website_sessions.utm_campaign = 'brand' THEN orders.order_id
        END) AS 'brand_orders'
FROM
    website_sessions
        LEFT JOIN
    orders ON orders.website_session_id = website_sessions.website_session_id
WHERE
    website_sessions.created_at BETWEEN '2012-03-01' AND '2012-11-27'
        AND website_sessions.utm_source = 'gsearch'
GROUP BY YEAR(website_sessions.created_at) , MONTH(website_sessions.created_at);

-- 3 

SELECT 
    YEAR(website_sessions.created_at) AS yr,
    MONTH(website_sessions.created_at) AS mo,
    COUNT(DISTINCT CASE
            WHEN website_sessions.device_type = 'desktop' THEN website_sessions.website_session_id
        END) AS 'desktop_sessions',
    COUNT(DISTINCT CASE
            WHEN website_sessions.device_type = 'desktop' THEN orders.order_id
        END) AS 'desktop_orders',
    COUNT(DISTINCT CASE
            WHEN website_sessions.device_type = 'mobile' THEN website_sessions.website_session_id
        END) AS 'mobile_sessions',
    COUNT(DISTINCT CASE
            WHEN website_sessions.device_type = 'mobile' THEN orders.order_id
        END) AS 'mobile_orders'
FROM
    website_sessions
        LEFT JOIN
    orders ON orders.website_session_id = website_sessions.website_session_id
WHERE
    website_sessions.created_at BETWEEN '2012-03-01' AND '2012-11-27'
        AND website_sessions.utm_source = 'gsearch'
        AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY 1,2;

select distinct device_type from website_sessions;

-- 5

SELECT 
    YEAR(website_sessions.created_at) AS yr,
    MONTH(website_sessions.created_at) AS mo,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS conv
FROM
    website_sessions
        LEFT JOIN
    orders ON orders.website_session_id = website_sessions.website_session_id
WHERE
    website_sessions.created_at BETWEEN '2012-03-01' AND '2012-11-27'
GROUP BY 1,2;