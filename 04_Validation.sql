SELECT 'grnrl (Source Table)' AS table_name, COUNT(*) AS row_count
FROM grnrl

UNION ALL

SELECT 'dim_date', COUNT(*)
FROM dim_date

UNION ALL

SELECT 'dim_manufacturer', COUNT(*)
FROM dim_manufacturer

UNION ALL

SELECT 'dim_payment_type', COUNT(*)
FROM dim_payment_type

UNION ALL

SELECT 'dim_product', COUNT(*)
FROM dim_product

UNION ALL

SELECT 'dim_recipient', COUNT(*)
FROM dim_recipient

UNION ALL

SELECT 'dim_teaching_hospital', COUNT(*)
FROM dim_teaching_hospital

UNION ALL

SELECT 'dim_travel', COUNT(*)
FROM dim_travel

UNION ALL

SELECT 'fact_transactions (Fact Table)', COUNT(*)
FROM fact_transactions;
