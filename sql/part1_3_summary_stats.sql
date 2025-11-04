WITH spend_long AS (
  SELECT date, 'paid_search' AS channel, paid_search_spend AS spend FROM marketing_spend UNION ALL
  SELECT date, 'paid_social', paid_social_spend FROM marketing_spend UNION ALL
  SELECT date, 'display', display_spend FROM marketing_spend UNION ALL
  SELECT date, 'email', email_spend FROM marketing_spend UNION ALL
  SELECT date, 'affiliate', affiliate_spend FROM marketing_spend UNION ALL
  SELECT date, 'tv', tv_spend FROM marketing_spend
)
SELECT
  channel,
  COUNT(*) AS observations,
  SUM(spend) AS total_spend,
  AVG(spend) AS avg_spend,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY spend) AS median_spend,
  STDDEV(spend) AS sd_spend,
  MIN(spend) AS min_spend,
  MAX(spend) AS max_spend
FROM spend_long
GROUP BY channel
ORDER BY total_spend DESC;