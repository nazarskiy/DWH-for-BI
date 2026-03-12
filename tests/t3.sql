-- Fails if amount is missing or not a positive number
SELECT
    sub_id,
    amount
FROM raw_subscriptions
WHERE amount <= 0 OR amount IS NULL;