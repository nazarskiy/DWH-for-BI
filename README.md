# Enterprise Data Warehouse & BI Reporting Layer Assessment

## 📌 Overview
This repository contains my submission for the Data Engineering internship task

## 🏗️ Architecture & Methodology
* **Staging Layer (`models/stgs/`):** Handles raw data type casting, basic standardization and transaction deduplication
* **Data Mart Layer (`models/marts/`):** Joins staging models and applies pre-aggregations , resulting in a clean, wide, BI-ready view
* **Testing (`tests/`):** Implemented as "zero-row assertions." Queries are designed to fail (return rows) if data quality issues like orphaned transactions, duplicates, or negative amounts are detected
* **Analytics (`analysis/`):** Business metrics

## ⚙️ Environment Setup & Execution
The SQL dialect used is **PostgreSQL**.

**To run this project locally:**
1. A local PostgreSQL instance is required (you can use docker file provided)
2. Run the SQL script inside `data-setup/` to generate the raw tables and insert mock data
3. Execute the data quality checks (`models/t1.sql`, `t2.sql`, `t3.sql`) to verify raw data anomalies
4. Execute the views in `models/stgs/` to build the clean staging layer
5. Execute `models/marts/dm_sales_performance.sql` to build the final BI view
6. Run the queries in the `analysis/` folder to view the advanced MRR and LTV metrics

## 📁 Repository Structure
```text
main/
│
├── data-setup/
│   └── 00_init_mock_data.sql      # DDL and mock data with specific edge cases
│
├── models/                        
│   ├── t1.sql                     # DQ check: Orphaned transactions
│   ├── t2.sql                     # DQ check: Duplicate transactions
│   ├── t3.sql                     # DQ check: Invalid subscription amounts
│   ├── stgs/                      # Data cleaning and deduplication
│   │   ├── stg_customers.sql
│   │   ├── stg_subscriptions.sql
│   │   └── stg_transactions.sql
│   └── marts/                     # Final BI-ready view
│       └── dm_sales_performance.sql  
│
├── analysis/
│   ├── mrr.sql                    # Recurring revenue
│   └── cumulative-ltv.sql         # Running totals per customer
│
└── README.md