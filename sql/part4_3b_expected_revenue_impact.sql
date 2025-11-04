-- Part 4.3b: Estimate revenue impact from reallocating existing budget (3 donors → top-performing receivers)

WITH spend_rows AS (
  SELECT date AS spend_date, 'paid_search' AS channel, paid_search_spend AS spend FROM marketing_spend UNION ALL
  SELECT date, 'paid_social', paid_social_spend FROM marketing_spend UNION ALL
  SELECT date, 'display', display_spend FROM marketing_spend UNION ALL
  SELECT date, 'email', email_spend FROM marketing_spend UNION ALL
  SELECT date, 'affiliate', affiliate_spend FROM marketing_spend UNION ALL
  SELECT date, 'tv', tv_spend FROM marketing_spend
),
channel_roas AS (
  SELECT
    s.channel,
    SUM(s.spend) AS total_spend,
    SUM(r.revenue) AS total_revenue_30d,
    CASE WHEN SUM(s.spend)>0 THEN SUM(r.revenue)/SUM(s.spend) ELSE NULL END AS roas_30d
  FROM spend_rows s
  LEFT JOIN revenue r ON r.date BETWEEN s.spend_date AND s.spend_date + INTERVAL 29 DAY
  GROUP BY s.channel
),
donors AS (
  SELECT channel, total_spend, roas_30d
  FROM channel_roas
  ORDER BY roas_30d ASC NULLS LAST
  FETCH FIRST 3 ROWS ONLY
),
decile_roas AS (
  SELECT
    channel,
    spend_decile,
    AVG(spend) AS avg_spend,
    SUM(revenue) AS total_revenue,
    CASE WHEN AVG(spend) > 0 THEN SUM(revenue) / NULLIF(AVG(spend),0) ELSE NULL END AS roas_decile
  FROM (
    SELECT sl.channel, sl.spend, r.revenue,
           NTILE(10) OVER (PARTITION BY sl.channel ORDER BY sl.spend) AS spend_decile
    FROM (
      SELECT date, 'paid_search' AS channel, paid_search_spend AS spend FROM marketing_spend UNION ALL
      SELECT date, 'paid_social', paid_social_spend FROM marketing_spend UNION ALL
      SELECT date, 'display', display_spend FROM marketing_spend UNION ALL
      SELECT date, 'email', email_spend FROM marketing_spend UNION ALL
      SELECT date, 'affiliate', affiliate_spend FROM marketing_spend UNION ALL
      SELECT date, 'tv', tv_spend FROM marketing_spend
    ) sl
    JOIN revenue r USING(date)
  ) t
  GROUP BY channel, spend_decile
),
ordered_receivers AS (
  SELECT channel, spend_decile, roas_decile
  FROM decile_roas
  ORDER BY roas_decile DESC NULLS LAST
  FETCH FIRST 6 ROWS ONLY
),
reallocation AS (
  SELECT SUM(total_spend)*0.10 AS total_to_reallocate FROM donors
),
expected_gain AS (
  SELECT SUM(
    (SELECT total_to_reallocate FROM reallocation)
      / NULLIF((SELECT COUNT(*) FROM ordered_receivers),0)
      * roas_decile
  ) AS reallocated_to_receivers
  FROM ordered_receivers
),
expected_loss AS (
  SELECT (SELECT SUM(total_spend) FROM donors) * 0.10 * AVG(roas_30d) AS reallocated_from_donors
  FROM donors
)
SELECT
  (SELECT reallocated_to_receivers FROM expected_gain)  AS reallocated_to_receivers,
  (SELECT reallocated_from_donors FROM expected_loss)   AS reallocated_from_donors,
  (SELECT total_to_reallocate FROM reallocation)        AS total_budget_reallocated;
