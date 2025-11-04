WITH spend_rows AS (
  SELECT date AS spend_date, 'paid_search' AS channel, paid_search_spend AS spend FROM marketing_spend UNION ALL
  SELECT date, 'paid_social', paid_social_spend FROM marketing_spend UNION ALL
  SELECT date, 'display', display_spend FROM marketing_spend UNION ALL
  SELECT date, 'email', email_spend FROM marketing_spend UNION ALL
  SELECT date, 'affiliate', affiliate_spend FROM marketing_spend UNION ALL
  SELECT date, 'tv', tv_spend FROM marketing_spend
),
monthly AS (
  SELECT
    DATE_TRUNC('month', s.spend_date)::date AS month,
    s.channel,
    SUM(s.spend) AS month_spend,
    SUM(r.revenue) AS month_attr_revenue_30d
  FROM spend_rows s
  LEFT JOIN revenue r ON r.date BETWEEN s.spend_date AND s.spend_date + INTERVAL '29 day'
  GROUP BY 1,2
),
quarterly AS (
  SELECT
    DATE_TRUNC('quarter', s.spend_date)::date AS quarter_start,
    s.channel,
    SUM(s.spend) AS q_spend,
    SUM(r.revenue) AS q_attr_revenue_30d
  FROM spend_rows s
  LEFT JOIN revenue r ON r.date BETWEEN s.spend_date AND s.spend_date + INTERVAL '29 day'
  GROUP BY 1,2
)
SELECT 'month' AS period, month AS period_start, channel, month_spend AS spend, month_attr_revenue_30d AS revenue, month_attr_revenue_30d/NULLIF(month_spend,0) AS roas
FROM monthly
UNION ALL
SELECT 'quarter', quarter_start, channel, q_spend, q_attr_revenue_30d, q_attr_revenue_30d/NULLIF(q_spend,0)
FROM quarterly
ORDER BY period, period_start, channel;
