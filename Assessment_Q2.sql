-- Transaction Frequency Analysis

WITH transaction_data AS (
    SELECT sa.owner_id, DATE_TRUNC('month', t.created_at) AS txn_month, COUNT(*) AS monthly_txn_count
    FROM savings_transaction t
    JOIN savings_savingsaccount sa ON t.account_id = sa.id
    GROUP BY sa.owner_id, DATE_TRUNC('month', t.created_at)
),
average_txn_per_customer AS (
    SELECT owner_id, AVG(monthly_txn_count) AS avg_txns_per_month
    FROM transaction_data
    GROUP BY owner_id
),
categorized_customers AS (
    SELECT owner_id,
        CASE
            WHEN avg_txns_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txns_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_txns_per_month
    FROM average_txn_per_customer
)
SELECT frequency_category, COUNT(*) AS customer_count, ROUND(AVG(avg_txns_per_month), 2) AS avg_transactions_per_month
FROM categorized_customers
GROUP BY frequency_category
ORDER BY CASE frequency_category
    WHEN 'High Frequency' THEN 1
    WHEN 'Medium Frequency' THEN 2
    WHEN 'Low Frequency' THEN 3
END;
