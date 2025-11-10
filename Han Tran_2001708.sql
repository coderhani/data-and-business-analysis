
######## MySQL Assignment (50 points) ########

#### Question 1 (5 points) ####
## Please fetch these columns from the "products" table:
##

##	- product_name		(The product_name column)
##	- list_price		(The list_price column)
##	- date_added		(The date_added column)
## Please only return the rows with a list price that’s greater than 500 and less than 2000.
## Please also sort the result set by the "date_added" column in descending order.

SELECT 
    product_name AS 'The product_name',
    list_price AS 'The list_price',
    date_added AS 'The date_added'
FROM
    products
WHERE
    (list_price > 500)
        AND (list_price < 2000)
ORDER BY date_added DESC;


#### Question 2 (5 points) ####

## Please fetch these column and data from the "order_items" table:
##
##	- item_id			(The item_id column)
##	- item_price		(The item_price column)
##	- discount_amount	(The discount_amount column)
##	- quantity			(The quantity column)
##	- price_total		(A column that’s calculated by multiplying the item price by the quantity)
##	- discount_total	(A column that’s calculated by multiplying the discount amount by the quantity)
##	- item_total		(A column that’s calculated by subtracting the discount amount from the item price
##						 and then multiplying by the quantity)
##
## Please only return the rows where the "item_total" is greater than 500.
## Pleasee also sort the result set by the "item_total" column in descending order.
SELECT 
    item_id AS 'The item id',
    item_price AS 'The item price',
    discount_amount AS 'The discount amount',
    quantity AS 'The quantity',
    (item_price * quantity) AS 'The price total',
    (discount_amount * quantity) AS 'The discount_total',
    ((item_price - discount_amount) * quantity) AS 'The item total'
FROM
    order_items
WHERE
    ((item_price - discount_amount) * quantity) > 500
ORDER BY ((item_price - discount_amount) * quantity) DESC;



#### Question 3 (5 points) ####

## Please write a query that inner joins the "categories" table to the "products" table and returns these columns:
##
##	- category_name
##	- product_name
##	- list_price
##
## Sort the result set by the "category_name" column and then by the "product_name" column in ascending order.

SELECT 
	product_name AS 'The product_name',
    list_price AS 'The list_price',
    date_added AS 'The date_added'
FROM
    products
    INNER JOIN
    categories
ORDER BY category_name, product_name asc;

#### Question 4 (5 points) ####

## Please write a query to identify the products in the "products" table that have the same list price.
## The query should return their "product_id", "product_name" and "list_price" in the result set.
##
## Hint: CROSS JOIN the "products" table to itself.

SELECT
	product_name AS 'The product_name',
    list_price AS 'The list_price',
    product_id AS 'The product_id'
FROM
	products
ORDER BY
	list_price DESC;
## Another method
SELECT 
	products.list_price,
    order_items.product_id,
    products.product_name
FROM
    products
CROSS JOIN order_items;        

#### Question 5 (15 points) ####

## Please identify the categories in the "categories" table that do not match any product in the "products" table.
## Your query should return their "category_name" in the result set.
##
## NOTE: You must present THREE different methods in your answer. Please write one query for each method used.

# Method 1: Outer Join - LEFT JOIN
SELECT categories.category_id, products.category_id, category_name
FROM categories
LEFT JOIN products ON products.category_id = categories.category_id
WHERE categories.category_name IS NULL
ORDER BY category_name;
#or
SELECT categories.category_id, products.category_id, category_name
FROM categories
LEFT JOIN products ON products.category_id = categories.category_id
ORDER BY category_name;

#Method 2: Outer Join - RIGHT JOIN
SELECT categories.category_id, products.category_id, category_name
FROM categories 
RIGHT JOIN products ON categories.category_id = products.category_id
WHERE products.category_id IS NULL
ORDER BY categories.category_name;

#or 
SELECT categories.category_id, products.category_id, category_name
FROM categories 
RIGHT JOIN products ON categories.category_id = products.category_id
ORDER BY categories.category_name;


# Method 3: Sub-query 
SELECT DISTINCT
    category_name
FROM
    categories c
WHERE
    c.category_id IN (SELECT 
            category_id
        FROM
            products)
ORDER BY category_name;


# 3 methods
SELECT category_name
FROM categories AS t1
LEFT JOIN products AS t2 ON t1.category_id = t2. category_id
WHERE product_id IS NULL;

SELECT category_name
FROM categories
WHERE category_id NOT IN
	(SELECT DISTINCT category_id
	 FROM products);

SELECT category_name
FROM categories AS t1
WHERE NOT EXISTS
	(SELECT *
	 FROM products
	 WHERE t1.category_id = category_id);

#### Question 6 (5 points) ####

## Please return one row for each category that has products, and each row returned should contain the following values:
##
##	- category_name
##	- The number of products in the "products" table that belong to the category
##	- The maximum list price of products in the "products" table that belong to the category
##
## Sort the result set so that the category with the most products appears first.

SELECT 
    c.category_name,
    COUNT(p.product_id) AS count,
    MAX(p.list_price)
FROM
    categories AS c
        INNER JOIN
    products p ON c.category_id = p.category_id
GROUP BY c.category_name
ORDER BY count DESC;

SELECT 
	CategoryName, 
	COUNT(*) AS ProductCount,
MAX(ListPrice) AS MostExpensiveProduct
FROM Categories c JOIN categories p
ON c.CategoryID = p.CategoryID
GROUP BY CategoryName
ORDER BY ProductCount DESC

#### Question 7 (5 points) ####

## Please identify the products whose list price is greater than the average list price for all products.
## Return the "product_name" and "list_price" columns for each product satisfying the given criteria.
## Please also sort the result set by the "list_price" column in descending order.

SELECT 
	product_name, list_price
FROM products
WHERE list_price > ( SELECT AVG(list_price) FROM products )
ORDER BY list_price DESC;
#or
SELECT 
    product_name, list_price
FROM
    products
WHERE
    list_price > (SELECT 
            AVG(list_price)
        FROM
            products)
ORDER BY list_price DESC;


#### Question 8 (5 points) ####

## Please return the product name and discount percent of each product that has a unique discount percent.
## To find all the unique order numbers in the "products" table:

SELECT discount_percent
  FROM products
GROUP BY discount_percent;

## In other words, don’t include products that have the same discount percent as another product.
## Please sort the result set by the "product_name" column in ascending order.
SELECT 
    product_name, discount_percent
FROM
    products
WHERE
    discount_percent NOT IN (SELECT 
            discount_percent
        FROM
            products
        GROUP BY discount_percent
        HAVING COUNT(discount_percent) > 1)
ORDER BY product_name ASC;


