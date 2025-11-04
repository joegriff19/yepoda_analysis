WITH spend_long AS (
  SELECT date, 'paid_search' AS channel, paid_search_spend AS spend FROM marketing_spend UNION ALL
  SELECT date, 'paid_social', paid_social_spend FROM marketing_spend UNION ALL
  SELECT date, 'display', display_spend FROM marketing_spend UNION ALL
  SELECT date, 'email', email_spend FROM marketing_spend UNION ALL
  SELECT date, 'affiliate', affiliate_spend FROM marketing_spend UNION ALL
  SELECT date, 'tv', tv_spend FROM marketing_spend
),
joined AS (
  SELECT sl.date, sl.channel, sl.spend, r.revenue
  FROM spend_long sl
  JOIN revenue r USING(date)
)
SELECT
  channel,
  AVG(CASE WHEN spend = 0 THEN revenue END) AS avg_rev_when_zero_spend,
  AVG(CASE WHEN spend > 0 THEN revenue END) AS avg_rev_when_spend,
  (AVG(CASE WHEN spend > 0 THEN revenue END) - AVG(CASE WHEN spend = 0 THEN revenue END)) AS rev_diff,
  CASE WHEN AVG(CASE WHEN spend = 0 THEN revenue END) IS NULL OR AVG(CASE WHEN spend = 0 THEN revenue END) = 0
       THEN NULL
       ELSE (AVG(CASE WHEN spend > 0 THEN revenue END) / AVG(CASE WHEN spend = 0 THEN revenue END) - 1)
  END AS pct_lift_when_spend
FROM joined
GROUP BY channel
ORDER BY rev_diff DESC;
