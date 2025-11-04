WITH marketing_missing AS (
  SELECT 'marketing_spend' AS table_name, 'date' AS column_name, COUNT(*) FILTER (WHERE date IS NULL) AS missing_count FROM marketing_spend
  UNION ALL SELECT 'marketing_spend', 'paid_search_spend', COUNT(*) FILTER (WHERE paid_search_spend IS NULL) FROM marketing_spend
  UNION ALL SELECT 'marketing_spend', 'paid_social_spend', COUNT(*) FILTER (WHERE paid_social_spend IS NULL) FROM marketing_spend
  UNION ALL SELECT 'marketing_spend', 'display_spend', COUNT(*) FILTER (WHERE display_spend IS NULL) FROM marketing_spend
  UNION ALL SELECT 'marketing_spend', 'email_spend', COUNT(*) FILTER (WHERE email_spend IS NULL) FROM marketing_spend
  UNION ALL SELECT 'marketing_spend', 'affiliate_spend', COUNT(*) FILTER (WHERE affiliate_spend IS NULL) FROM marketing_spend
  UNION ALL SELECT 'marketing_spend', 'tv_spend', COUNT(*) FILTER (WHERE tv_spend IS NULL) FROM marketing_spend
),
revenue_missing AS (
  SELECT 'revenue', 'date', COUNT(*) FILTER (WHERE date IS NULL) FROM revenue
  UNION ALL SELECT 'revenue', 'revenue', COUNT(*) FILTER (WHERE revenue IS NULL) FROM revenue
  UNION ALL SELECT 'revenue', 'transactions', COUNT(*) FILTER (WHERE transactions IS NULL) FROM revenue
  UNION ALL SELECT 'revenue', 'new_customers', COUNT(*) FILTER (WHERE new_customers IS NULL) FROM revenue
),
external_missing AS (
  SELECT 'external_factors', 'date', COUNT(*) FILTER (WHERE date IS NULL) FROM external_factors
  UNION ALL SELECT 'external_factors', 'is_weekend', COUNT(*) FILTER (WHERE is_weekend IS NULL) FROM external_factors
  UNION ALL SELECT 'external_factors', 'is_holiday', COUNT(*) FILTER (WHERE is_holiday IS NULL) FROM external_factors
  UNION ALL SELECT 'external_factors', 'promotion_active', COUNT(*) FILTER (WHERE promotion_active IS NULL) FROM external_factors
  UNION ALL SELECT 'external_factors', 'competitor_index', COUNT(*) FILTER (WHERE competitor_index IS NULL) FROM external_factors
  UNION ALL SELECT 'external_factors', 'seasonality_index', COUNT(*) FILTER (WHERE seasonality_index IS NULL) FROM external_factors
)
SELECT * FROM marketing_missing
UNION ALL
SELECT * FROM revenue_missing
UNION ALL
SELECT * FROM external_missing
ORDER BY table_name, column_name;
