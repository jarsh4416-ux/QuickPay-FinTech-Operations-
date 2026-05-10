                                # SQL Answers
## Q1
### Query
SELECT 
    status_clean, 
    COUNT(*) AS total_transactions
FROM transactions
GROUP BY status_clean
ORDER BY total_transactions DESC;

### Result Summary: 
The result table shows the distribution of 30 total transactions categorized by their status:
Captured (Success): 19 Transactions (63.3%):This represents the successful conversion rate.
Failed E05 Timeout: 7 Transactions (23.3%): Nearly 1 in 4 transactions are failing due to a technical timeout.
Chargeback: 4 Transactions (13.3%):This is a high-risk indicator.In standard payment processing, a chargeback rate above 1% is often considered a "red flag" by banks.
Total Transactions Analyzed: 30

## Q2
### Query
SELECT 
    merchant_name_clean AS merchant, 
    SUM(raw_amount_clean) AS total_captured_gmv
FROM transactions
WHERE status_clean = 'Captured'
GROUP BY merchant_name_clean
ORDER BY total_captured_gmv DESC;

### Result Summary:
Revenue Concentration: The revenue is highly concentrated. The top two merchants (Beta Stores and Alpha Mart) account for nearly 77% of total captured GMV
Top Performer: Beta Stores is leading with the highest volume. If this is a new partnership, it’s scaling very well.
Tier 2 Merchants: Delta Travels and City Pharma contribute about 10-12% each.


## Q3
### Query
SELECT 
    merchant_name_clean AS merchant, 
    SUM(raw_amount_clean) AS total_captured_gmv
FROM transactions
WHERE status_clean = 'Captured'
GROUP BY merchant_name_clean
ORDER BY total_captured_gmv DESC
LIMIT 10;

### Result Summary:
Since the dataset has 4 unique merchants with "Captured" status, therefore:
Revenue Concentration: The revenue is highly concentrated. The top two merchants (Beta Stores and Alpha Mart) account for nearly 77% of total captured GMV
Top Performer: Beta Stores is leading with the highest volume. If this is a new partnership, it’s scaling very well.
Tier 2 Merchants: Delta Travels and City Pharma contribute about 10-12% each.

## Q4
### Query
SELECT 
    transaction_date, 
    SUM(raw_amount_clean) AS daily_gmv, 
    COUNT(transaction_id) AS successful_transaction_count
FROM transactions
WHERE status_clean = 'Captured'
GROUP BY transaction_date
ORDER BY transaction_date ASC;

### Result Summary:
The "Day 1" Peak: March 1st was by far the strongest day, contributing nearly 32% of the total weekly revenue.
Mid-Week Stability: Between March 2nd and March 4th, with the GMV hovering between 11k and 15k.
The business shows high volatility.It started the month with a strong burst of activity that dropped by more than 50% by the second day. To stabilize revenue, it would be important to investigate why March 1st was so much more successful—perhaps a promotion or a specific marketing campaign ended after that day.


## Q5
### Query
SELECT 
    merchant_name_clean,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN status_clean = 'Chargeback' THEN 1 ELSE 0 END) AS chargeback_count,
    (SUM(CASE WHEN status_clean = 'Chargeback' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS chargeback_ratio
FROM transactions
GROUP BY merchant_name_clean
HAVING chargeback_ratio > 1
ORDER BY chargeback_ratio DESC;

### Result Summary:
Extreme Risk for "Eco Home": With a 50% ratio, this merchant is in a critical state.
Small Sample Size Sensitivity: Both Eco Home and Delta Travels show alarmingly high percentages mainly because they have very few total transactions.
The "High Volume" Concern: Alpha Mart and Beta Stores are more concerning in the long run.
Investigate the Alpha Mart and Beta Stores transactions specifically, as they represent your highest volume but are failing to maintain a safe chargeback threshold.

## Q6
### Query
SELECT 
    gateway_region_clean AS region,
    AVG(risk_score_clean) AS average_risk_score,
    COUNT(transaction_id) AS total_transactions
FROM transactions
WHERE risk_score_clean IS NOT NULL
GROUP BY gateway_region_clean
HAVING average_risk_score > 50 AND total_transactions > 20
ORDER BY average_risk_score DESC;

### Result Summary:
query is asking the database to find rows that meet two specific conditions simultaneously:
average_risk_score > 50
total_transactions > 20
the database cannot find any region that has both a high score and a high volume, it returns an empty grid.

## Q7
### Query
SELECT 
    user_id, 
    transaction_date, 
    COUNT(*) AS unsuccessful_count
FROM transactions
WHERE status_clean IN ('Failed E05 Timeout', 'Chargeback')
GROUP BY user_id, transaction_date
HAVING unsuccessful_count >= 3
ORDER BY unsuccessful_count DESC;

### Result Summary:
Isolated incident: Only one user (U008) met the criteria for your high-frequency failure check.
High Frequency: This user attempted transactions 4 times in a single day, all of which resulted in either a "Failed E05 Timeout" or a "Chargeback."
Behavioral Pattern: This type of result is a classic indicator of "Card Testing" or a Technical Loop.

## Q8
### Query
SELECT 
    merchant_name_clean AS merchant,
    COUNT(transaction_id) AS chargeback_count,
    COUNT(DISTINCT user_id) AS unique_affected_users,
    SUM(raw_amount_clean) AS total_chargeback_amount
FROM transactions
WHERE status_clean = 'Chargeback'
GROUP BY merchant_name_clean
ORDER BY total_chargeback_amount DESC;

### Result Summary:
High-Value Loss (Eco Home): While Eco Home only has one chargeback,this suggests that high-ticket items at this merchant are particularly vulnerable to disputes.
User Concentration: Each merchant currently shows a 1:1 ratio between chargeback count and unique users.
Total Exposure: The combined loss across these four merchants is 16,168.50.
Risk Disparity: There is a wide range in the "cost" of a chargeback.