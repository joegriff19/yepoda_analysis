WITH total_spend AS (
  SELECT
    date,
    (paid_search_spend + paid_social_spend + display_spend + email_spend + affiliate_spend + tv_spend) AS total_spend
  FROM marketing_spend
)
SELECT
  DATE_TRUNC('month', t.date)::date AS month,
  SUM(t.total_spend) AS monthly_spend,
  SUM(r.revenue) AS monthly_revenue,
  SUM(r.revenue)/NULLIF(SUM(t.total_spend),0) AS monthly_roas
FROM total_spend t
JOIN revenue r ON r.date = t.date
GROUP BY 1
ORDER BY 1;
