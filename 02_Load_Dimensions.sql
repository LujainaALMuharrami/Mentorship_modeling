
-- Date dimension
INSERT INTO public.dim_date
(
    "Full_date",
    "Year",
    "Quarter",
    "Month_numb",
    "Month_Name",
    "Day"
)
SELECT DISTINCT
    NULLIF(TRIM(date_of_payment), '')::date,
    EXTRACT(YEAR FROM NULLIF(TRIM(date_of_payment), '')::date)::int,
    EXTRACT(QUARTER FROM NULLIF(TRIM(date_of_payment), '')::date)::int,
    EXTRACT(MONTH FROM NULLIF(TRIM(date_of_payment), '')::date)::int,
    TO_CHAR(NULLIF(TRIM(date_of_payment), '')::date, 'FMMonth'),
    EXTRACT(DAY FROM NULLIF(TRIM(date_of_payment), '')::date)::int
FROM public.grnrl g
WHERE NULLIF(TRIM(date_of_payment), '') IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM public.dim_date d
      WHERE d."Full_date" = NULLIF(TRIM(g.date_of_payment), '')::date
  );

-- Recipient dimension
INSERT INTO public.dim_recipient
(
    "Covered_Recipient_Profile_ID",
    "Covered_Recipient_NPI",
    "Covered_Recipient_First_Name",
    "Covered_Recipient_Middle_Name",
    "Covered_Recipient_Last_Name",
    "Recipient_City"
)
SELECT DISTINCT ON (g.covered_recipient_profile_id)
    g.covered_recipient_profile_id,
    g.covered_recipient_npi,
    g.covered_recipient_first_name,
    g.covered_recipient_middle_name,
    g.covered_recipient_last_name,
    g.recipient_city
FROM public.grnrl g
WHERE g.covered_recipient_profile_id IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM public.dim_recipient r
      WHERE r."Covered_Recipient_Profile_ID" = g.covered_recipient_profile_id
  )
ORDER BY
    g.covered_recipient_profile_id,
    g.covered_recipient_npi DESC NULLS LAST;

-- Manufacturer dimension
INSERT INTO public.dim_manufacturer
(
    "Submitting_Applicable_Manufacturer_or_Applicable_GPO_Name",
    "Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID",
    "Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name",
    "Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_State",
    "Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Country"
)
SELECT DISTINCT ON (g.applicable_manufacturer_or_applicable_gpo_making_payment_id)
    g.submitting_applicable_manufacturer_or_applicable_gpo_name,
    g.applicable_manufacturer_or_applicable_gpo_making_payment_id::text,
    g.applicable_manufacturer_or_applicable_gpo_making_payment_name,
    g.applicable_manufacturer_or_applicable_gpo_making_payment_state,
    g.applicable_manufacturer_or_applicable_gpo_making_payment_country
FROM public.grnrl g
WHERE g.applicable_manufacturer_or_applicable_gpo_making_payment_id IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM public.dim_manufacturer m
      WHERE m."Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID" =
            g.applicable_manufacturer_or_applicable_gpo_making_payment_id::text
  )
ORDER BY
    g.applicable_manufacturer_or_applicable_gpo_making_payment_id,
    g.applicable_manufacturer_or_applicable_gpo_making_payment_name NULLS LAST;

-- Teaching hospital dimension
INSERT INTO public.dim_teaching_hospital
(
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
SELECT DISTINCT ON (NULLIF(TRIM(g.teaching_hospital_id), '')::numeric)
    g.teaching_hospital_ccn,
    g.teaching_hospital_name,
    NULLIF(TRIM(g.teaching_hospital_id), '')::numeric,
    g.covered_recipient_profile_id,
    g.covered_recipient_npi,
    g.covered_recipient_first_name,
    g.covered_recipient_middle_name,
    g.covered_recipient_last_name,
    g.recipient_city
FROM public.grnrl g
WHERE NULLIF(TRIM(g.teaching_hospital_id), '') IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM public.dim_teaching_hospital th
      WHERE th."Teaching_Hospital_ID" =
            NULLIF(TRIM(g.teaching_hospital_id), '')::numeric
  )
ORDER BY
    NULLIF(TRIM(g.teaching_hospital_id), '')::numeric,
    g.teaching_hospital_name NULLS LAST;

-- Payment type dimension
INSERT INTO public.dim_payment_type
(
    "Number_of_Payments_Included_in_Total_Amount",
    "Form_of_Payment_or_Transfer_of_Value",
    "Nature_of_Payment_or_Transfer_of_Value"
)
SELECT DISTINCT
    g.number_of_payments_included_in_total_amount,
    g.form_of_payment_or_transfer_of_value,
    g.nature_of_payment_or_transfer_of_value
FROM public.grnrl g
WHERE NOT EXISTS (
    SELECT 1
    FROM public.dim_payment_type p
    WHERE p."Number_of_Payments_Included_in_Total_Amount"
              IS NOT DISTINCT FROM g.number_of_payments_included_in_total_amount
      AND p."Form_of_Payment_or_Transfer_of_Value"
              IS NOT DISTINCT FROM g.form_of_payment_or_transfer_of_value
      AND p."Nature_of_Payment_or_Transfer_of_Value"
              IS NOT DISTINCT FROM g.nature_of_payment_or_transfer_of_value
);

-- Product dimension
INSERT INTO public.dim_product
(
    "Related_Product_Indicator",
    "Covered_or_Noncovered_Indicator",
    "Indicate_Drug_or_Biological_or_Device_or_Medical_Supply",
    "Product_Category_or_Therapeutic_Area",
    "Name_of_Drug_or_Biological_or_Device_or_Medical_Supply"
)
SELECT DISTINCT
    g.related_product_indicator,
    g.covered_or_noncovered_indicator_1,
    g.indicate_drug_or_biological_or_device_or_medical_supply_1,
    g.product_category_or_therapeutic_area_1,
    g.name_of_drug_or_biological_or_device_or_medical_supply_1
FROM public.grnrl g
WHERE NOT EXISTS (
    SELECT 1
    FROM public.dim_product pr
    WHERE pr."Related_Product_Indicator"
              IS NOT DISTINCT FROM g.related_product_indicator
      AND pr."Covered_or_Noncovered_Indicator"
              IS NOT DISTINCT FROM g.covered_or_noncovered_indicator_1
      AND pr."Indicate_Drug_or_Biological_or_Device_or_Medical_Supply"
              IS NOT DISTINCT FROM g.indicate_drug_or_biological_or_device_or_medical_supply_1
      AND pr."Product_Category_or_Therapeutic_Area"
              IS NOT DISTINCT FROM g.product_category_or_therapeutic_area_1
      AND pr."Name_of_Drug_or_Biological_or_Device_or_Medical_Supply"
              IS NOT DISTINCT FROM g.name_of_drug_or_biological_or_device_or_medical_supply_1
);

-- Travel dimension
INSERT INTO public.dim_travel
(
    "City_of_Travel",
    "State_of_Travel",
    "Country_of_Travel"
)
SELECT DISTINCT
    g.city_of_travel,
    g.state_of_travel,
    g.country_of_travel
FROM public.grnrl g
WHERE NOT EXISTS (
    SELECT 1
    FROM public.dim_travel t
    WHERE t."City_of_Travel" IS NOT DISTINCT FROM g.city_of_travel
      AND t."State_of_Travel" IS NOT DISTINCT FROM g.state_of_travel
      AND t."Country_of_Travel" IS NOT DISTINCT FROM g.country_of_travel
);
