
DROP TABLE IF EXISTS public.fact_transactions CASCADE;
DROP TABLE IF EXISTS public.dim_teaching_hospital CASCADE;
DROP TABLE IF EXISTS public.dim_manufacturer CASCADE;
DROP TABLE IF EXISTS public.dim_payment_type CASCADE;
DROP TABLE IF EXISTS public.dim_travel CASCADE;
DROP TABLE IF EXISTS public.dim_product CASCADE;
DROP TABLE IF EXISTS public.dim_recipient CASCADE;
DROP TABLE IF EXISTS public.dim_date CASCADE;

CREATE TABLE public.dim_date (
    "Full_date" date NOT NULL,
    "Year" int4 NOT NULL,
    "Quarter" int4 NOT NULL,
    "Month_numb" int4 NOT NULL,
    "Month_Name" varchar(20) NOT NULL,
    "Day" int4 NOT NULL,
    CONSTRAINT dim_date_pk PRIMARY KEY ("Full_date")
);

CREATE TABLE public.dim_recipient (
    recipient_id bigint GENERATED ALWAYS AS IDENTITY,
    "Covered_Recipient_Profile_ID" numeric(38) NOT NULL,
    "Covered_Recipient_NPI" numeric(10) NULL,
    "Covered_Recipient_First_Name" varchar(50) NULL,
    "Covered_Recipient_Middle_Name" varchar(50) NULL,
    "Covered_Recipient_Last_Name" varchar(50) NULL,
    "Recipient_City" varchar(50) NULL,
    CONSTRAINT dim_recipient_pk PRIMARY KEY (recipient_id),
    CONSTRAINT dim_recipient_business_key_uq UNIQUE ("Covered_Recipient_Profile_ID")
);

CREATE TABLE public.dim_manufacturer (
    manufacturer_id bigint GENERATED ALWAYS AS IDENTITY,
    "Submitting_Applicable_Manufacturer_or_Applicable_GPO_Name" varchar(100) NULL,
    "Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID" varchar(20) NOT NULL,
    "Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name" varchar(100) NULL,
    "Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_State" varchar(50) NULL,
    "Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Country" varchar(100) NULL,
    CONSTRAINT dim_manufacturer_pk PRIMARY KEY (manufacturer_id),
    CONSTRAINT dim_manufacturer_business_key_uq UNIQUE
        ("Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID")
);

CREATE TABLE public.dim_teaching_hospital (
    th_id bigint GENERATED ALWAYS AS IDENTITY,
    "Teaching_Hospital_CCN" varchar(50) NULL,
    "Teaching_Hospital_Name" varchar(100) NULL,
    "Teaching_Hospital_ID" numeric(80) NOT NULL,
    "Covered_Recipient_Profile_ID" numeric(38) NULL,
    "Covered_Recipient_NPI" numeric(10) NULL,
    "Covered_Recipient_First_Name" varchar(50) NULL,
    "Covered_Recipient_Middle_Name" varchar(50) NULL,
    "Covered_Recipient_Last_Name" varchar(50) NULL,
    "Recipient_City" varchar(50) NULL,
    CONSTRAINT dim_teaching_hospital_pk PRIMARY KEY (th_id),
    CONSTRAINT dim_teaching_hospital_business_key_uq UNIQUE ("Teaching_Hospital_ID")
);


CREATE TABLE public.dim_payment_type (
    payment_id bigint GENERATED ALWAYS AS IDENTITY,
    "Number_of_Payments_Included_in_Total_Amount" numeric(3) NULL,
    "Form_of_Payment_or_Transfer_of_Value" varchar(100) NULL,
    "Nature_of_Payment_or_Transfer_of_Value" varchar(200) NULL,
    CONSTRAINT dim_payment_type_pk PRIMARY KEY (payment_id)
);

CREATE TABLE public.dim_product (
    product_id bigint GENERATED ALWAYS AS IDENTITY,
    "Related_Product_Indicator" varchar(100) NULL,
    "Covered_or_Noncovered_Indicator" varchar(100) NULL,
    "Indicate_Drug_or_Biological_or_Device_or_Medical_Supply" varchar(100) NULL,
    "Product_Category_or_Therapeutic_Area" varchar(100) NULL,
    "Name_of_Drug_or_Biological_or_Device_or_Medical_Supply" varchar(100) NULL,
    CONSTRAINT dim_product_pk PRIMARY KEY (product_id)
);

CREATE TABLE public.dim_travel (
    travel_id bigint GENERATED ALWAYS AS IDENTITY,
    "City_of_Travel" varchar(50) NULL,
    "State_of_Travel" varchar(50) NULL,
    "Country_of_Travel" varchar(100) NULL,
    CONSTRAINT dim_travel_pk PRIMARY KEY (travel_id)
);

CREATE TABLE public.fact_transactions (
    id bigint NOT NULL,
    "date" date NOT NULL,
    amount numeric(12, 2) NULL,
    th_id bigint NULL,
    manufacturer_id bigint NULL,
    recipient_id bigint NULL,
    payment_id bigint NULL,
    product_id bigint NULL,
    travel_id bigint NULL,
    CONSTRAINT fact_transactions_pk PRIMARY KEY (id),
    CONSTRAINT fact_transactions_date_foreign
        FOREIGN KEY ("date") REFERENCES public.dim_date ("Full_date"),
    CONSTRAINT fact_transactions_manufacturer_id_foreign
        FOREIGN KEY (manufacturer_id) REFERENCES public.dim_manufacturer (manufacturer_id),
    CONSTRAINT fact_transactions_payment_id_foreign
        FOREIGN KEY (payment_id) REFERENCES public.dim_payment_type (payment_id),
    CONSTRAINT fact_transactions_product_id_foreign
        FOREIGN KEY (product_id) REFERENCES public.dim_product (product_id),
    CONSTRAINT fact_transactions_recipient_id_foreign
        FOREIGN KEY (recipient_id) REFERENCES public.dim_recipient (recipient_id),
    CONSTRAINT fact_transactions_th_id_foreign
        FOREIGN KEY (th_id) REFERENCES public.dim_teaching_hospital (th_id),
    CONSTRAINT fact_transactions_travel_id_foreign
        FOREIGN KEY (travel_id) REFERENCES public.dim_travel (travel_id)
);
