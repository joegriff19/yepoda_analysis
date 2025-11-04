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
),
deciles AS (
  SELECT
    date,
    channel,
    spend,
    revenue,
    NTILE(10) OVER (PARTITION BY channel ORDER BY spend) AS spend_decile
  FROM joined
),
daily_roas AS (
  SELECT
    date,
    channel,
    spend_decile,
    spend,
    CASE WHEN spend > 0 THEN revenue / spend ELSE NULL END AS roas
  FROM deciles
)
SELECT
  channel,
  spend_decile,
  COUNT(*) AS days_in_decile,
  AVG(spend) AS avg_spend,
  AVG(roas) AS avg_roas
FROM daily_roas
GROUP BY channel, spend_decile
ORDER BY channel, spend_decile;
