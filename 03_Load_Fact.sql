INSERT INTO fact_transactions
(
    id,
    date,
    amount,
    th_id,
    manufacturer_id,
    recipient_id,
    payment_id,
    product_id,
    travel_id
)
SELECT
    g.record_id,

    NULLIF(TRIM(g.date_of_payment), '')::date,

    g.total_amount_of_payment_usdollars,

    th.th_id,

    m.manufacturer_id,

    r.recipient_id,

    p.payment_id,

    pr.product_id,

    t.travel_id

FROM grnrl g

LEFT JOIN dim_recipient r
    ON r."Covered_Recipient_Profile_ID"::numeric =
       g.covered_recipient_profile_id::numeric

LEFT JOIN dim_manufacturer m
    ON m."Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID"::text =
       g.applicable_manufacturer_or_applicable_gpo_making_payment_id::text

LEFT JOIN dim_teaching_hospital th
    ON th."Teaching_Hospital_ID"::numeric =
       NULLIF(TRIM(g.teaching_hospital_id), '')::numeric

LEFT JOIN dim_payment_type p
    ON p."Number_of_Payments_Included_in_Total_Amount"
           IS NOT DISTINCT FROM g.number_of_payments_included_in_total_amount
   AND p."Form_of_Payment_or_Transfer_of_Value"
           IS NOT DISTINCT FROM g.form_of_payment_or_transfer_of_value
   AND p."Nature_of_Payment_or_Transfer_of_Value"
           IS NOT DISTINCT FROM g.nature_of_payment_or_transfer_of_value

LEFT JOIN dim_product pr
    ON pr."Related_Product_Indicator"
           IS NOT DISTINCT FROM g.related_product_indicator
   AND pr."Covered_or_Noncovered_Indicator"
           IS NOT DISTINCT FROM g.covered_or_noncovered_indicator_1
   AND pr."Indicate_Drug_or_Biological_or_Device_or_Medical_Supply"
           IS NOT DISTINCT FROM g.indicate_drug_or_biological_or_device_or_medical_supply_1
   AND pr."Product_Category_or_Therapeutic_Area"
           IS NOT DISTINCT FROM g.product_category_or_therapeutic_area_1
   AND pr."Name_of_Drug_or_Biological_or_Device_or_Medical_Supply"
           IS NOT DISTINCT FROM g.name_of_drug_or_biological_or_device_or_medical_supply_1

LEFT JOIN dim_travel t
    ON t."City_of_Travel"
           IS NOT DISTINCT FROM g.city_of_travel
   AND t."State_of_Travel"
           IS NOT DISTINCT FROM g.state_of_travel
   AND t."Country_of_Travel"
           IS NOT DISTINCT FROM g.country_of_travel

WHERE
    g.record_id IS NOT NULL

    AND NULLIF(TRIM(g.date_of_payment), '') IS NOT NULL

    AND NOT EXISTS
    (
        SELECT 1
        FROM fact_transactions f
        WHERE f.id = g.record_id
    );
