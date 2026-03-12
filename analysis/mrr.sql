WITH date_spine AS (
    -- range from the very first subscription to today
    SELECT generate_series(
        DATE_TRUNC('month', MIN(start_date)),
        DATE_TRUNC('month', CURRENT_DATE),
        '1 month'::INTERVAL
    )::DATE AS report_month
    FROM stg_subscriptions
),
monthly_allocations AS (
    SELECT
        ds.report_month,
        s.sub_id,
        s.plan_type,
        -- "Split Annual plans by 12, keep Monthly as is"
        CASE
            WHEN s.plan_type = 'Annual' THEN s.amount / 12.0
            ELSE s.amount
        END AS mrr_amount
    FROM date_spine ds
    JOIN stg_subscriptions s
        ON ds.report_month >= DATE_TRUNC('month', s.start_date)
        AND ds.report_month <= DATE_TRUNC('month', s.effective_end_date)
)
-- final MRR per month
SELECT
    TO_CHAR(report_month, 'YYYY-MM') AS revenue_month,
    SUM(mrr_amount) AS total_mrr
FROM monthly_allocations
GROUP BY report_month
ORDER BY report_month;