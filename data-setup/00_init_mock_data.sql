-- Raw Tables
DROP TABLE IF EXISTS raw_transactions;
DROP TABLE IF EXISTS raw_subscriptions;
DROP TABLE IF EXISTS raw_customers;

CREATE TABLE raw_customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    company_name VARCHAR(100),
    country VARCHAR(50),
    signup_date DATE
);

CREATE TABLE raw_subscriptions (
    sub_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    plan_type VARCHAR(20),
    start_date DATE,
    end_date DATE,
    amount DECIMAL(10, 2)
);

CREATE TABLE raw_transactions (
    tx_id VARCHAR(50),
    sub_id VARCHAR(50),
    tx_date DATE,
    status VARCHAR(20)
);

-- Mock Data

-- Customers
INSERT INTO raw_customers (customer_id, company_name, country, signup_date) VALUES
('1', 'Acme Corp', 'USA', '2023-01-15'),
('2', 'Globex', 'UK', '2023-03-10'),
('3', 'Soylent', 'Germany', '2023-06-05'),
('4', 'Initech', 'USA', '2023-11-01');

-- Subscriptions
INSERT INTO raw_subscriptions (sub_id, customer_id, plan_type, start_date, end_date, amount) VALUES
-- C1: Short finished monthly plan
('101', '1', 'Monthly', '2023-01-15', '2023-03-15', 50.00),
-- C1: Active monthly plan (The Loyal Monthly Payer)
('102', '1', 'Monthly', '2023-04-15', NULL, 50.00),
-- C2: Short monthly plan
('103', '2', 'Monthly', '2023-03-10', '2023-04-10', 50.00),
-- C3: Active annual plan (The Loyal Annual Payer)
('104', '3', 'Annual', '2023-06-05', NULL, 1200.00),
-- C1: Edge case - subscription created but no payment made yet
('105', '1', 'Monthly', '2023-12-01', NULL, 50.00),
-- C4: Edge case - canceled and refunded immediately
('106', '4', 'Annual', '2023-11-01', '2023-11-05', 1200.00);


-- Transactions
INSERT INTO raw_transactions (tx_id, sub_id, tx_date, status) VALUES
-- Sub 101 (C1): Couple of normal months
('1001', '101', '2023-01-15', 'Success'),
('1002', '101', '2023-02-15', 'Success'),

-- Sub 102 (C1): The Loyal Monthly Payer (steady LTV growth)
('1003', '102', '2023-04-15', 'Success'),
('1004', '102', '2023-05-15', 'Success'),
('1004', '102', '2023-05-16', 'Success'), -- The duplicate we need to clean
('1005', '102', '2023-06-15', 'Success'),
('1006', '102', '2023-07-15', 'Success'),
('1007', '102', '2023-08-15', 'Success'),
('1008', '102', '2023-09-15', 'Success'),

-- Sub 103 (C2): Failed and retried
('1009', '103', '2023-03-10', 'Failed'),
('1010', '103', '2023-03-11', 'Success'),

-- Sub 104 (C3): The Loyal Annual Payer (staircase LTV growth)
('1011', '104', '2023-06-05', 'Success'), -- Year 1
('1012', '104', '2024-06-05', 'Success'), -- Year 2 Renewal!
('1013', '104', '2025-06-05', 'Success'), -- Year 3 Renewal!

-- Sub 106 (C4): Refund edge case
('1014', '106', '2023-11-01', 'Success'),
('1015', '106', '2023-11-05', 'Refunded');