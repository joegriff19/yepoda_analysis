-- part3_2d_seasonality_effect.sql
-- Purpose: Evaluate correlation between seasonality index and revenue to measure cyclical effects.

SELECT
  AVG(ef.seasonality_index) AS avg_seasonality_index,
  AVG(r.revenue) AS avg_revenue,
  corr(ef.seasonality_index, r.revenue) AS pearson_corr
FROM revenue r
LEFT JOIN external_factors ef USING(date);
