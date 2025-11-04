WITH spend_long AS (
  SELECT date, 'paid_search' AS channel, paid_search_spend AS spend FROM marketing_spend UNION ALL
  SELECT date, 'paid_social', paid_social_spend FROM marketing_spend UNION ALL
  SELECT date, 'display', display_spend FROM marketing_spend UNION ALL
  SELECT date, 'email', email_spend FROM marketing_spend UNION ALL
  SELECT date, 'affiliate', affiliate_spend FROM marketing_spend UNION ALL
  SELECT date, 'tv', tv_spend FROM marketing_spend
),
channel_bounds AS (
  SELECT
    channel,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY spend) AS q1,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY spend) AS q3
  FROM spend_long
  WHERE spend IS NOT NULL
  GROUP BY channel
),
spend_outliers AS (
  SELECT sl.date, sl.channel, sl.spend,
         CASE WHEN sl.spend < cb.q1 - 1.5*(cb.q3-cb.q1) OR sl.spend > cb.q3 + 1.5*(cb.q3-cb.q1) THEN TRUE ELSE FALSE END AS is_outlier
  FROM spend_long sl
  JOIN channel_bounds cb USING(channel)
  WHERE sl.spend IS NOT NULL
),
rev_bounds AS (
  SELECT
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY revenue) AS q1,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY revenue) AS q3
  FROM revenue
),
revenue_outliers AS (
  SELECT r.date, r.revenue,
         CASE WHEN r.revenue < rb.q1 - 1.5*(rb.q3-rb.q1) OR r.revenue > rb.q3 + 1.5*(rb.q3-rb.q1) THEN TRUE ELSE FALSE END AS is_outlier
  FROM revenue r, rev_bounds rb
)
SELECT 'spend' AS metric_type, date, channel, spend AS value, is_outlier FROM spend_outliers
UNION ALL
SELECT 'revenue', date, NULL AS channel, revenue AS value, is_outlier FROM revenue_outliers
ORDER BY metric_type, date;
