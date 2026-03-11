WITH customer_last_purchase	AS (
	SELECT 
	customerkey,
	clean_name,
	orderdate,
	row_number() OVER (PARTITION BY customerkey ORDER BY orderdate desc) AS rn,
	first_purchase_date,
	cohort_year 
	FROM
	cohort_analysis
	), churned_customers as(
		SELECT ALL customerkey,
		clean_name,
		orderdate AS last_purchase_date,
			CASE WHEN orderdate < (SELECT MAX(orderdate) FROM sales) - INTERVAL '6 months' THEN 'Churned' 
			ELSE 'Active'
			END AS customer_status,
			cohort_year 
		FROM customer_last_purchase 
		WHERE rn = 1
		AND first_purchase_date < (SELECT MAX(orderdate) FROM sales) - INTERVAL '6 months'
)
SELECT 
cohort_year,
customer_status,
count(customerkey) AS num_customers,
sum(count(customerkey)) over(PARTITION BY cohort_year ) AS total_customers,
round(count(customerkey) / sum(count(customerkey)) over(PARTITION BY cohort_year),2) AS status_percenatge
FROM churned_customers
GROUP BY cohort_year, customer_status

