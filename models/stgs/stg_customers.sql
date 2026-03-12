DROP VIEW IF EXISTS stg_customers;

CREATE OR REPLACE VIEW stg_customers AS
SELECT
    customer_id,
    company_name,
    country,
    signup_date::DATE AS signup_date
FROM raw_customers;