-- High-Value Customers with Multiple Products
-- Task: Find customers with funded savings AND investment plans

WITH funded_savings AS (
    SELECT owner_id, COUNT(*) AS savings_count, SUM(balance) AS total_savings
    FROM savings_savingsaccount
    WHERE balance > 0
    GROUP BY owner_id
),
funded_investments AS (
    SELECT owner_id, COUNT(*) AS investment_count, SUM(balance) AS total_investments
    FROM plans_plan
    WHERE balance > 0
    GROUP BY owner_id
)
SELECT 
    u.id AS owner_id,
    u.name,
    fs.savings_count,
    fi.investment_count,
    (fs.total_savings + fi.total_investments) AS total_deposits
FROM users_customuser u
JOIN funded_savings fs ON u.id = fs.owner_id
JOIN funded_investments fi ON u.id = fi.owner_id
ORDER BY total_deposits DESC;
