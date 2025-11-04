-- part1_4c_seasonal_trends.sql
-- Purpose: Analyze seasonality effects by averaging spend and revenue by month or quarter of the year.

WITH totals AS (
  SELECT
    ms.date,
    (paid_search_spend + paid_social_spend + display_spend + email_spend + affiliate_spend + tv_spend) AS total_spend,
    r.revenue,
    ef.seasonality_index,
    EXTRACT(QUARTER FROM ms.date) AS quarter
  FROM marketing_spend ms
  JOIN revenue r USING(date)
  LEFT JOIN external_factors ef USING(date)
)
SELECT
  quarter,
  AVG(seasonality_index) AS avg_seasonality_index,
  SUM(total_spend) AS quarter_spend,
  SUM(revenue) AS quarter_revenue,
  SUM(revenue)/NULLIF(SUM(total_spend),0) AS quarter_roas
FROM totals
GROUP BY quarter
ORDER BY quarter;
