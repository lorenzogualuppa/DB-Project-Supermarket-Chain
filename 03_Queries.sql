-- SuperMarket Chain Database - Queries
-- Goals:
-- 1) Show the complete structure of the database (branches, departments, products, customers, suppliers, availability, procurements, phones).
-- 2) Use the main SQL techniques seen in class.
-- 3) Present realistic business scenarios.


SET search_path TO supermarket_chain;




-- SCENE 1: General structure and assortment
-- Goal: get an overview of the branches, departments and products, with a focus on availability and prices.




-- Query 1: List of branches with address & number of distinct products available per branch
-- Scenario: the general manager wants a summary list of all branches and wants to compare the assortment size of each one.
SELECT b.branch_code,
       city,
       street,
       number
       postal_code,
       COUNT(DISTINCT a.product_code) AS num_products_available
FROM branches AS b LEFT JOIN availability AS a
       ON b.branch_code = a.branch_code
GROUP BY b.branch_code, city, street, number, postal_code
ORDER BY num_products_available DESC, b.branch_code;




-- Query 2: Departments and product distribution
-- Scenario: the organisation team wants to know how many products are assigned to each department.
SELECT d.department_code,
       name AS department_name,
       COUNT(product_code) AS num_products
FROM departments AS d LEFT JOIN products AS p
       ON d.department_code = p.department_code
GROUP BY d.department_code, name
ORDER BY num_products DESC, d.department_code;




-- Query 3: Product catalogue with department and standard price
-- Scenario: the marketing office wants a catalogue extract with department and standard price, to compare it with promotional leaflets.
SELECT product_code,
       category,
       detail,
       brand,
       d.department_code,
       name AS department_name,
       standard_price
FROM products AS p JOIN departments AS d
        ON p.department_code = d.department_code
ORDER BY name, category, product_code;




-- SCENE 2: CUSTOMER MANAGEMENT AND LOYALTY
-- Goal: better understand customer behaviour and their contact information.




-- Query 4: Most loyal customers by points
-- Scenario: the CRM manager wants to find the top customers with more than 500 points, to send them a personalised campaign.
SELECT loyalty_card_id,
       first_name,
       last_name,
       email,
       accumulated_points
FROM customers
WHERE accumulated_points > 500
ORDER BY accumulated_points DESC, last_name, first_name;




-- Query 5: Average spend per loyalty customer
-- Note: in the sample data each customer has only one receipt, so avg_spend and total_spend are the same. With real data, where a customer makes more purchases over time, the two values would be different.
-- Scenario: the CRM wants to understand how much each loyalty card customer spends on average, to segment promotional campaigns.
SELECT c.loyalty_card_id,
       c.first_name,
       c.last_name,
       COUNT(r.receipt_number)       AS num_purchases,
       ROUND(AVG(r.total_amount), 2) AS avg_spend,
       SUM(r.total_amount)           AS total_spend
FROM customers AS c
     JOIN purchases AS p
        ON c.loyalty_card_id = p.loyalty_card_id
     JOIN receipts AS r
        ON p.receipt_number = r.receipt_number
GROUP BY c.loyalty_card_id, c.first_name, c.last_name
ORDER BY avg_spend DESC, c.loyalty_card_id;




-- Query 6: Customers without phone numbers
-- Note: replacing NOT IN with IN returns the customers who have at least one phone number.
-- Scenario: the CRM wants a list of customers who have no phone contact.
SELECT loyalty_card_id,
       first_name,
       last_name,
       email
FROM customers
WHERE loyalty_card_id NOT IN ( SELECT loyalty_card_id
                               FROM customer_phones
)
ORDER BY loyalty_card_id;




-- Query 7: Active vs former employees
-- Scenario: HR wants a complete overview of the personnel history, distinguishing employees who are still active from those who have left the company.
SELECT e.employee_code,
       e.first_name,
       e.last_name,
       e.role,
       'Active' AS status,
       ce.hiring_year  AS year_event,
       ce.hiring_month AS month_event,
       ce.hiring_day   AS day_event
FROM employees AS e
     JOIN current_employee AS ce
        ON e.employee_code = ce.employee_code
UNION
SELECT e.employee_code,
       e.first_name,
       e.last_name,
       e.role,
       'Ex-employee' AS status,
       fe.termination_year  AS year_event,
       fe.termination_month AS month_event,
       fe.termination_day   AS day_event
FROM employees AS e
     JOIN former_employee AS fe
        ON e.employee_code = fe.employee_code
ORDER BY status DESC, employee_code;




-- SCENE 3: PRICING POLICIES AND IN-STORE AVAILABILITY
-- Goal: analyse availability, local prices compared to standard prices, and revenue.




-- Query 8: Products available in a specific branch with price comparison
-- Scenario: the category manager of branch 1 wants to see which products are in the store and how the local prices differ from the standard price.
SELECT p.product_code,
       category,
       brand,
       standard_price,
       branch_code,
       local_price,
       (local_price - p.standard_price) AS price_difference
FROM products AS p JOIN availability AS a
        ON p.product_code = a.product_code
WHERE branch_code = 1
ORDER BY price_difference DESC, category, p.product_code;




