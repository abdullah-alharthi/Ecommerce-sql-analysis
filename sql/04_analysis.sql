-- 1) What are the headline numbers?
SELECT COUNT(DISTINCT order_id)                          AS orders,
       COUNT(DISTINCT customer_id)                       AS buying_customers,
       ROUND(SUM(revenue), 2)                            AS revenue,
       ROUND(SUM(profit), 2)                             AS profit,
       ROUND(100.0 * SUM(profit) / SUM(revenue), 1)      AS margin_pct,
       ROUND(SUM(revenue) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM v_sales;

-- 2) How did revenue change from 2024 to 2025?
SELECT SUBSTR(order_date, 1, 4)  AS year,
       COUNT(DISTINCT order_id)  AS orders,
       ROUND(SUM(revenue), 2)    AS revenue
FROM v_sales
GROUP BY SUBSTR(order_date, 1, 4)
ORDER BY year;

-- 3) What does revenue look like month by month?
SELECT order_month,
       COUNT(DISTINCT order_id) AS orders,
       ROUND(SUM(revenue), 2)   AS revenue
FROM v_sales
GROUP BY order_month
ORDER BY order_month;

-- 4) Which categories make the most revenue and profit?
SELECT category,
       ROUND(SUM(revenue), 2)                       AS revenue,
       ROUND(SUM(profit), 2)                        AS profit,
       ROUND(100.0 * SUM(profit) / SUM(revenue), 1) AS margin_pct,
       SUM(quantity)                                AS units_sold
FROM v_sales
GROUP BY category
ORDER BY revenue DESC;

-- 5) What are the 10 best-selling products by revenue?
SELECT product_name,
       category,
       ROUND(SUM(revenue), 2) AS revenue,
       SUM(quantity)          AS units_sold
FROM v_sales
GROUP BY product_name, category
ORDER BY revenue DESC
LIMIT 10;

-- 6) Which countries bring in the most revenue?
SELECT c.country,
       COUNT(DISTINCT s.customer_id)                            AS buying_customers,
       ROUND(SUM(s.revenue), 2)                                 AS revenue,
       ROUND(SUM(s.revenue) / COUNT(DISTINCT s.customer_id), 2) AS revenue_per_customer
FROM v_sales s
JOIN v_customers c ON s.customer_id = c.customer_id
GROUP BY c.country
ORDER BY revenue DESC;

-- 7) Which sales channel has the most cancelled and returned orders?
SELECT channel,
       COUNT(*)                                                      AS total_orders,
       SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END)         AS cancelled,
       SUM(CASE WHEN status = 'Returned'  THEN 1 ELSE 0 END)         AS returned,
       ROUND(100.0 * SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END) / COUNT(*), 1) AS cancel_rate_pct
FROM orders
GROUP BY channel
ORDER BY total_orders DESC;

-- 8) Do bigger discounts hurt profit margin?
SELECT CASE WHEN discount = 0 THEN 'No discount'
            ELSE CAST(ROUND(discount * 100) AS INT) || '% off' END AS discount_tier,
       COUNT(*)                                     AS line_items,
       ROUND(SUM(revenue), 2)                       AS revenue,
       ROUND(100.0 * SUM(profit) / SUM(revenue), 1) AS margin_pct,
       ROUND(AVG(quantity), 2)                      AS avg_units_per_line
FROM v_sales
GROUP BY discount
ORDER BY discount;

-- 9) How many customers buy only once vs. come back? (subquery)
SELECT n_orders,
       COUNT(*) AS customers,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(DISTINCT customer_id) FROM v_sales), 1) AS pct_of_customers
FROM (
    SELECT customer_id, COUNT(DISTINCT order_id) AS n_orders
    FROM v_sales
    GROUP BY customer_id
)
GROUP BY n_orders
ORDER BY n_orders;

-- 10) Who are our 10 highest-spending customers?
SELECT c.customer_name,
       c.country,
       COUNT(DISTINCT s.order_id) AS orders,
       ROUND(SUM(s.revenue), 2)   AS total_spent
FROM v_sales s
JOIN v_customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name, c.country
ORDER BY total_spent DESC
LIMIT 10;

-- 11) Which days of the week are busiest?
SELECT CASE STRFTIME('%w', order_date)
            WHEN '0' THEN 'Sun' WHEN '1' THEN 'Mon' WHEN '2' THEN 'Tue' WHEN '3' THEN 'Wed'
            WHEN '4' THEN 'Thu' WHEN '5' THEN 'Fri' ELSE 'Sat' END AS weekday,
       COUNT(DISTINCT order_id) AS orders,
       ROUND(SUM(revenue), 2)   AS revenue
FROM v_sales
GROUP BY STRFTIME('%w', order_date)
ORDER BY STRFTIME('%w', order_date);
