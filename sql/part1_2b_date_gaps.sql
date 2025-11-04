WITH bounds AS (
  SELECT MIN(date) AS min_date, MAX(date) AS max_date FROM marketing_spend
),
calendar AS (
  SELECT UNNEST(generate_series(
      (SELECT min_date FROM bounds),
      (SELECT max_date FROM bounds),
      INTERVAL 1 DAY
  )) AS date
)
SELECT
  c.date,
  CASE WHEN ms.date IS NOT NULL THEN 1 ELSE 0 END AS has_marketing_spend,
  CASE WHEN rv.date IS NOT NULL THEN 1 ELSE 0 END AS has_revenue,
  CASE WHEN ef.date IS NOT NULL THEN 1 ELSE 0 END AS has_external
FROM calendar c
LEFT JOIN marketing_spend ms ON c.date = ms.date
LEFT JOIN revenue rv ON c.date = rv.date
LEFT JOIN external_factors ef ON c.date = ef.date
WHERE ms.date IS NULL OR rv.date IS NULL OR ef.date IS NULL
ORDER BY c.date;
