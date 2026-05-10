                                 __ MySQL queries
__Q1
SELECT 
    status_clean, 
    COUNT(*) AS total_transactions
FROM transactions
GROUP BY status_clean
ORDER BY total_transactions DESC;

__Q2
SELECT 
    merchant_name_clean AS merchant, 
    SUM(raw_amount_clean) AS total_captured_gmv
FROM transactions
WHERE status_clean = 'Captured'
GROUP BY merchant_name_clean
ORDER BY total_captured_gmv DESC;

__Q3
SELECT 
    merchant_name_clean AS merchant, 
    SUM(raw_amount_clean) AS total_captured_gmv
FROM transactions
WHERE status_clean = 'Captured'
GROUP BY merchant_name_clean
ORDER BY total_captured_gmv DESC
LIMIT 10;

__Q4
SELECT 
    transaction_date, 
    SUM(raw_amount_clean) AS daily_gmv, 
    COUNT(transaction_id) AS successful_transaction_count
FROM transactions
WHERE status_clean = 'Captured'
GROUP BY transaction_date
ORDER BY transaction_date ASC;

__Q5
SELECT 
    merchant_name_clean,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN status_clean = 'Chargeback' THEN 1 ELSE 0 END) AS chargeback_count,
    (SUM(CASE WHEN status_clean = 'Chargeback' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS chargeback_ratio
FROM transactions
GROUP BY merchant_name_clean
HAVING chargeback_ratio > 1
ORDER BY chargeback_ratio DESC;

__Q6
SELECT 
    gateway_region_clean AS region,
    AVG(risk_score_clean) AS average_risk_score,
    COUNT(transaction_id) AS total_transactions
FROM transactions
WHERE risk_score_clean IS NOT NULL
GROUP BY gateway_region_clean
HAVING average_risk_score > 50 AND total_transactions > 20
ORDER BY average_risk_score DESC;

__Q7
SELECT 
    user_id, 
    transaction_date, 
    COUNT(*) AS unsuccessful_count
FROM transactions
WHERE status_clean IN ('Failed E05 Timeout', 'Chargeback')
GROUP BY user_id, transaction_date
HAVING unsuccessful_count >= 3
ORDER BY unsuccessful_count DESC;

__Q8
SELECT 
    merchant_name_clean AS merchant,
    COUNT(transaction_id) AS chargeback_count,
    COUNT(DISTINCT user_id) AS unique_affected_users,
    SUM(raw_amount_clean) AS total_chargeback_amount
FROM transactions
WHERE status_clean = 'Chargeback'
GROUP BY merchant_name_clean
ORDER BY total_chargeback_amount DESC;

