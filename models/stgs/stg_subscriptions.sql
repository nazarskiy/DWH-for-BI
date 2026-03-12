CREATE OR REPLACE VIEW stg_subscriptions AS
SELECT
    sub_id,
    customer_id,
    plan_type,
    start_date::DATE AS start_date,
    end_date::DATE AS end_date,
    -- null end_date safely with casting
    CAST(COALESCE(end_date, CURRENT_DATE) AS DATE) AS effective_end_date,
    CAST(amount AS DECIMAL(10, 2)) AS amount
FROM raw_subscriptions;