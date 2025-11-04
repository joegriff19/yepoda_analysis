-- part4_3a_budget_reallocation.sql
-- Purpose: Reallocate 10% of total spend from the 3 lowest-ROAS channels (donors)
-- to the 3 highest-ROAS channels (receivers), calculating current vs recommended spend.

WITH spend_rows AS (
  SELECT date AS spend_date, 'paid_search' AS channel, paid_search_spend AS spend FROM marketing_spend UNION ALL
  SELECT date, 'paid_social', paid_social_spend FROM marketing_spend UNION ALL
  SELECT date, 'display', display_spend FROM marketing_spend UNION ALL
  SELECT date, 'email', email_spend FROM marketing_spend UNION ALL
  SELECT date, 'affiliate', affiliate_spend FROM marketing_spend UNION ALL
  SELECT date, 'tv', tv_spend FROM marketing_spend
),

-- Calculate total spend and 30-day attributed revenue per channel
channel_roas AS (
  SELECT
    s.channel,
    SUM(s.spend) AS total_spend,
    SUM(r.revenue) AS total_revenue_30d,
    CASE WHEN SUM(s.spend) > 0 THEN SUM(r.revenue) / SUM(s.spend) ELSE NULL END AS roas_30d
  FROM spend_rows s
  LEFT JOIN revenue r
    ON r.date BETWEEN s.spend_date AND s.spend_date + INTERVAL 29 DAY
  GROUP BY s.channel
),

-- Select 3 lowest and 3 highest performers by ROAS
donors AS (
  SELECT channel, total_spend, roas_30d
  FROM channel_roas
  ORDER BY roas_30d ASC NULLS LAST
  LIMIT 3
),
receivers AS (
  SELECT channel, total_spend, roas_30d
  FROM channel_roas
  ORDER BY roas_30d DESC NULLS LAST
  LIMIT 3
),

-- Determine total amount to reallocate (10% of donor spend)
reallocation AS (
  SELECT SUM(total_spend) * 0.10 AS total_to_move FROM donors
),

-- Compute receiver weights based on their current spend share
receiver_weights AS (
  SELECT
    channel,
    total_spend,
    total_spend / NULLIF((SELECT SUM(total_spend) FROM receivers), 0) AS weight
  FROM receivers
)

-- Apply reallocation: reduce donors, increase receivers
SELECT
  cr.channel,
  cr.total_spend AS current_spend,
  CASE
    WHEN rw.channel IS NOT NULL THEN cr.total_spend + ((SELECT total_to_move FROM reallocation) * rw.weight)
    WHEN d.channel IS NOT NULL THEN cr.total_spend - ((SELECT total_to_move FROM reallocation) * (d.total_spend / (SELECT SUM(total_spend) FROM donors)))
    ELSE cr.total_spend
  END AS recommended_spend
FROM channel_roas cr
LEFT JOIN receiver_weights rw ON cr.channel = rw.channel
LEFT JOIN donors d ON cr.channel = d.channel
ORDER BY recommended_spend DESC;

