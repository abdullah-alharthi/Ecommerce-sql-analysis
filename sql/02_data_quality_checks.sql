SELECT 'customers' AS tbl, COUNT(*) AS n FROM customers
UNION ALL SELECT 'products',    COUNT(*) FROM products
UNION ALL SELECT 'orders',      COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items;

SELECT 'Missing email'                    AS issue, COUNT(*) AS rows_affected FROM customers WHERE email IS NULL
UNION ALL
SELECT 'Missing city',                    COUNT(*) FROM customers WHERE city IS NULL
UNION ALL
SELECT 'Country has stray spaces/lowercase', COUNT(*) FROM customers WHERE country <> TRIM(country) OR country = LOWER(country)
UNION ALL
SELECT 'Orphan orders (no customer)',     COUNT(*) FROM orders o LEFT JOIN customers c USING (customer_id) WHERE c.customer_id IS NULL
UNION ALL
SELECT 'Orphan items (no order)',         COUNT(*) FROM order_items oi LEFT JOIN orders o USING (order_id) WHERE o.order_id IS NULL
UNION ALL
SELECT 'Orders without items',            COUNT(*) FROM orders o LEFT JOIN order_items oi USING (order_id) WHERE oi.order_id IS NULL
UNION ALL
SELECT 'Order placed before signup',      COUNT(*) FROM orders o JOIN customers c USING (customer_id) WHERE o.order_date < c.signup_date
UNION ALL
SELECT 'Products sold below cost',        COUNT(*) FROM products WHERE unit_price < cost;

SELECT '[' || country || ']' AS raw_country_value, COUNT(*) AS customers
FROM customers
GROUP BY country
ORDER BY UPPER(TRIM(country)), customers DESC;
