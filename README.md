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
         gender INT,
         address VARCHAR(255),
         latitude DECIMAL,
         longitude DECIMAL,
         per_capita_income DECIMAL,
         yearly_income DECIMAL,
         total_debt DECIMAL,
         credit_score INT,
         num_credit_cards INT
     );

     CREATE TABLE transactions (
         id BIGINT PRIMARY KEY,
         date TIMESTAMP,
         client_id INT,
         card_id INT,
         amount DECIMAL,
         use_chip VARCHAR(50),
         merchant_id INT,
         merchant_city VARCHAR(50),
         merchant_state VARCHAR(2),
         zip VARCHAR(10),
         mcc INT,
         errors VARCHAR(50)
     );

     CREATE TABLE cards (
         id INT PRIMARY KEY,
         client_id INT,
         card_brand VARCHAR(50),
         card_type VARCHAR(50),
         card_number VARCHAR(50),
         expires VARCHAR(10),
         cvv INT,
         has_chip BOOLEAN,
         num_cards_issued INT,
         credit_limit DECIMAL,
         acct_open_date VARCHAR(10),
         year_pin_last_changed INT,
         card_on_dark_web VARCHAR(10)
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

2. **Run SQL Queries**
   - Connect to your PostgreSQL database using a tool like pgAdmin or command line.
   - Execute the SQL queries provided in the `queries.sql` file.
