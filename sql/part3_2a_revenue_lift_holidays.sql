SELECT
  AVG(CASE WHEN is_holiday THEN revenue END) AS avg_rev_holiday,
  AVG(CASE WHEN NOT is_holiday THEN revenue END) AS avg_rev_non_holiday,
  (AVG(CASE WHEN is_holiday THEN revenue END) / NULLIF(AVG(CASE WHEN NOT is_holiday THEN revenue END),0) - 1) AS pct_lift
FROM revenue r
LEFT JOIN external_factors ef USING(date);
