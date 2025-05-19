-- Customer Lifetime Value (CLV) Estimation

WITH user_transactions AS (
    SELECT sa.owner_id, COUNT(t.id) AS total_transactions, SUM(t.amount) AS total_transaction_value,
           AVG(t.amount) AS avg_transaction_value
    FROM savings_transaction t
    JOIN savings_savingsaccount sa ON t.account_id = sa.id
    WHERE t.transaction_type = 'inflow'
    GROUP BY sa.owner_id
),
user_tenure AS (
    SELECT u.id AS customer_id, u.name, DATE_PART('month', AGE(CURRENT_DATE, u.date_joined)) AS tenure_months
    FROM users_customuser u
),
clv_data AS (
    SELECT ut.customer_id, ut.name, ut.tenure_months,
           COALESCE(utx.total_transactions, 0) AS total_transactions,
           ROUND(CASE 
               WHEN ut.tenure_months > 0 THEN 
                   (utx.total_transactions::decimal / ut.tenure_months) * 12 * (0.001 * COALESCE(utx.avg_transaction_value, 0))
               ELSE 0
           END, 2) AS estimated_clv
    FROM user_tenure ut
    LEFT JOIN user_transactions utx ON ut.customer_id = utx.owner_id
)
SELECT customer_id, name, tenure_months, total_transactions, estimated_clv
FROM clv_data
ORDER BY estimated_clv DESC;
