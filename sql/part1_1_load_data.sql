-- part1_1_load_data.sql
-- Purpose: Create tables from the three CSV files (marketing_spend, revenue, external_factors) and define schema.


-- Load marketing_spend
CREATE OR REPLACE TABLE marketing_spend AS
SELECT
  CAST(date AS DATE) AS date,
  CAST(paid_search_spend AS DOUBLE) AS paid_search_spend,
  CAST(paid_social_spend AS DOUBLE) AS paid_social_spend,
  CAST(display_spend AS DOUBLE) AS display_spend,
  CAST(email_spend AS DOUBLE) AS email_spend,
  CAST(affiliate_spend AS DOUBLE) AS affiliate_spend,
  CAST(tv_spend AS DOUBLE) AS tv_spend
FROM read_csv_auto('data/marketing_spend.csv', header=TRUE);

-- Load revenue
CREATE OR REPLACE TABLE revenue AS
SELECT
  CAST(date AS DATE) AS date,
  CAST(revenue AS DOUBLE) AS revenue,
  CAST(transactions AS INTEGER) AS transactions,
  CAST(new_customers AS INTEGER) AS new_customers
FROM read_csv_auto('data/revenue.csv', header=TRUE);

-- Load external_factors
CREATE OR REPLACE TABLE external_factors AS
SELECT
  CAST(date AS DATE) AS date,
  CASE 
    WHEN LOWER(TRIM(CAST(is_weekend AS VARCHAR))) IN ('1','true','t','yes','y') THEN TRUE 
    ELSE FALSE 
  END AS is_weekend,
  CASE 
    WHEN LOWER(TRIM(CAST(is_holiday AS VARCHAR))) IN ('1','true','t','yes','y') THEN TRUE 
    ELSE FALSE 
  END AS is_holiday,
  CASE 
    WHEN LOWER(TRIM(CAST(promotion_active AS VARCHAR))) IN ('1','true','t','yes','y') THEN TRUE 
    ELSE FALSE 
  END AS promotion_active,
  CAST(competitor_index AS DOUBLE) AS competitor_index,
  CAST(seasonality_index AS DOUBLE) AS seasonality_index
FROM read_csv_auto('data/external_factors.csv', header=TRUE);
