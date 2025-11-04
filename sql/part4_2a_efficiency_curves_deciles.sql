WITH spend_long AS (
  SELECT date, 'paid_search' AS channel, paid_search_spend AS spend FROM marketing_spend UNION ALL
  SELECT date, 'paid_social', paid_social_spend FROM marketing_spend UNION ALL
  SELECT date, 'display', display_spend FROM marketing_spend UNION ALL
  SELECT date, 'email', email_spend FROM marketing_spend UNION ALL
  SELECT date, 'affiliate', affiliate_spend FROM marketing_spend UNION ALL
  SELECT date, 'tv', tv_spend FROM marketing_spend
),
deciles AS (
  SELECT
    date,
    channel,
    spend,
    NTILE(10) OVER (PARTITION BY channel ORDER BY spend) AS spend_decile
  FROM spend_long
)
SELECT
  channel,
  spend_decile,
  COUNT(*) AS days_in_decile,
  AVG(spend) AS avg_spend
FROM deciles
GROUP BY channel, spend_decile
ORDER BY channel, spend_decile;
