-- part3_2c_weekend_impact.sql
-- Purpose: Measure the impact of weekends on average daily revenue relative to weekdays.

SELECT
  AVG(CASE WHEN is_weekend THEN revenue END) AS avg_rev_weekend,
  AVG(CASE WHEN NOT is_weekend THEN revenue END) AS avg_rev_weekday,
  (AVG(CASE WHEN is_weekend THEN revenue END) / NULLIF(AVG(CASE WHEN NOT is_weekend THEN revenue END),0) - 1) AS pct_lift
FROM revenue r
LEFT JOIN external_factors ef USING(date);
