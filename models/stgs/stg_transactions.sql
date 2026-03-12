CREATE OR REPLACE VIEW stg_transactions AS
WITH casted_and_ranked AS (
    SELECT
        tx_id,
        sub_id,
        tx_date::DATE AS tx_date,
        status,
        -- most recent tnx date gets rn = 1
        ROW_NUMBER() OVER(PARTITION BY tx_id ORDER BY tx_date DESC) as rn
    FROM raw_transactions
)
-- select the clean, deduplicated rows
SELECT
    tx_id,
    sub_id,
    tx_date,
    status
FROM casted_and_ranked
WHERE rn = 1;