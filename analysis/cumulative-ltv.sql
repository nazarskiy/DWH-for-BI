WITH customer_months AS (
    -- create range for each customer starting at their signup_date and up to the current month
    SELECT
        customer_id,
        generate_series(
            DATE_TRUNC('month', signup_date),
            DATE_TRUNC('month', CURRENT_DATE),
            '1 month'::INTERVAL
        )::DATE AS cohort_month
    FROM stg_customers
),
monthly_spend AS (
    -- actual revenue from successful transactions per customer per month
    SELECT
        s.customer_id,
        DATE_TRUNC('month', t.tx_date)::DATE AS tx_month,
        SUM(s.amount) AS revenue_collected
    FROM stg_transactions t
    JOIN stg_subscriptions s ON t.sub_id = s.sub_id
    WHERE t.status = 'Success'
    GROUP BY s.customer_id, DATE_TRUNC('month', t.tx_date)::DATE
),
spine_with_spend AS (
    SELECT
        cm.customer_id,
        cm.cohort_month,
        -- spent 0 if no subs this month
        COALESCE(ms.revenue_collected, 0) AS spend_this_month
    FROM customer_months cm
    LEFT JOIN monthly_spend ms
        ON cm.customer_id = ms.customer_id
        AND cm.cohort_month = ms.tx_month
)
-- running total
SELECT
    customer_id,
    TO_CHAR(cohort_month, 'YYYY-MM') AS ltv_month,
    spend_this_month,
    SUM(spend_this_month) OVER (
        PARTITION BY customer_id
        ORDER BY cohort_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_ltv
FROM spine_with_spend
ORDER BY customer_id, cohort_month;