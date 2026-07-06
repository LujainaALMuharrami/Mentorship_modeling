# Healthcare Payments Data Warehouse

## About the Project

This project is about building a simple Data Warehouse using PostgreSQL. I used a healthcare payments dataset and converted it into a Star Schema by creating dimension tables and one fact table.

The project includes creating the tables, loading the data into the dimensions, and then loading the fact table.

---

## Data Source

The data was downloaded from the CMS Open Payments website.

Download link:

https://openpaymentsdata.cms.gov/datasets/download

Dataset used:

**2018 Program Year**

**PGYR2018_P01232026_01102026.zip**

After downloading the ZIP file, I extracted the CSV file and imported it into PostgreSQL as the source table called **grnrl**.

---

## Tools Used

* PostgreSQL
* DBeaver

---

## Database Schema

I used a **Star Schema**.

### Fact Table

* fact_transactions

### Dimension Tables

* dim_date
* dim_recipient
* dim_manufacturer
* dim_teaching_hospital
* dim_payment_type
* dim_product
* dim_travel

---

## SQL Files

* **01_Create_Dim_Fact_Tables.sql**

  * Creates all dimension tables and the fact table.

  <img width="1534" height="767" alt="Screenshot 2026-07-06 141853" src="https://github.com/user-attachments/assets/74be22b0-b12f-4df5-9e13-fed34705cff4" />


* **02_Load_Dimensions.sql**

  * Loads the data from the source table (**grnrl**) into the dimension tables.

* **03_Load_Fact.sql**

  * Loads the fact table by joining the source table with all dimension tables.

* **04_Validation.sql**

  * Used to check row counts and validate that the data was loaded correctly.

  <img width="389" height="221" alt="image" src="https://github.com/user-attachments/assets/172e0c2f-2d16-4a32-9cea-2f25480ae2bc" />


---

## Notes

While building this project, I found some issues with duplicate records in the dimension tables. At first I used "SELECT DISTINCT", but it caused duplicate business keys when joining with the fact table.

To fix this, I changed the scripts to:

* Use "GROUP BY" instead of "SELECT DISTINCT"
* Generate surrogate keys using "ROW_NUMBER()"
* Use "MAX()" for the descriptive columns when grouping
* Use "LEFT JOIN" to keep all records from the source table
* Use "NULLIF()" and data type casting to handle empty values correctly
