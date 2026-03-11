SELECT 
cohort_year,
sum(ca.total_net_revenue)
FROM cohort_analysis ca 
GROUP BY cohort_year