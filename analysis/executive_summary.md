# Marketing Analytics Case Study – Executive Summary

**Note:** Revenue data was not available by channel, and I did not want to make any assumptions about how individual channel spends and revenue might be related.  

To answer the questions in the way they were intended, total revenue has been used to calculate ROAS as a proportional proxy across total spend. Any results with ROAS should not be considered as true causal performance measures.

---

## 1. Key Findings
- **Overall performance declined over time**, with ROAS decreasing substantially — **from >5 monthly in H1 2023 to <4.5 monthly in H2 2024.**  
- **External factors strongly influenced revenue** — holidays drove a 19% lift, promotions a 15% lift, and weekends an 11% lift.  
- **Seasonality was highly correlated with revenue** (Pearson correlation = 0.898), suggesting predictable cyclical patterns.  
- **Paid search and paid social dominated total spend**, together accounting for nearly half of total investment.  
- No missing or outlier values were found, but two calendar dates were absent (2023-10-29 and 2024-10-27).

---

## 2. Channel Performance Rankings with Supporting Metrics
Using total revenue as a proportional proxy for ROAS:

| Rank | Channel        | Total Spend (€) | Relative ROAS (proxy) | Notes |
|------|----------------|----------------|-----------------------|-------|
| 1 | Email | 399,897 | Highest | Most efficient under equal-revenue assumption |
| 2 | Affiliate | 803,094 | High | Low spend, solid efficiency |
| 3 | Display | 1,198,983 | Moderate | Balanced investment |
| 4 | TV | 1,599,736 | Moderate-Low | Scaled reach, reduced efficiency |
| 5 | Paid Social | 2,009,386 | Low | High cost base |
| 6 | Paid Search | 2,414,099 | Lowest | Largest investment, least efficient by proxy |

*(Interpretation assumes constant revenue across channels — lower spend → higher ROAS.)*

---

## 3. Budget Optimization Recommendations and Expected Impact
- A **10% budget reallocation** from the three lowest-ROAS channels (paid search, paid social, TV) to the three highest (email, affiliate, display) is recommended under this proportional ROAS assumption.  
- The reallocation was modeled proportionally, keeping total spend constant.  
- Channels receiving budget were weighted by their existing spend share to maintain relative scale.  
- Based on historical ROAS relationships, this shift is expected to **improve efficiency without increasing total budget**.

---

## 4. Data Quality Issues or Limitations
- As mentioned above, **revenue by channel is unavailable**, limiting true ROAS and causal analysis.  
- Two dates (2023-10-29 and 2024-10-27) are missing from the dataset.  
- No missing values or statistical outliers were detected in spend or revenue.  
- Without impression or click data, it was not possible to validate upper-funnel contribution or model diminishing returns.

---

## 5. Suggested Next Steps for Deeper Analysis
- **Integrate revenue by channel** to enable accurate ROAS and incrementality modeling.  
- **Develop channel-level response (saturation) curves** to identify diminishing returns and optimal spend points.  
- **Incorporate MMM or geo-testing frameworks** to estimate incremental lift more precisely.  
- **Segment analysis by market ** to detect regional performance differences.  
- **Automate weekly refreshes** of this SQL pipeline for continuous budget tracking.

---

*Prepared using DuckDB SQL. All queries are compatible with PostgreSQL and documented in the `/sql` directory.*
