TRUNCATE TABLE
    fact_transactions,
    dim_recipient,
    dim_manufacturer,
    dim_teaching_hospital,
    dim_payment_type,
    dim_travel,
    dim_product,
    dim_date
CASCADE;

INSERT INTO dim_recipient
(
    "recipient_id",
    "Covered_Recipient_Profile_ID",
    "Covered_Recipient_NPI",
    "Covered_Recipient_First_Name",
    "Covered_Recipient_Middle_Name",
    "Covered_Recipient_Last_Name",
    "Recipient_City"
)
SELECT
    ROW_NUMBER() OVER (ORDER BY covered_recipient_profile_id),
    covered_recipient_profile_id,
    MAX(covered_recipient_npi),
    MAX(covered_recipient_first_name),
    MAX(covered_recipient_middle_name),
    MAX(covered_recipient_last_name),
    MAX(recipient_city)
FROM grnrl
WHERE covered_recipient_profile_id IS NOT NULL
GROUP BY covered_recipient_profile_id;

INSERT INTO dim_manufacturer
(
    "manufacturer_id",
    "Submitting_Applicable_Manufacturer_or_Applicable_GPO_Name",
    "Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID",
    "Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name",
    "Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_State",
    "Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Country"
)
SELECT
    ROW_NUMBER() OVER (ORDER BY applicable_manufacturer_or_applicable_gpo_making_payment_id),
    MAX(submitting_applicable_manufacturer_or_applicable_gpo_name),
    applicable_manufacturer_or_applicable_gpo_making_payment_id,
    MAX(applicable_manufacturer_or_applicable_gpo_making_payment_name),
    MAX(applicable_manufacturer_or_applicable_gpo_making_payment_state),
    MAX(applicable_manufacturer_or_applicable_gpo_making_payment_country)
FROM grnrl
WHERE applicable_manufacturer_or_applicable_gpo_making_payment_id IS NOT NULL
GROUP BY applicable_manufacturer_or_applicable_gpo_making_payment_id;

INSERT INTO dim_teaching_hospital
(
    "th_id",
    "Teaching_Hospital_CCN",
    "Teaching_Hospital_Name",
    "Teaching_Hospital_ID",
    "Covered_Recipient_Profile_ID",
    "Covered_Recipient_NPI",
    "Covered_Recipient_First_Name",
    "Covered_Recipient_Middle_Name",
    "Covered_Recipient_Last_Name",
    "Recipient_City"
)
SELECT
    ROW_NUMBER() OVER (ORDER BY NULLIF(teaching_hospital_id, '')::numeric),
    MAX(teaching_hospital_ccn),
    MAX(teaching_hospital_name),
    NULLIF(teaching_hospital_id, '')::numeric,
    MAX(covered_recipient_profile_id),
    MAX(covered_recipient_npi),
    MAX(covered_recipient_first_name),
    MAX(covered_recipient_middle_name),
    MAX(covered_recipient_last_name),
    MAX(recipient_city)
FROM grnrl
WHERE NULLIF(teaching_hospital_id, '') IS NOT NULL
GROUP BY NULLIF(teaching_hospital_id, '')::numeric;

INSERT INTO dim_payment_type
(
    "payment_id",
    "Total_Amount_of_Payment_US_Dollars",
    "Date_of_Payment",
    "Number_of_Payments_Included_in_Total_Amount",
    "Form_of_Payment_or_Transfer_of_Value",
    "Nature_of_Payment_or_Transfer_of_Value"
)
SELECT
    ROW_NUMBER() OVER (
        ORDER BY
            total_amount_of_payment_usdollars,
            NULLIF(date_of_payment, '')::date,
            number_of_payments_included_in_total_amount,
            form_of_payment_or_transfer_of_value,
            nature_of_payment_or_transfer_of_value
    ),
    total_amount_of_payment_usdollars,
    NULLIF(date_of_payment, '')::date,
    number_of_payments_included_in_total_amount,
    form_of_payment_or_transfer_of_value,
    nature_of_payment_or_transfer_of_value
FROM grnrl
WHERE NULLIF(date_of_payment, '') IS NOT NULL
GROUP BY
    total_amount_of_payment_usdollars,
    NULLIF(date_of_payment, '')::date,
    number_of_payments_included_in_total_amount,
    form_of_payment_or_transfer_of_value,
    nature_of_payment_or_transfer_of_value;

INSERT INTO dim_travel
(
    "travel_id",
    "City_of_Travel",
    "State_of_Travel",
    "Country_of_Travel"
)
SELECT
    ROW_NUMBER() OVER (ORDER BY city_of_travel, state_of_travel, country_of_travel),
    city_of_travel,
    state_of_travel,
    country_of_travel
FROM grnrl
GROUP BY city_of_travel, state_of_travel, country_of_travel;

INSERT INTO dim_product
(
    "product_id",
    "Related_Product_Indicator",
    "Covered_or_Noncovered_Indicator",
    "Indicate_Drug_or_Biological_or_Device_or_Medical_Supply",
    "Product_Category_or_Therapeutic_Area",
    "Name_of_Drug_or_Biological_or_Device_or_Medical_Supply"
)
SELECT
    ROW_NUMBER() OVER (
        ORDER BY
            related_product_indicator,
            covered_or_noncovered_indicator_1,
            indicate_drug_or_biological_or_device_or_medical_supply_1,
            product_category_or_therapeutic_area_1,
            name_of_drug_or_biological_or_device_or_medical_supply_1
    ),
    related_product_indicator,
    covered_or_noncovered_indicator_1,
    indicate_drug_or_biological_or_device_or_medical_supply_1,
    product_category_or_therapeutic_area_1,
    name_of_drug_or_biological_or_device_or_medical_supply_1
FROM grnrl
GROUP BY
    related_product_indicator,
    covered_or_noncovered_indicator_1,
    indicate_drug_or_biological_or_device_or_medical_supply_1,
    product_category_or_therapeutic_area_1,
    name_of_drug_or_biological_or_device_or_medical_supply_1;

INSERT INTO dim_date
(
    "Full_date",
    "Year",
    "Quarter",
    "Month_numb",
    "Month_Name",
    "Day"
)
SELECT DISTINCT
    NULLIF(date_of_payment, '')::date,
    EXTRACT(YEAR FROM NULLIF(date_of_payment, '')::date)::int,
    EXTRACT(QUARTER FROM NULLIF(date_of_payment, '')::date)::int,
    EXTRACT(MONTH FROM NULLIF(date_of_payment, '')::date)::int,
    TO_CHAR(NULLIF(date_of_payment, '')::date, 'Month'),
    EXTRACT(DAY FROM NULLIF(date_of_payment, '')::date)::int
FROM grnrl
WHERE NULLIF(date_of_payment, '') IS NOT NULL;