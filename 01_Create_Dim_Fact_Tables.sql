-- public.dim_date definition

-- Drop table

-- DROP TABLE public.dim_date;

CREATE TABLE public.dim_date (
	"Full_date" date NOT NULL,
	"Year" int4 NOT NULL,
	"Quarter" int4 NOT NULL,
	"Month_numb" int4 NOT NULL,
	"Month_Name" varchar(20) NOT NULL,
	"Day" int4 NOT NULL,
	CONSTRAINT dim_date_pk PRIMARY KEY ("Full_date")
);


-- public.dim_manufacturer definition

-- Drop table

-- DROP TABLE public.dim_manufacturer;

CREATE TABLE public.dim_manufacturer (
	manufacturer_id int8 NOT NULL,
	"Submitting_Applicable_Manufacturer_or_Applicable_GPO_Name" varchar(100) NULL,
	"Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID" varchar(12) NULL,
	"Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name" varchar(100) NULL,
	"Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_State" bpchar(2) NULL,
	"Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Countr" varchar(100) NULL,
	CONSTRAINT dim_manufacturer_pk PRIMARY KEY (manufacturer_id)
);


-- public.dim_payment_type definition

-- Drop table

-- DROP TABLE public.dim_payment_type;

CREATE TABLE public.dim_payment_type (
	payment_id int8 NOT NULL,
	"Total_Amount_of_Payment_US_Dollars" numeric(12, 2) NULL,
	"Date_of_Payment" date NULL,
	"Number_of_Payments_Included_in_Total_Amount" numeric(3) NULL,
	"Form_of_Payment_or_Transfer_of_Value" varchar(100) NULL,
	"Nature_of_Payment_or_Transfer_of_Value" varchar(200) NULL,
	CONSTRAINT dim_payment_type_pk PRIMARY KEY (payment_id)
);


-- public.dim_product definition

-- Drop table

-- DROP TABLE public.dim_product;

CREATE TABLE public.dim_product (
	product_id int8 NOT NULL,
	"Related_Product_Indicator" varchar(100) NULL,
	"Covered_or_Noncovered_Indicator" varchar(100) NULL,
	"Indicate_Drug_or_Biological_or_Device_or_Medical_Supply" varchar(100) NULL,
	"Product_Category_or_Therapeutic_Area" varchar(100) NULL,
	"Name_of_Drug_or_Biological_or_Device_or_Medical_Supply" varchar(100) NULL,
	CONSTRAINT dim_product_pk PRIMARY KEY (product_id)
);


-- public.dim_recipient definition

-- Drop table

-- DROP TABLE public.dim_recipient;

CREATE TABLE public.dim_recipient (
	recipient_id int8 NOT NULL,
	"Covered_Recipient_Profile_ID" numeric(38) NULL,
	"Covered_Recipient_NPI" numeric(10) NULL,
	"Covered_Recipient_First_Name" varchar(20) NULL,
	"Covered_Recipient_Middle_Name" varchar(20) NULL,
	"Covered_Recipient_Last_Name" varchar(35) NULL,
	"Recipient_City" varchar(40) NULL,
	CONSTRAINT dim_recipient_pk PRIMARY KEY (recipient_id)
);


-- public.dim_teaching_hospital definition

-- Drop table

-- DROP TABLE public.dim_teaching_hospital;

CREATE TABLE public.dim_teaching_hospital (
	th_id int8 NOT NULL,
	"Teaching_Hospital_CCN" varchar(6) NULL,
	"Teaching_Hospital_Name" varchar(100) NULL,
	"Teaching_Hospital_ID" numeric(80) NULL,
	"Covered_Recipient_Profile_ID" numeric(38) NULL,
	"Covered_Recipient_NPI" numeric(10) NULL,
	"Covered_Recipient_First_Name" varchar(20) NULL,
	"Covered_Recipient_Middle_Name" varchar(20) NULL,
	"Covered_Recipient_Last_Name" varchar(35) NULL,
	"Recipient_City" varchar(40) NULL,
	CONSTRAINT dim_teaching_hospital_pk PRIMARY KEY (th_id)
);


-- public.dim_travel definition

-- Drop table

-- DROP TABLE public.dim_travel;

CREATE TABLE public.dim_travel (
	travel_id int8 NOT NULL,
	"City_of_Travel" varchar(40) NULL,
	"State_of_Travel" bpchar(2) NULL,
	"Country_of_Travel" varchar(100) NULL,
	CONSTRAINT dim_travel_pk PRIMARY KEY (travel_id)
);


-- public.fact_transactions definition

-- Drop table

-- DROP TABLE public.fact_transactions;

CREATE TABLE public.fact_transactions (
	id int8 NOT NULL,
	"date" date NOT NULL,
	amount numeric(12, 2) NULL,
	th_id int8 NULL,
	manufacturer_id int8 NULL,
	recipient_id int8 NULL,
	payment_id int8 NULL,
	product_id int8 NULL,
	travel_id int8 NULL,
	CONSTRAINT fact_transactions_pk PRIMARY KEY (id),
	CONSTRAINT fact_transactions_date_foreign FOREIGN KEY ("date") REFERENCES public.dim_date("Full_date"),
	CONSTRAINT fact_transactions_manufacturer_id_foreign FOREIGN KEY (manufacturer_id) REFERENCES public.dim_manufacturer(manufacturer_id),
	CONSTRAINT fact_transactions_payment_id_foreign FOREIGN KEY (payment_id) REFERENCES public.dim_payment_type(payment_id),
	CONSTRAINT fact_transactions_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.dim_product(product_id),
	CONSTRAINT fact_transactions_recipient_id_foreign FOREIGN KEY (recipient_id) REFERENCES public.dim_recipient(recipient_id),
	CONSTRAINT fact_transactions_th_id_foreign FOREIGN KEY (th_id) REFERENCES public.dim_teaching_hospital(th_id),
	CONSTRAINT fact_transactions_travel_id_foreign FOREIGN KEY (travel_id) REFERENCES public.dim_travel(travel_id)
);