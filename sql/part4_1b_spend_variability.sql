-- part4_1b_spend_variability.sql
-- Purpose: Calculate standard deviation and coefficient of variation of daily spend by channel.

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
  COUNT(*) AS days_observed,
  AVG(spend) AS avg_spend,
  STDDEV(spend) AS stddev_spend,
  CASE WHEN AVG(spend)=0 THEN NULL ELSE STDDEV(spend)/NULLIF(AVG(spend),0) END AS coeff_var
FROM spend_long
GROUP BY channel
ORDER BY coeff_var DESC NULLS LAST;
