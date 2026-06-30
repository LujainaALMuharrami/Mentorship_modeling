TRUNCATE TABLE fact_transactions;

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
SELECT DISTINCT ON (g.record_id)
    g.record_id,
    d."Full_date",
    g.total_amount_of_payment_usdollars,
    th."th_id",
    m."manufacturer_id",
    r."recipient_id",
    p."payment_id",
    pr."product_id",
    t."travel_id"
FROM grnrl g
LEFT JOIN dim_recipient r
    ON g.covered_recipient_profile_id::numeric = r."Covered_Recipient_Profile_ID"::numeric
LEFT JOIN dim_manufacturer m
    ON g.applicable_manufacturer_or_applicable_gpo_making_payment_id::text = m."Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID"::text
LEFT JOIN dim_date d
    ON NULLIF(g.date_of_payment,'')::date = d."Full_date"
LEFT JOIN dim_teaching_hospital th
    ON NULLIF(g.teaching_hospital_id,'')::numeric = th."Teaching_Hospital_ID"::numeric
LEFT JOIN dim_payment_type p
    ON g.total_amount_of_payment_usdollars::numeric = p."Total_Amount_of_Payment_US_Dollars"::numeric
   AND NULLIF(g.date_of_payment,'')::date = p."Date_of_Payment"
   AND g.number_of_payments_included_in_total_amount = p."Number_of_Payments_Included_in_Total_Amount"
   AND g.form_of_payment_or_transfer_of_value::text = p."Form_of_Payment_or_Transfer_of_Value"::text
   AND g.nature_of_payment_or_transfer_of_value::text = p."Nature_of_Payment_or_Transfer_of_Value"::text
LEFT JOIN dim_product pr
    ON g.related_product_indicator::text = pr."Related_Product_Indicator"::text
   AND g.covered_or_noncovered_indicator_1::text = pr."Covered_or_Noncovered_Indicator"::text
   AND g.indicate_drug_or_biological_or_device_or_medical_supply_1::text = pr."Indicate_Drug_or_Biological_or_Device_or_Medical_Supply"::text
   AND g.product_category_or_therapeutic_area_1::text = pr."Product_Category_or_Therapeutic_Area"::text
   AND g.name_of_drug_or_biological_or_device_or_medical_supply_1::text = pr."Name_of_Drug_or_Biological_or_Device_or_Medical_Supply"::text
LEFT JOIN dim_travel t
    ON g.city_of_travel::text = t."City_of_Travel"::text
   AND g.state_of_travel::text = t."State_of_Travel"::text
   AND g.country_of_travel::text = t."Country_of_Travel"::text
ORDER BY g.record_id;