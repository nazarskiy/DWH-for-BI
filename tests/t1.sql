-- Fails if any transaction links to a non-existent subscription
SELECT
    tx_id,
    sub_id
FROM raw_transactions
WHERE sub_id NOT IN (SELECT sub_id FROM raw_subscriptions);