-- Query 9: Total revenue per branch
-- Scenario: the management wants to compare the sales performance of each branch by adding up all the receipt amounts.
SELECT b.branch_code,
       b.city,
       COUNT(r.receipt_number)       AS num_receipts,
       SUM(r.total_amount)           AS total_revenue,
       ROUND(AVG(r.total_amount), 2) AS avg_receipt_value
FROM branches AS b
     JOIN employees AS e
        ON b.branch_code = e.branch_code
     JOIN receipts AS r
        ON e.employee_code = r.employee_code
GROUP BY b.branch_code, b.city
ORDER BY total_revenue DESC, b.branch_code;




-- SCENE 4: STAFF, DEPARTMENTS AND ROLES
-- Goal: analyse the staff structure by branch and department.




-- Query 10: Different roles in the company
-- Scenario: HR wants a list of all the different roles present across the whole chain.
SELECT DISTINCT role
FROM employees
ORDER BY role;




-- Query 11: List of employees with branch and department
-- Scenario: HR wants a full report with the branch city and department name for every employee.
SELECT employee_code,
       first_name,
       last_name,
       role,
       city AS branch_city,
       name AS department_name
FROM employees AS e
     JOIN branches AS b
        ON e.branch_code = b.branch_code
     JOIN departments AS d
        ON e.department_code = d.department_code
ORDER BY city, department_name, employee_code, last_name;




-- Query 12: Statistics by department (count, min, max, average product price)
-- Scenario: the purchasing manager wants to understand the price range of products in each department, to evaluate possible repositioning strategies.
SELECT p.department_code,
       name AS department_name,
       COUNT(*) AS number_of_products,
       MIN(standard_price) AS minimum_price,
       ROUND(AVG(standard_price), 2) AS average_price,
       MAX(standard_price) AS maximum_price
FROM products AS p
     JOIN departments AS d
        ON p.department_code = d.department_code
GROUP BY p.department_code, name
ORDER BY number_of_products DESC, p.department_code;




-- Query 13: Departments with at least N employees (e.g. 5)
-- Scenario: HR wants to find the large departments, with at least 5 employees, to plan dedicated training courses.
SELECT e.department_code,
       d.name AS department_name,
       COUNT(*) AS number_of_employees
FROM employees AS e
     JOIN departments AS d
        ON e.department_code = d.department_code
GROUP BY e.department_code, d.name
HAVING COUNT(*) >= 5
ORDER BY number_of_employees DESC, e.department_code;




-- Query 14: Departments used only by employees and not by products
-- Scenario: the organisation control office wants to find departments that exist in the employee records but have no products assigned to them.
SELECT department_code
FROM employees
EXCEPT
SELECT department_code
FROM products
ORDER BY department_code;




-- Query 15: Best-selling products (by total quantity sold)
-- Scenario: the purchasing manager wants to identify the best sellers
-- to guide restocking policies and supplier negotiations.
SELECT p.product_code,
       p.category,
       p.detail,
       p.brand,
       SUM(rd.quantity)            AS total_quantity_sold,
       SUM(rd.quantity * rd.price) AS total_revenue
FROM receipt_details AS rd
     JOIN products AS p
        ON rd.product_code = p.product_code
GROUP BY p.product_code, p.category, p.detail, p.brand
ORDER BY total_quantity_sold DESC, p.product_code;




-- SCENE 5: SUPPLIERS & PROCUREMENT
-- Goal: use suppliers and procurements in a realistic way.




-- Query 16: Suppliers with no recorded procurements
-- Scenario: the purchasing office wants to find suppliers that have never been used, to decide whether to keep the relationship or not.
SELECT s.supplier_code,
       vat_number,
       company_name,
       headquarter_city
FROM suppliers AS s
WHERE NOT EXISTS ( SELECT *
                   FROM procurements AS pr
                   WHERE pr.supplier_code = s.supplier_code
)
ORDER BY s.supplier_code;




-- Query 17: Cities where the chain is present as a branch or as a supplier headquarters
-- Scenario: the management wants a summary map of all the cities where the chain is present, either as a shop or as a logistics partner.
SELECT city AS city_name,
       'branch' AS presence_type
FROM branches
UNION
SELECT headquarter_city AS city_name,
       'supplier' AS presence_type
FROM suppliers
ORDER BY city_name, presence_type;




-- SCENE 6: CATALOGUE ANALYSIS
-- Goal: use correlated subqueries with ALL and scalar subqueries for advanced price comparisons.




-- Query 18: Most expensive products in their category
-- Scenario: the pricing manager wants to find, for each category, the top product or products with the highest price.
SELECT product_code,
       p.category,
       detail,
       brand,
       p.standard_price
FROM products AS p
WHERE p.standard_price >= ALL ( SELECT p2.standard_price
                                FROM products AS p2
                                WHERE p2.category = p.category
)
ORDER BY p.category, product_code;




-- Query 19: Products above the average price of their category
-- Scenario: the pricing manager wants to find the premium products, meaning those with a price above the average of their own category.
SELECT product_code,
       p.category,
       detail,
       brand,
       p.standard_price
FROM products AS p
WHERE p.standard_price > ( SELECT AVG(p2.standard_price)
                           FROM products AS p2
                           WHERE p2.category = p.category
)
ORDER BY p.category, p.standard_price DESC, p.product_code;
