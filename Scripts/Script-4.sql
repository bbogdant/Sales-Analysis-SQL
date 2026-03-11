WITH sales_data AS (
SELECT 
customerkey,
sum(quantity * netprice * exchangerate) AS net_revenue
FROM sales
GROUP BY customerkey
)

SELECT *
FROM customer c
LEFT JOIN sales_data s ON c.customerkey = s.customerkey;

EXPLAIN ANALYZE 
SELECT 
customerkey,
sum(quantity * netprice * exchangerate) AS net_revenue
FROM sales
WHERE orderdate >= '2024-01-01'
GROUP BY customerkey
