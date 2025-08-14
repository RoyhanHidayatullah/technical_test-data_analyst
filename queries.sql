-- Query 1: Calculate the number of users by age bracket
-- Objective: To understand the age distribution of the user base.
-- This segmentation supports targeted marketing and product design.
SELECT 
    CASE 
        WHEN current_age < 25 THEN '18-24'
        WHEN current_age BETWEEN 25 AND 34 THEN '25-34'
        WHEN current_age BETWEEN 35 AND 44 THEN '35-44'
        WHEN current_age BETWEEN 45 AND 54 THEN '45-54'
        WHEN current_age BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+'
    END AS age_bracket,
    COUNT(*) AS user_count
FROM users
GROUP BY age_bracket
ORDER BY MIN(current_age);


-- Query 2: Calculate average yearly income by gender
-- Objective: To analyze income trends across gender groups.
-- Helps identify financial inclusivity and personalize financial products.
SELECT 
    gender,
    ROUND(AVG(yearly_income), 2) AS avg_yearly_income,
    COUNT(*) AS user_count
FROM users
GROUP BY gender
ORDER BY avg_yearly_income DESC;


-- Query 3: Count total transactions and average amount by card type
-- Objective: To identify which card types (Credit/Debit/Prepaid) are most used.
-- Useful for understanding spending preferences and product strategy.
SELECT 
    c.card_type,
    COUNT(t.id) AS transaction_count,
    ROUND(AVG(t.amount), 2) AS avg_transaction_amount
FROM transactions t
JOIN cards c ON t.card_id = c.card_id
GROUP BY c.card_type
ORDER BY transaction_count DESC;


-- Query 4: Identify users with high debt-to-income ratio (>50%)
-- Objective: To flag users with potentially high financial stress.
-- Can inform risk models or financial wellness programs.
SELECT 
    u.id AS user_id,
    u.current_age,
    u.gender,
    u.yearly_income,
    u.total_debt,
    ROUND((u.total_debt / u.yearly_income) * 100, 2) AS debt_to_income_pct
FROM users u
WHERE u.yearly_income > 0 
  AND (u.total_debt / u.yearly_income) > 0.5
ORDER BY debt_to_income_pct DESC;


-- Query 5: Find top 10 merchants by transaction volume
-- Objective: To identify popular spending locations.
-- Useful for partnership opportunities or cashback program development.
SELECT 
    merchant_id,
    merchant_city,
    merchant_state,
    COUNT(*) AS transaction_count,
    ROUND(AVG(amount), 2) AS avg_amount
FROM transactions
WHERE merchant_id IS NOT NULL
GROUP BY merchant_id, merchant_city, merchant_state
ORDER BY transaction_count DESC
LIMIT 10;


-- Query 6: Analyze transaction activity by hour of day
-- Objective: To understand peak transaction times.
-- Helps optimize fraud detection timing and marketing campaigns.
SELECT 
    EXTRACT(HOUR FROM date) AS hour_of_day,
    COUNT(*) AS transaction_count,
    ROUND(AVG(amount), 2) AS avg_amount
FROM transactions
GROUP BY hour_of_day
ORDER BY hour_of_day;


-- Query 7: Categorize users by credit score and analyze income
-- Objective: To assess credit health and its relationship with income.
-- Supports lending decisions and customer segmentation.
SELECT 
    CASE 
        WHEN credit_score >= 750 THEN 'Excellent (750+)'
        WHEN credit_score >= 700 THEN 'Good (700-749)'
        WHEN credit_score >= 650 THEN 'Fair (650-699)'
        WHEN credit_score >= 600 THEN 'Poor (600-649)'
        ELSE 'Very Poor (<600)'
    END AS credit_score_category,
    COUNT(*) AS user_count,
    ROUND(AVG(yearly_income), 2) AS avg_income
FROM users
GROUP BY credit_score_category
ORDER BY 
    CASE credit_score_category
        WHEN 'Excellent (750+)' THEN 1
        WHEN 'Good (700-749)' THEN 2
        WHEN 'Fair (650-699)' THEN 3
        WHEN 'Poor (600-649)' THEN 4
        ELSE 5
    END;


-- Query 8: Count cards exposed on the dark web
-- Objective: To identify potential security risks.
-- Critical for fraud monitoring and user alert systems.
SELECT 
    card_on_dark_web AS exposed_on_dark_web,
    COUNT(*) AS card_count
FROM cards
GROUP BY card_on_dark_web;


-- Query 9: Compare transaction behavior by use_chip (e.g., Swipe vs Online)
-- Objective: To understand spending patterns by transaction method.
-- Helps assess fraud risk and channel usage trends.
SELECT 
    use_chip,
    COUNT(*) AS transaction_count,
    ROUND(AVG(amount), 2) AS avg_amount,
    ROUND(STDDEV(amount), 2) AS std_dev_amount
FROM transactions
WHERE use_chip IS NOT NULL
GROUP BY use_chip
ORDER BY avg_amount DESC;


-- Query 10: Identify high-value users (frequent & high-spending)
-- Objective: To find power users for loyalty or premium service programs.
-- Uses transaction count and total spending as key metrics.
SELECT 
    u.id AS user_id,
    u.current_age,
    u.gender,
    u.credit_score,
    COUNT(t.id) AS total_transactions,
    ROUND(SUM(t.amount), 2) AS total_spent,
    ROUND(AVG(t.amount), 2) AS avg_transaction_value
FROM users u
JOIN cards c ON u.id = c.client_id
JOIN transactions t ON c.card_id = t.card_id
GROUP BY u.id, u.current_age, u.gender, u.credit_score
HAVING COUNT(t.id) > 10 AND SUM(t.amount) > 5000
ORDER BY total_spent DESC
LIMIT 20;

