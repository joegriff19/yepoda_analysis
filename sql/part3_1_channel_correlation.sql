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
  corr(spend, revenue) AS pearson_corr,
  COUNT(*) AS days
FROM joined
GROUP BY channel
ORDER BY pearson_corr DESC NULLS LAST;
