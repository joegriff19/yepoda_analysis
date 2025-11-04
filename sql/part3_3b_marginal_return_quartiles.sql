-- part3_3b_marginal_return_quartiles.sql
-- Purpose: Calculate marginal return by dividing spend into quartiles and comparing ROAS levels.

WITH spend_long AS (
  SELECT date, 'paid_search' AS channel, paid_search_spend AS spend FROM marketing_spend UNION ALL
  SELECT date, 'paid_social', paid_social_spend FROM marketing_spend UNION ALL
  SELECT date, 'display', display_spend FROM marketing_spend UNION ALL
  SELECT date, 'email', email_spend FROM marketing_spend UNION ALL
  SELECT date, 'affiliate', affiliate_spend FROM marketing_spend UNION ALL
  SELECT date, 'tv', tv_spend FROM marketing_spend
),
by_day AS (
  SELECT sl.date, sl.channel, sl.spend, r.revenue
  FROM spend_long sl
  JOIN revenue r USING(date)
),
q AS (
  SELECT
    channel,
    date,
    spend,
    revenue,
    NTILE(4) OVER (PARTITION BY channel ORDER BY spend) AS spend_quartile
  FROM by_day
)
SELECT
  channel,
  spend_quartile,
  COUNT(*) AS days_in_quartile,
  AVG(spend) AS avg_spend,
  SUM(revenue) AS total_revenue,
  CASE WHEN AVG(spend) > 0 THEN SUM(revenue)/NULLIF(AVG(spend),0) ELSE NULL END AS approx_roas
FROM q
GROUP BY channel, spend_quartile
ORDER BY channel, spend_quartile;
