SELECT
    (SELECT COUNT(*) FROM fact_transactions) AS fact_count,
    (SELECT COUNT(*) FROM grnrl) AS source_count;