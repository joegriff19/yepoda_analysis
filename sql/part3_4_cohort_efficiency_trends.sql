WITH spend_rows AS (
  SELECT date AS spend_date, 'paid_search' AS channel, paid_search_spend AS spend FROM marketing_spend UNION ALL
  SELECT date, 'paid_social', paid_social_spend FROM marketing_spend UNION ALL
  SELECT date, 'display', display_spend FROM marketing_spend UNION ALL
  SELECT date, 'email', email_spend FROM marketing_spend UNION ALL
  SELECT date, 'affiliate', affiliate_spend FROM marketing_spend UNION ALL
  SELECT date, 'tv', tv_spend FROM marketing_spend
),
cohort_spend AS (
  SELECT
    DATE_TRUNC('quarter', spend_date)::date AS cohort_quarter_start,
    channel,
    SUM(spend) AS cohort_spend
  FROM spend_rows
  GROUP BY 1,2
),
cohort_attr AS (
  SELECT
    DATE_TRUNC('quarter', s.spend_date)::date AS cohort_quarter_start,
    s.channel,
    SUM(r.revenue) AS cohort_attr_revenue_30d
  FROM spend_rows s
  LEFT JOIN revenue r ON r.date BETWEEN s.spend_date AND s.spend_date + INTERVAL '29 day'
  GROUP BY 1,2
)
SELECT
  cs.cohort_quarter_start,
  cs.channel,
  cs.cohort_spend,
  COALESCE(ca.cohort_attr_revenue_30d,0) AS cohort_attr_revenue_30d,
  CASE WHEN cs.cohort_spend > 0 THEN COALESCE(ca.cohort_attr_revenue_30d,0)/cs.cohort_spend ELSE NULL END AS cohort_roas_30d
FROM cohort_spend cs
LEFT JOIN cohort_attr ca
  ON cs.channel = ca.channel AND cs.cohort_quarter_start = ca.cohort_quarter_start
ORDER BY cs.cohort_quarter_start, cs.channel;
