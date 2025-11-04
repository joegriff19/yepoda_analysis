WITH spend_rows AS (
  SELECT ms.date AS spend_date, 'paid_search' AS channel, paid_search_spend AS spend FROM marketing_spend ms UNION ALL
  SELECT ms.date, 'paid_social', paid_social_spend FROM marketing_spend ms UNION ALL
  SELECT ms.date, 'display', display_spend FROM marketing_spend ms UNION ALL
  SELECT ms.date, 'email', email_spend FROM marketing_spend ms UNION ALL
  SELECT ms.date, 'affiliate', affiliate_spend FROM marketing_spend ms UNION ALL
  SELECT ms.date, 'tv', tv_spend FROM marketing_spend ms
),
typed AS (
  SELECT
    s.channel,
    COALESCE(ef.promotion_active, FALSE) AS promotion_active,
    s.spend_date,
    s.spend
  FROM spend_rows s
  LEFT JOIN external_factors ef ON ef.date = s.spend_date
),
att30 AS (
  SELECT
    t.channel,
    t.promotion_active,
    SUM(t.spend) AS total_spend,
    SUM(r.revenue) AS total_revenue_30d
  FROM typed t
  LEFT JOIN revenue r ON r.date BETWEEN t.spend_date AND t.spend_date + INTERVAL '29 day'
  GROUP BY t.channel, t.promotion_active
)
SELECT
  channel,
  promotion_active,
  total_spend,
  total_revenue_30d,
  total_revenue_30d/NULLIF(total_spend,0) AS roas_30d
FROM att30
ORDER BY channel, promotion_active DESC;
