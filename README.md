# User Behavior Analysis

## Prerequisites
- PostgreSQL database installed and running.
- CSV files loaded into PostgreSQL tables (`users`, `transactions`, `cards`).

## Steps to Run the Code

1. **Load Data into PostgreSQL**
   - Create tables for `users`, `transactions`, and `cards`.
   - Use the following SQL commands to create tables:
     ```sql
     CREATE TABLE users (
         id INT PRIMARY KEY,
         current_age INT,
         retirement_age INT,
         birth_year INT,
         birth_month INT,
         gender VARCHAR(10),
         address TEXT,
         latitude NUMERIC,
         longitude NUMERIC,
         per_capita_income NUMERIC,
         yearly_income NUMERIC,
         total_debt NUMERIC,
         credit_score INT,
         num_credit_cards INT
     );

     CREATE TABLE transactions (
         id INT PRIMARY KEY,
         date TIMESTAMP,
         client_id INT,
         card_id INT REFERENCES cards(card_id),
         amount NUMERIC,
         use_chip VARCHAR(20),
         merchant_id INT,
         merchant_city VARCHAR(50),
         merchant_state VARCHAR(20),
         zip VARCHAR(10),
         mcc INT,
         errors VARCHAR(50)
     );

     CREATE TABLE cards (
         card_id INT PRIMARY KEY,
         client_id INT REFERENCES users(id),
         card_brand VARCHAR(20),
         card_type VARCHAR(20),
         card_number BIGINT,
         expires VARCHAR(10),
         cvv INT,
         has_chip BOOLEAN,
         cards_issued INT,
         credit_limit NUMERIC,
         acct_open_date VARCHAR(10),
         year_pin_last_changed INT,
         card_on_dark_web BOOLEAN
     );
     ```
   - Load CSV files into the respective tables using:
     ```sql
     COPY users FROM '/path/to/user_data.csv' DELIMITER ',' CSV HEADER;
     COPY transactions FROM '/path/to/transaction_data.csv' DELIMITER ',' CSV HEADER;
     COPY cards FROM '/path/to/card_data.csv' DELIMITER ',' CSV HEADER;
     ```

2. **Run SQL Queries**
   - Connect to your PostgreSQL database using a tool like Laragon.
   - Execute the SQL queries provided in the `queries.sql` file.
