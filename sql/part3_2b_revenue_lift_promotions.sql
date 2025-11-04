SELECT
  AVG(CASE WHEN promotion_active THEN revenue END) AS avg_rev_promo,
  AVG(CASE WHEN NOT promotion_active THEN revenue END) AS avg_rev_non_promo,
  (AVG(CASE WHEN promotion_active THEN revenue END) / NULLIF(AVG(CASE WHEN NOT promotion_active THEN revenue END),0) - 1) AS pct_lift
FROM revenue r
LEFT JOIN external_factors ef USING(date);
