-- Query 1: Calculate the number of users by age bracket
-- Objective: To understand the age distribution of the user base.
-- This segmentation supports targeted marketing and product design.
SELECT
	CASE
		WHEN current_age < 25 THEN '18-24'
		WHEN current_age BETWEEN 25 AND 34 THEN '25-34'
		WHEN current_age BETWEEN 35 AND 44 THEN '35-44'
		WHEN current_age BETWEEN 45 AND 54 THEN '45-54'
		WHEN current_age BETWEEN 55 AND 64 THEN '45-54'
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
	ROUND(AVG(yearly_income),2) AS avg_yearly_income,
	COUNT(*) AS user_count
FROM users
GROUP BY gender
ORDER BY avg_yearly_income;


-- Query 3: Count total transactions and average amount by card type
-- Objective: To identify which card types (Credit/Debit/Prepaid) are most used.
-- Useful for understanding spending preferences and product strategy.
SELECT
	c.card_type,
	COUNT(t.id) AS transaction_count,
	ROUND(AVG(ABS(t.amount)),2) AS avg_amount
FROM cards c
JOIN transactions t ON c.card_id = t.card_id
GROUP BY card_type
ORDER BY transaction_count DESC;


-- Query 4: Calculate the number of users by debt-to-income ratio
-- Objective: To analyze distribution of users across debt-to-income risk categories. 
-- Can inform risk assessment or financial wellness programs.
SELECT
	CASE
		WHEN ROUND((total_debt/yearly_income)*100, 2) < 30 THEN 'Low Risk (<30%)'
		WHEN ROUND((total_debt/yearly_income)*100, 2) < 50 THEN 'Moderate Risk (30–49%)'
		WHEN ROUND((total_debt/yearly_income)*100, 2) <= 100 THEN 'High Risk (50–100%)'
		ELSE 'Extreme Risk (>100%)'
	END AS dti_risk,
	COUNT(*) AS user_count
FROM users
GROUP BY dti_risk
ORDER BY MIN(ROUND((total_debt/yearly_income)*100, 2));


-- Query 5: Find top 10 merchants by transaction volume
-- Objective: To identify popular spending locations.
-- Useful for partnership opportunities or cashback program development.
SELECT 
	merchant_id,
	merchant_city,
	merchant_state,
	COUNT(*) AS transaction_count,
	ROUND(AVG(ABS(amount)),2) AS avg_amount
FROM transactions
GROUP BY merchant_id, merchant_city, merchant_state
ORDER BY transaction_count DESC
LIMIT 10


-- Query 6: Analyze transaction activity by hour of day
-- Objective: To understand peak transaction times.
-- Helps optimize fraud detection timing and marketing campaigns.
SELECT
	EXTRACT(HOUR FROM DATE) AS hour_of_day,
	COUNT(*) AS transaction_count,
	ROUND(AVG(ABS(amount)),2) AS avg_amount
FROM transactions
GROUP BY hour_of_day
ORDER BY hour_of_day ASC;


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
FROM
   users
GROUP BY credit_score_category
ORDER BY MIN(credit_score);


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
	ROUND(AVG(ABS(amount)),2) AS avg_amount,
	ROUND(STDDEV(ABS(amount)),2) AS std_dev_amount
FROM transactions
GROUP BY use_chip
ORDER BY avg_amount DESC


-- Query 10: Identify high-value users (frequent & high-spending)
-- Objective: To find power users for loyalty or premium service programs.
-- Uses transaction count and total spending as key metrics.
SELECT 
    u.id AS user_id,
    u.current_age,
    u.gender,
    u.credit_score,
    u.yearly_income,
    COUNT(t.id) AS total_transactions,
    -- Expenses
    COUNT(CASE WHEN t.amount < 0 THEN 1 END) AS num_expense_transactions,
    ROUND(SUM(CASE WHEN t.amount < 0 THEN ABS(t.amount) ELSE 0 END), 2) AS total_spent,
    ROUND(AVG(CASE WHEN t.amount < 0 THEN ABS(t.amount) ELSE NULL END), 2) AS avg_expense_value,

    -- Income/Refunds
    COUNT(CASE WHEN t.amount > 0 THEN 1 END) AS num_income_transactions,
    ROUND(SUM(CASE WHEN t.amount > 0 THEN t.amount ELSE 0 END), 2) AS total_income,
    ROUND(AVG(CASE WHEN t.amount > 0 THEN t.amount ELSE NULL END), 2) AS avg_income_value
FROM users u
JOIN cards c ON u.id = c.client_id
JOIN transactions t ON c.card_id = t.card_id
GROUP BY u.id, u.current_age, u.gender, u.credit_score
ORDER BY total_spent DESC
LIMIT 20;




