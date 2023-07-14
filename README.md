# Business Report: Project Overview
The objective of this project is to create a comprehensive business report for stakeholders that provides valuable insights and analysis. The report aims to offer a deep understanding of the company's operations and performance by utilizing data querying techniques, website performance analysis, and relevant financial metrics.

The project involves the following key aspects:
- Data Querying using the "Big 6" Statements and Clauses: The report utilizes SQL queries to extract essential information from the company's databases.
- Grouping by with Aggregate Functions: The report incorporates the use of GROUP BY and aggregate functions, such as SUM, COUNT, AVG, and MAX, to generate meaningful insights from the data.
- Querying Multiple Tables: In scenarios where data is distributed across multiple tables, the report employs SQL joins and appropriate query techniques to combine and analyze data from different sources.
- Analyzing Website Performance: The report includes an analysis of the company's website performance using relevant metrics, such as page load time, bounce rate, conversion rate, and user engagement.

## Code and Resources Used
MySQL Workbench <br>
Version: 8.0<br>
Dataset: [create_mavenfuzzyfactory_vApril2022.sql](https://drive.google.com/file/d/1rTNoprF6yXpssYNu-H-yvew0LgOEaX4i/view?usp=sharing)

## Context
We just got an email from Ms. Cindy to make report for next week.
<details>
<summary></b> The email </summary>

 ![Image](https://github.com/farhanulf/Business_Report/blob/main/Email.PNG)
 
</details>

## The Report
<details>
<summary><b>1.</b> Gsearch seems to be the biggest driver of our business. Could you pull monthly trends for gsearch sessions and orders so that we can showcase the growth there?</summary>

  - Code
```
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

```
    
  - The Output<br>
    ![Image](https://github.com/farhanulf/Business_Report/blob/main/1.PNG)
  
</details>

<details>
<summary><b>2.</b> Next, it would be great to see a similar monthly trend for Gsearch, but this time splitting out nonbrand and brand campaigns separately. I am wondering if brand is picking up at all. If so, this is a good story to tell.</summary>

 - Code
```
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
```
 - The Output<br>
   ![Image](https://github.com/farhanulf/Business_Report/blob/main/2.PNG)

</details>

<details>
<summary><b>3.</b> While we’re on Gsearch, could you dive into nonbrand, and pull monthly sessions and orders split by device type? I want to flex our analytical muscles a little and show the board we really know our traffic sources.</summary>

  - Code
```
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
```
  - The Output<br>
   ![Image](https://github.com/farhanulf/Business_Report/blob/main/3.PNG)


</details>

<details>
<summary><b>4.</b> I’m worried that one of our more pessimistic board members may be concerned about the large % of traffic from Gsearch. Can you pull monthly trends for Gsearch, alongside monthly trends for each of our other channels?</summary>

  - Code
```
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
```
  - The Output<br>
   ![Image](https://github.com/farhanulf/Business_Report/blob/main/4.PNG)


</details>

<details>
<summary><b>5.</b> I’d like to tell the story of our website performance improvements over the course of the first 8 months. Could you pull session to order conversion rates, by month?</summary>

  - Code
```
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
```
  - The Output<br>
   ![Image](https://github.com/farhanulf/Business_Report/blob/main/5.PNG)


</details>





