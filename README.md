# 🏥 Healthcare Provider Fraud Analysis

> **Analyzing healthcare provider claims to identify characteristics associated with fraudulent provider classifications using SQL, Excel, and Power BI.**

---

## 📌 Business Question

> **What characteristics distinguish providers classified as fraudulent from those classified as non-fraudulent?**

The analysis focuses on provider billing and utilization behavior and examines whether patient characteristics differ meaningfully between the two groups.

---

## 📊 Dataset

**Source:** Healthcare Provider Fraud Detection Analysis dataset

* **5,410 providers**
* **558K+ claims**

The dataset contains healthcare provider, beneficiary, claim, diagnosis, and reimbursement-related information used to compare fraudulent and non-fraudulent provider groups.

---

## 🛠️ Tools & Technologies

| Tool         | Purpose                                             |
| ------------ | --------------------------------------------------- |
| **SQL**      | Data cleaning, transformation & analytical analysis |
| **Excel**    | Validation & supporting analysis                    |
| **Power BI** | Data visualization & interactive dashboard          |

---

# 🔄 Analytical Approach

### 1. SQL — Data Preparation & Analysis

* Cleaned and prepared the healthcare claims data
* Aggregated claims at the provider level
* Compared utilization and billing patterns between provider groups
* Analyzed inpatient and outpatient claim behavior
* Examined patient demographic and chronic-condition characteristics

### 2. Excel — Validation

* Validated key SQL calculations
* Cross-checked provider-level metrics
* Verified comparisons between fraudulent and non-fraudulent groups

### 3. Power BI — Visualization

* Created KPI cards and comparative visualizations
* Built an interactive dashboard
* Presented differences in provider utilization and billing behavior

---

# 🔍 Key Findings

## 1. 📈 Fraudulent Providers Handled ~6× More Claims

Fraudulent providers averaged approximately:

**420.55 claims per provider**

compared with:

**70.44 claims per provider**

for non-fraudulent providers.

**Insight:** Providers classified as fraudulent showed substantially higher claim volumes per provider.

---

## 2. 💰 Average Claim Amount Was ~2.5× Higher

Average claim amount per provider was approximately:

| Provider Group | Average Claim Amount |
| -------------- | -------------------: |
| Fraudulent     |        **$3,842.80** |
| Non-Fraudulent |        **$1,523.78** |

Fraudulent providers had an average claim amount approximately **2.5× higher** than non-fraudulent providers.

**Insight:** Higher billing amounts were strongly associated with the fraudulent provider classification.

---

## 3. 🏥 Inpatient Utilization Was ~5× Higher

Fraudulent providers averaged:

**53.19 inpatient claims per provider**

compared with:

**10.33 inpatient claims per provider**

among non-fraudulent providers.

**Insight:** The fraudulent provider group showed substantially higher inpatient utilization.

---

## 4. 👥 Patient Characteristics Showed Limited Differences

Patient age and chronic-condition indicators showed **no meaningful differences** between fraudulent and non-fraudulent provider groups in the analyzed data.

**Insight:** The strongest differences observed were related to **provider billing and utilization behavior rather than patient characteristics**.

---

# 💡 Overall Business Insight

The analysis found a strong association between the fraudulent provider classification and **higher claim volume, higher claim amounts, and higher inpatient utilization**.

In contrast, patient age and chronic-condition characteristics showed relatively limited differences between the two groups.

This suggests that **provider billing and utilization behavior may provide stronger signals for identifying potentially fraudulent providers than patient characteristics alone.**

---

# ⚠️ Important Interpretation

The analysis identifies **patterns associated with the existing fraud classification**; it does not independently establish that a provider committed fraud.

Further investigation would require claim-level review, reimbursement details, service information, and additional provider context.

---

# 📊 Power BI Dashboard

The final Power BI dashboard summarizes the differences between fraudulent and non-fraudulent providers across key utilization and billing metrics.

![Healthcare Provider Fraud Analysis Dashboard](https://github.com/ristakhadka013/healthcare-claims-fraud-analysis/blob/main/powerbi/Dashboard.png)

---

# 🎯 Conclusion

This project demonstrates how **SQL, Excel, and Power BI** can be combined to analyze healthcare claims and identify patterns associated with provider fraud classifications.

The analysis found substantial differences in **claim volume, average claim amount, and inpatient utilization** between fraudulent and non-fraudulent provider groups, while patient characteristics showed limited differences.

These findings demonstrate how provider-level billing and utilization patterns can be used as **analytical signals for further investigation**.

---

### 🔗 Skills Demonstrated

**SQL • Excel • Power BI • Healthcare Analytics • Data Cleaning • Data Validation • Provider Analysis • KPI Analysis • Data Visualization**
