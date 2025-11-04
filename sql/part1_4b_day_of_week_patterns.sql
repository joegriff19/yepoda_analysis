-- part1_4b_day_of_week_patterns.sql
-- Analyze day-of-week patterns in marketing performance by calculating
-- average spend, revenue, and ROAS for each day of the week.

WITH totals AS (
  SELECT
    ms.date,
    (paid_search_spend + paid_social_spend + display_spend + email_spend + affiliate_spend + tv_spend) AS total_spend,
    r.revenue
  FROM marketing_spend ms
  JOIN revenue r USING(date)
),
dow_labels AS (
  SELECT
    date,
    EXTRACT(DOW FROM date) AS dow,
    CASE
      WHEN EXTRACT(DOW FROM date) = 0 THEN 'Sunday'
      WHEN EXTRACT(DOW FROM date) = 1 THEN 'Monday'
      WHEN EXTRACT(DOW FROM date) = 2 THEN 'Tuesday'
      WHEN EXTRACT(DOW FROM date) = 3 THEN 'Wednesday'
      WHEN EXTRACT(DOW FROM date) = 4 THEN 'Thursday'
      WHEN EXTRACT(DOW FROM date) = 5 THEN 'Friday'
      WHEN EXTRACT(DOW FROM date) = 6 THEN 'Saturday'
    END AS dow_name
  FROM marketing_spend
)
SELECT
  dl.dow,
  dl.dow_name,
  AVG(t.total_spend) AS avg_spend,
  AVG(t.revenue) AS avg_revenue,
  AVG(t.revenue) / NULLIF(AVG(t.total_spend), 0) AS avg_roas
FROM totals t
JOIN dow_labels dl USING(date)
GROUP BY 1, 2
ORDER BY dl.dow;