-- Fails if any tx_id appears more than once
SELECT
    tx_id,
    COUNT(*) as duplicate_count
FROM raw_transactions
GROUP BY tx_id
HAVING COUNT(*) > 1;