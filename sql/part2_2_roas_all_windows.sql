-- part2_2_roas_all_windows.sql
-- Purpose: Compute 7-day, 14-day, and 30-day ROAS attribution windows for each marketing channel.
-- Attribution logic:
--   - Each day's spend is assumed to influence revenue over a future window (7, 14, or 30 days).
--   - For example, spend on Jan 1 contributes to revenue observed from Jan 1–7 for the 7-day window.
--   - This creates a rolling (non-exclusive) attribution model, meaning multiple spend days can contribute
--     to the same revenue period — appropriate when conversion lag is distributed rather than discrete.
--   - ROAS = SUM(attributed revenue over window) / SUM(spend)
--   - This model assumes equal weighting of spend across the attribution window (i.e., no decay function).

WITH base AS (
  SELECT
    ms.date,
    r.revenue,
    ms.paid_search_spend,
    ms.paid_social_spend,
    ms.display_spend,
    ms.email_spend,
    ms.affiliate_spend,
    ms.tv_spend
  FROM marketing_spend ms
  JOIN revenue r USING(date)
),

-- Unpivot marketing spend to long format for per-channel attribution
spend_long AS (
  SELECT date, 'paid_search' AS channel, paid_search_spend AS spend FROM base UNION ALL
  SELECT date, 'paid_social', paid_social_spend FROM base UNION ALL
  SELECT date, 'display', display_spend FROM base UNION ALL
  SELECT date, 'email', email_spend FROM base UNION ALL
  SELECT date, 'affiliate', affiliate_spend FROM base UNION ALL
  SELECT date, 'tv', tv_spend FROM base
),

-- Rolling attribution logic:
--   For each channel and spend date, sum all revenue that occurs within 7, 14, and 30 days after spend.
--   Example: Spend on March 1 contributes to revenue through March 7 (7-day), March 14 (14-day), and March 30 (30-day).
attributed AS (
  SELECT
    s.channel,
    s.date AS spend_date,
    s.spend,
    SUM(r7.revenue)  AS revenue_7d,
    SUM(r14.revenue) AS revenue_14d,
    SUM(r30.revenue) AS revenue_30d
  FROM spend_long s
  LEFT JOIN revenue r7
    ON r7.date BETWEEN s.date AND s.date + INTERVAL 6 DAY
  LEFT JOIN revenue r14
    ON r14.date BETWEEN s.date AND s.date + INTERVAL 13 DAY
  LEFT JOIN revenue r30
    ON r30.date BETWEEN s.date AND s.date + INTERVAL 29 DAY
  GROUP BY s.channel, s.date, s.spend
),

-- Aggregate to channel-level totals for comparison across attribution windows.
channel_roas AS (
  SELECT
    channel,
    SUM(spend) AS total_spend,
    SUM(revenue_7d)  AS total_rev_7d,
    SUM(revenue_14d) AS total_rev_14d,
    SUM(revenue_30d) AS total_rev_30d,
    SUM(revenue_7d)  / NULLIF(SUM(spend), 0) AS roas_7d,
    SUM(revenue_14d) / NULLIF(SUM(spend), 0) AS roas_14d,
    SUM(revenue_30d) / NULLIF(SUM(spend), 0) AS roas_30d
  FROM attributed
  GROUP BY channel
)

-- Final output: ROAS and total attributed revenue by channel for 7-, 14-, and 30-day windows.
SELECT
  channel,
  total_spend,
  total_rev_7d,
  roas_7d,
  total_rev_14d,
  roas_14d,
  total_rev_30d,
  roas_30d
FROM channel_roas
ORDER BY channel;
