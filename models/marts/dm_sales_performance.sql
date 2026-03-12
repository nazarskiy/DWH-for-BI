CREATE OR REPLACE VIEW dm_sales_performance AS
WITH successful_transactions AS (
    -- successful payments per subscription
    SELECT
        sub_id,
        COUNT(tx_id) AS successful_payment_count
    FROM stg_transactions
    WHERE status = 'Success'
    GROUP BY sub_id
)
SELECT
    s.sub_id,
    c.company_name AS customer_name,
    c.country,
    s.plan_type,
    s.start_date,
    s.end_date,
    -- duration in days
    (s.effective_end_date - s.start_date) AS duration_days,
    s.amount AS period_amount,
    -- subscriptions with zero payments show 0 instead of NULL
    COALESCE(t.successful_payment_count, 0) AS total_successful_payments

FROM stg_subscriptions s
LEFT JOIN stg_customers c ON s.customer_id = c.customer_id
LEFT JOIN successful_transactions t ON s.sub_id = t.sub_id;