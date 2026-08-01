Healthcare Fraud Analysis

Business Question : What characteristics distinguish fraudulent healthcare provider from non-fraudulent ones?

Tools : SQL, Excel and Power BI
DataSet : (https://www.kaggle.com/datasets/rohitrox/healthcare-provider-fraud-detection-analysis) — 5,410 providers and 558K claims.

## Key Findings :
    1. Fraudulent Providers treats --6x more claims per provider (420.55 vs 70.44).
    2. Fraudulent Providers have --2.5x higher average claim amount per provider ($3,842.80 vs $1,523.78).
    3. Fraudulent Providers treat --5x more inpatient per provider (53.19 vs 10.33)
    4. Patient age and chronic condition have no meaningful difference between groups

## Conclusion : Fraud risk is strongly tied to billings behaviour than patient characteristics.
## Approach :
  1. Data cleaned and analyze in SQL
  2. Validate in Excel
  3. Visualize in Power BI

## Dashboard 
![Fraud Analysis Dashboard](https://github.com/ristakhadka013/healthcare-claims-fraud-analysis/blob/main/powerbi/Dashboard.png)
