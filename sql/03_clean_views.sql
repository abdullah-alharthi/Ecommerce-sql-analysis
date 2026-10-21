DROP VIEW IF EXISTS v_customers;
DROP VIEW IF EXISTS v_order_lines;
DROP VIEW IF EXISTS v_sales;

CREATE VIEW v_customers AS
SELECT customer_id,
       first_name || ' ' || last_name       AS customer_name,
       LOWER(TRIM(email))                   AS email,
       CASE UPPER(TRIM(country))
            WHEN 'SAUDI ARABIA' THEN 'Saudi Arabia'
            WHEN 'UK' THEN 'UK' WHEN 'US' THEN 'US' WHEN 'UAE' THEN 'UAE'
            ELSE SUBSTR(UPPER(TRIM(country)),1,1) || LOWER(SUBSTR(TRIM(country),2))
       END                                  AS country,
       COALESCE(city, 'Unknown')            AS city,
       signup_date
FROM customers;

CREATE VIEW v_order_lines AS
SELECT oi.order_item_id, o.order_id, o.customer_id, o.order_date,
       SUBSTR(o.order_date, 1, 7)           AS order_month,
       o.status, o.channel,
       p.product_id, p.product_name, p.category,
       oi.quantity, oi.discount,
       ROUND(oi.quantity * p.unit_price * (1 - oi.discount), 2) AS revenue,
       ROUND(oi.quantity * p.cost, 2)                           AS cogs,
       ROUND(oi.quantity * p.unit_price * (1 - oi.discount)
             - oi.quantity * p.cost, 2)                         AS profit
FROM order_items oi
JOIN orders   o USING (order_id)
JOIN products p USING (product_id);

CREATE VIEW v_sales AS
SELECT * FROM v_order_lines WHERE status = 'Completed';
