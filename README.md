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

  <img width="993" height="885" alt="image" src="https://github.com/user-attachments/assets/54a545df-83ae-4ea1-9401-26e3899344e9" />



* **02_Load_Dimensions.sql**

  * Loads the data from the source table (**grnrl**) into the dimension tables.

* **03_Load_Fact.sql**

  * Loads the fact table by joining the source table with all dimension tables.

* **04_Validation.sql**

  * Used to check row counts and validate that the data was loaded correctly.

  <img width="342" height="202" alt="image" src="https://github.com/user-attachments/assets/4cccfcbd-93d7-4661-9ffa-f30ee865f51c" />




