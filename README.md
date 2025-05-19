# Data Analytics SQL Assessment

This repository contains solutions to four SQL-based analytics tasks designed to evaluate data exploration and transformation skills using realistic banking/fintech scenarios.

---

## 📌 Question Breakdown & Approach

### 🧩 Q1: High-Value Customers with Multiple Products

**Objective**: Identify customers with at least one funded savings plan and one funded investment plan.  
**Approach**:
- Joined `users_customuser`, `savings_savingsaccount`, and `plans_plan`.
- Filtered for customers with both plan types.
- Counted plan instances and summed deposits.
- Sorted by total deposits to prioritize high-value customers.

---

### 🧩 Q2: Transaction Frequency Analysis

**Objective**: Categorize customers by their average monthly transaction frequency.  
**Approach**:
- Aggregated transactions per customer per month.
- Computed average monthly transactions per customer.
- Categorized into “High”, “Medium”, and “Low Frequency”.
- Final result provides counts and average transaction rates per category.

---

### 🧩 Q3: Account Inactivity Alert

**Objective**: Flag active savings or investment accounts with no inflow for 365+ days.  
**Approach**:
- Extracted latest inflow per account.
- Compared against the current date to compute inactivity duration.
- Included account type, owner ID, and last transaction date.

---

### 🧩 Q4: Customer Lifetime Value (CLV) Estimation

**Objective**: Estimate CLV using a simplified formula based on tenure and transaction history.  
**Approach**:
- Calculated account tenure in months using `date_joined`.
- Summarized transaction count and average inflow value.
- Applied formula:
  ```
  CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction
  ```
- Ordered customers by estimated CLV to identify high-value individuals.

---

## 🚧 Challenges & Solutions

- **Missing transaction tables**: Assumed standard structures for `savings_transaction` and `plans_transaction`. Used logical joins and field names.
- **Date calculations**: PostgreSQL functions like `AGE()` and `DATE_TRUNC()` were used to handle date operations smoothly.
- **CLV Formula Adjustments**: Edge cases (e.g., zero tenure) handled using `CASE` to avoid division errors.

---

## 📁 Files

| File                  | Description                                |
|-----------------------|--------------------------------------------|
| `Assessment_Q1.sql`   | Query for identifying high-value customers |
| `Assessment_Q2.sql`   | Transaction frequency analysis             |
| `Assessment_Q3.sql`   | Inactive account alerting                  |
| `Assessment_Q4.sql`   | CLV estimation model                       |
