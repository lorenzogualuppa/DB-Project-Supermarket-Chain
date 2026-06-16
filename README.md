# Database Project: Supermarket Chain

## Introduction
This repository contains the physical implementation (SQL DDL and Sample Data) of a relational database management system (DBMS) designed for a generic supermarket chain. The system is engineered to handle daily operations including product catalogs, branch availability, human resources tracking, supplier logistics, and customer loyalty strategies.

## Repository Structure
To test the database in a PostgreSQL environment, execute the scripts in the following chronological order:

* **`01_DDL.sql`**: Contains the physical schema definition (Tables, Primary Keys, and Foreign Keys constraints).
* **`02_Sample_Data.sql`**: Contains the sample data populated via `INSERT INTO` statements.
* **`03_Queries.sql`**: Contains the DML queries to answer typical business and operational questions.

## Database Overview
The underlying logical schema maps an ecosystem composed of Branches, Departments, Suppliers, Global Products (and local availability), Employees (current and former), Customers, and highly-detailed transaction mappings (Receipts and Receipt Details).
