-- TASKS --
-- 1. Get all customers and their adresses.
SELECT customers.first_name, customers.last_name, addresses.street, addresses.city, addresses.zip, addresses.address_type FROM customers
JOIN addresses ON customers.id = addresses.customer_id;

-- 2. Get all orders and their line items (orders, quantity and product).
SELECT orders.order_date, line_items.quantity, products.description, products.unit_price FROM orders
JOIN line_items ON orders.id = line_items.order_id
JOIN products ON line_items.product_id = products.id;

-- 3. Which warehouses have cheetos?
SELECT warehouse.warehouse FROM warehouse
JOIN warehouse_product ON warehouse.id = warehouse_product.warehouse_id
JOIN products ON warehouse_product.product_id = products.id
WHERE products.description = 'cheetos';

-- 4. Which warehouses have diet pepsi?
SELECT warehouse.warehouse FROM warehouse
JOIN warehouse_product ON warehouse.id = warehouse_product.warehouse_id
JOIN products ON warehouse_product.product_id = products.id
WHERE products.description = 'diet pepsi';

-- 5. Get the number of orders for each customer. NOTE: It is OK if those without orders are not included in results.
SELECT customers.first_name, customers.last_name, count(*) FROM orders
JOIN addresses ON orders.address_id = addresses.id
JOIN customers ON addresses.customer_id = customers.id
GROUP BY customers.first_name, customers.last_name;

-- 6. How many customers do we have?
SELECT count(*) FROM customers;

-- 7. How many products do we carry?
SELECT count(*) FROM products;

-- 8. What is the total available on-hand quantity of diet pepsi?
SELECT products.description, sum(warehouse_product.on_hand) FROM warehouse_product
JOIN products ON warehouse_product.product_id = products.id
WHERE products.description = 'diet pepsi'
GROUP BY products.description;

-------------
-- STRETCH --
-- 9. How much was the total cost for each order?
SELECT orders.id, orders.order_date, sum(line_items.quantity * products.unit_price) FROM orders
JOIN line_items ON orders.id = line_items.order_id
JOIN products ON line_items.product_id = products.id
GROUP BY orders.id ORDER BY orders.order_date ASC;

-- 10. How much has each customer spent in total?
SELECT customers.first_name, customers.last_name, 
sum(line_items.quantity * products.unit_price) FROM orders
JOIN line_items ON orders.id = line_items.order_id
JOIN products ON line_items.product_id = products.id
JOIN addresses ON orders.address_id = addresses.id
JOIN customers ON addresses.customer_id = customers.id
GROUP BY customers.first_name, customers.last_name ORDER BY customers.first_name ASC;

-- 11. How much has each customer spent in total? Customers who have spent $0 should still show up in the table. It should say 0, not NULL (research coalesce).
SELECT customers.first_name, customers.last_name, 
COALESCE (sum(line_items.quantity * products.unit_price), 0) FROM customers
FULL JOIN addresses ON customers.id = addresses.customer_id
FULL JOIN orders ON addresses.id = orders.address_id
FULL JOIN line_items ON orders.id = line_items.order_id
FULL JOIN products ON line_items.product_id = products.id
GROUP BY customers.first_name, customers.last_name ORDER BY customers.first_name ASC;