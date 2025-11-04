WITH spend_rows AS (
  SELECT date AS spend_date, 'paid_search' AS channel, paid_search_spend AS spend FROM marketing_spend UNION ALL
  SELECT date, 'paid_social', paid_social_spend FROM marketing_spend UNION ALL
  SELECT date, 'display', display_spend FROM marketing_spend UNION ALL
  SELECT date, 'email', email_spend FROM marketing_spend UNION ALL
  SELECT date, 'affiliate', affiliate_spend FROM marketing_spend UNION ALL
  SELECT date, 'tv', tv_spend FROM marketing_spend
),
att30 AS (
  SELECT s.channel AS channel, SUM(r.revenue) AS total_revenue_30d
  FROM spend_rows s
  LEFT JOIN revenue r ON r.date BETWEEN s.spend_date AND s.spend_date + INTERVAL '29 day'
  GROUP BY s.channel
)
SELECT channel, total_revenue_30d
FROM att30
ORDER BY total_revenue_30d DESC;
