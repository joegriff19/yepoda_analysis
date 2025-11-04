# Marketing Analytics Case Study  
*SQL-based analysis of marketing spend efficiency, channel performance, and budget optimization.*

## Setup Instructions

### 1. Database and Data Setup
All analysis can be run in **DuckDB** or **PostgreSQL**.  
Create tables using `part1_1_load_data.sql`, which loads the three CSVs from the `/data` directory:
- `marketing_spend.csv`  
- `revenue.csv`  
- `external_factors.csv`  

Ensure file paths in SQL reference:  
```
Yepoda/data/<filename>.csv
```

### 2. SQL Dialect
All queries were developed and executed in DuckDB, using SQL that is fully compatible with both DuckDB and PostgreSQL.
- **DuckDB ≥ 0.10.1**  
- **PostgreSQL ≥ 14**  

### 3. Running the SQL Files
Run SQL files sequentially in your SQL client or via Jupyter once base tables are loaded.

Suggested order:
```
part1_1_load_data.sql
part1_2a_missing_values.sql
part1_2b_date_gaps.sql
part1_2c_outliers.sql
...
part4_3b_expected_revenue_impact.sql
```

The naming conventions refer to the prompts given for the case study. Each query produces a result in `/results/` with a matching CSV filename.

### 4. Assumptions
- **Revenue by channel** not available; total revenue used as proportional proxy for ROAS.  
- No missing or outlier values detected.  
- Two dates missing: `2023-10-29` and `2024-10-27`.  
