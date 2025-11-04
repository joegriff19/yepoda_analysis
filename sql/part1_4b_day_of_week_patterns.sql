WITH totals AS (
  SELECT
    ms.date,
    (paid_search_spend + paid_social_spend + display_spend + email_spend + affiliate_spend + tv_spend) AS total_spend,
    r.revenue
  FROM marketing_spend ms
  JOIN revenue r USING(date)
)
SELECT
  EXTRACT(DOW FROM date) AS dow,
  STRFTIME(date, '%A') AS dow_name,
  AVG(total_spend) AS avg_spend,
  AVG(revenue) AS avg_revenue,
  AVG(revenue) / NULLIF(AVG(total_spend), 0) AS avg_roas
FROM totals
GROUP BY 1, 2
ORDER BY dow;
