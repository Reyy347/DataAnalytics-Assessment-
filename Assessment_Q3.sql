-- Account Inactivity Alert

WITH savings_inflow AS (
    SELECT t.account_id, MAX(t.created_at) AS last_transaction_date
    FROM savings_transaction t
    WHERE t.transaction_type = 'inflow'
    GROUP BY t.account_id
),
plan_inflow AS (
    SELECT t.plan_id, MAX(t.created_at) AS last_transaction_date
    FROM plans_transaction t
    WHERE t.transaction_type = 'inflow'
    GROUP BY t.plan_id
),
inactive_savings AS (
    SELECT sa.id AS plan_id, sa.owner_id, 'Savings' AS type,
           COALESCE(si.last_transaction_date, sa.created_at) AS last_transaction_date,
           DATE_PART('day', CURRENT_DATE - COALESCE(si.last_transaction_date, sa.created_at)) AS inactivity_days
    FROM savings_savingsaccount sa
    LEFT JOIN savings_inflow si ON sa.id = si.account_id
    WHERE sa.status = 'active' AND (si.last_transaction_date IS NULL OR si.last_transaction_date < CURRENT_DATE - INTERVAL '365 days')
),
inactive_plans AS (
    SELECT p.id AS plan_id, p.owner_id, 'Investment' AS type,
           COALESCE(pi.last_transaction_date, p.created_at) AS last_transaction_date,
           DATE_PART('day', CURRENT_DATE - COALESCE(pi.last_transaction_date, p.created_at)) AS inactivity_days
    FROM plans_plan p
    LEFT JOIN plan_inflow pi ON p.id = pi.plan_id
    WHERE p.status = 'active' AND (pi.last_transaction_date IS NULL OR pi.last_transaction_date < CURRENT_DATE - INTERVAL '365 days')
)
SELECT * FROM inactive_savings
UNION ALL
SELECT * FROM inactive_plans
ORDER BY inactivity_days DESC;
