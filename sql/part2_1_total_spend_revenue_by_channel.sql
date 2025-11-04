-- part2_1_total_spend_revenue_by_channel.sql
-- Purpose: Calculate total spend and total revenue by channel over the full dataset period.

WITH spend_long AS (
  SELECT date, 'paid_search' AS channel, paid_search_spend AS spend FROM marketing_spend UNION ALL
  SELECT date, 'paid_social', paid_social_spend FROM marketing_spend UNION ALL
  SELECT date, 'display', display_spend FROM marketing_spend UNION ALL
  SELECT date, 'email', email_spend FROM marketing_spend UNION ALL
  SELECT date, 'affiliate', affiliate_spend FROM marketing_spend UNION ALL
  SELECT date, 'tv', tv_spend FROM marketing_spend
)
SELECT
  sl.channel,
  SUM(sl.spend) AS total_spend,
  SUM(r.revenue) AS total_revenue
FROM spend_long sl
JOIN revenue r USING(date)
GROUP BY sl.channel
ORDER BY total_revenue DESC;
