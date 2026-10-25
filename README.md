# E-commerce-sql-analysis
# E-commerce Sales Analysis & Database Management Using MySQL

## Project Overview
This project demonstrates how SQL can be used to design and manage an e-commerce database, analyze sales, track inventory, automate order logging, and control database access.

The database contains three main tables: `customers`, `products`, and `orders`. An additional `order_audit` table records order insertion events.

## Objectives
- Design a relational database using primary and foreign keys.
- Retrieve customer orders and generate invoice details.
- Analyze customer spending and product sales.
- Use subqueries and aggregate functions for business analysis.
- Apply `RANK()`, `DENSE_RANK()`, and running totals using window functions.
- Improve date-based retrieval using an index.
- Automate audit logging using a trigger.
- Create a stored procedure to place orders and update inventory safely.
- Apply user-level permissions using `GRANT` and `REVOKE`.

## Technologies Used
- MySQL
- MySQL Workbench
- SQL

## Project Modules

### Phase 1: Database Setup
- Created `customers`, `products`, and `orders` tables.
- Added sample customer, product, and order data.
- Practiced basic queries, updates, and subqueries.

### Phase 2: Sales Analysis
- Generated invoice details by joining multiple tables.
- Calculated total spending per customer.
- Identified the top-selling product by quantity.
- Found customers spending above the average customer spending.

### Phase 3: Advanced SQL
- Ranked products by price within each category.
- Calculated customer spending running totals.
- Created an index on `order_date` and explored query execution with `EXPLAIN`.

### Phase 4: Automation and Transactions
- Created an `order_audit` table and an `AFTER INSERT` trigger.
- Developed a `PlaceOrder` stored procedure to check inventory, insert an order, and update stock within a transaction.

### Phase 5: Database Security
- Created a dedicated database user.
- Practiced table-level read permissions using `GRANT`.
- Used `REVOKE` to remove access to the customers table.

## Database Schema
- `customers`: customer details
- `products`: product details, prices, and available stock
- `orders`: customer purchases and order amounts
- `order_audit`: order insertion audit records

## How to Run
1. Install MySQL Server and MySQL Workbench.
2. Open `ecommerce_analysis.sql` in MySQL Workbench.
3. Review the script and execute the database setup and sample data sections first.
4. Run the analytical queries and inspect their results.
5. Test the trigger and stored procedure separately.
6. Test user permissions using the dedicated database user.

**Important:** Review statements that update stock or delete records before running them. Run the user-permission section using an account with administrative privileges. The script is intended for a fresh project database and may need adjustments before rerunning.

## Key Learning Outcomes
This project helped me practice relational database design, joins, aggregation, subqueries, window functions, indexing, stored procedures, triggers, transaction handling, and access control.

## Future Improvements
- Build a Power BI dashboard connected to the database.
- Add more sample transactions and reporting queries.
- Add order status, payment details, and inventory history.
- Compare query execution plans on a larger dataset.
