SET SEARCH_PATH = "Customer Profiling Project";

SELECT * FROM customer_data;


-- 1. What's the average age of customers?
SELECT 
    AVG(age)
FROM
    customer_data;
    

-- 2. How does the distribution of education levels vary among customers?

SELECT 
    age_distribution, COUNT(*)
FROM
    customer_data
GROUP BY age_distribution;



-- 3. What's the predominant marital status among customers?

SELECT 
    marital_status, COUNT(*)
FROM
    customer_data
GROUP BY marital_status;



-- 4. Which product do high-income customers tend to spend on?

SELECT 
    ROUND(AVG(mnt_wine)) AS avg_wine_purchase,
    ROUND(AVG(mnt_fruit)) AS avg_fruit_purchase,
    ROUND(AVG(mnt_meat_product)) AS avg_meat_purchase,
    ROUND(AVG(mnt_fish_product)) AS avg_fish_purchase,
    ROUND(AVG(mnt_sweet_products)) AS avg_sweet_purchase,
    ROUND(AVG(mnt_gold_prod)) AS avg_gold_purchase
FROM
    customer_data
WHERE
    income > (SELECT 
            AVG(income)
        FROM
            customer_data);
            
            

-- 5. How does the spending behavior of customers with children differ from those without children?

SELECT 
    kid_home,
    teen_home,
    ROUND(AVG(mnt_wine + mnt_fruit + mnt_meat_product + mnt_fish_product + mnt_sweet_products + mnt_gold_prod))
FROM
    customer_data
GROUP BY kid_home , teen_home
ORDER BY kid_home , teen_home;

-- 6. Are there any specific age groups that spend more on luxury items like gold products?


SELECT 
    age_distribution,
    ROUND(AVG(mnt_gold_prod)) AS avg_gold_purchase
FROM
    customer_data
GROUP BY age_distribution
ORDER BY avg_gold_purchase DESC;



-- 7. Do customers with higher education levels prefer making purchases through the website or in stores?
SELECT 
    education,
    ROUND(AVG(num_web_purchase)) AS web_purchase,
    ROUND(AVG(num_store_purchase)) AS store_purchase
FROM
    customer_data
GROUP BY education
HAVING education = 'Master'
    OR education = 'PhD';

-- 8. How does the number of web visits vary among different age groups?


SELECT 
    age_distribution,
    ROUND(AVG(num_webvisits_month)) AS avg_webvisit
FROM
    customer_data
GROUP BY age_distribution;




-- 9. How many customers frequently make purchases through multiple channels (web, catalog, store)?

SELECT 
    COUNT(*)
FROM
    (SELECT 
        COUNT(*) AS total_customer,
            num_web_purchase,
            num_catalogue_purchase,
            num_store_purchase
    FROM
        customer_data
    GROUP BY num_web_purchase , num_catalogue_purchase , num_store_purchase
    HAVING num_web_purchase > (SELECT 
            AVG(num_web_purchase)
        FROM
            customer_data)
        AND num_catalogue_purchase > (SELECT 
            AVG(num_catalogue_purchase)
        FROM
            customer_data)
        AND num_store_purchase > (SELECT 
            AVG(num_store_purchase)
        FROM
            customer_data)) AS multiple_channel_customers;

-- 10. Do customers who make purchases through multiple channels tend to have higher spending?

SELECT 
    ROUND(AVG(spent))
FROM
    (SELECT 
        COUNT(*) AS total_customer,
            ROUND((mnt_wine + mnt_fruit + mnt_meat_product + mnt_fish_product + mnt_sweet_products + mnt_gold_prod)) AS spent,
            num_web_purchase,
            num_catalogue_purchase,
            num_store_purchase
    FROM
        customer_data
    GROUP BY mnt_wine , mnt_fruit , mnt_meat_product , mnt_fish_product , mnt_sweet_products , mnt_gold_prod , num_web_purchase , num_catalogue_purchase , num_store_purchase
    HAVING num_web_purchase > (SELECT 
            AVG(num_web_purchase)
        FROM
            customer_data)
        AND num_catalogue_purchase > (SELECT 
            AVG(num_catalogue_purchase)
        FROM
            customer_data)
        AND num_store_purchase > (SELECT 
            AVG(num_store_purchase)
        FROM
            customer_data)) avg_spent_by_multiple_channel_customers;

-- 11.What campaign was most successful?

SELECT 
    SUM(CASE
                WHEN accepted_cmp1 = 1 THEN 1
            END) AS scc1,
    SUM(CASE
                WHEN accepted_cmp2 = 1 THEN 1
            END) AS scc2,
    SUM(CASE
                WHEN accepted_cmp3 = 1 THEN 1
            END) AS scc3,
    SUM(CASE
                WHEN accepted_cmp4 = 1 THEN 1
            END) AS scc4,
    SUM(CASE
                WHEN accepted_cmp5 = 1 THEN 1
            END) AS scc5
FROM
    customer_data;
