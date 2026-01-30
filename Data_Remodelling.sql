-- Credit: https://stackoverflow.com/questions/17942508/sql-split-values-to-multiple-rows

-- Normalize Pizza Recipes
DROP TABLE IF EXISTS pizza_recipes_split;
CREATE TABLE pizza_recipes_split
WITH RECURSIVE pizza_toppings_split AS (
    SELECT
        pizza_id,
        SUBSTRING_INDEX(toppings, ', ', 1) AS topping_split,
        IF(LOCATE(', ', toppings) > 0, SUBSTRING(toppings, LOCATE(', ', toppings) + 1), NULL) AS remaining_values
    FROM pizza_recipes
    UNION ALL
    SELECT
        pizza_id,
        SUBSTRING_INDEX(remaining_values, ', ', 1) AS topping_split,
        IF(LOCATE(', ', remaining_values) > 0, SUBSTRING(remaining_values, LOCATE(', ', remaining_values) + 1), NULL)
    FROM
        pizza_toppings_split
    WHERE
        remaining_values IS NOT NULL
)
SELECT
    pizza_id,
    topping_split as topping_id
FROM
    pizza_toppings_split order by pizza_id;
ALTER TABLE pizza_recipes_split
MODIFY COLUMN topping_id INTEGER;

-- Normalize Order Exclusions
DROP TABLE IF EXISTS customer_orders_exclusions;
CREATE TABLE customer_orders_exclusions
WITH RECURSIVE orders_exclusions AS (
    SELECT
        order_line_id,
        SUBSTRING_INDEX(exclusions, ', ', 1) AS exclusions_split,
        IF(LOCATE(', ', exclusions) > 0, SUBSTRING(exclusions, LOCATE(', ', exclusions) + 1), NULL) AS remaining_values
    FROM customer_orders
        WHERE exclusions IS NOT NULL
    UNION ALL
    SELECT
        order_line_id,
        SUBSTRING_INDEX(remaining_values, ', ', 1) AS exclusions_split,
        IF(LOCATE(', ', remaining_values) > 0, SUBSTRING(remaining_values, LOCATE(', ', remaining_values) + 1), NULL)
    FROM
        orders_exclusions
    WHERE
        remaining_values IS NOT NULL
)
SELECT
    order_line_id,
    exclusions_split as exclusion_topping_id
FROM
    orders_exclusions order by order_line_id;
ALTER TABLE customer_orders_exclusions
MODIFY COLUMN exclusion_topping_id INTEGER;

-- Normalize Order Extras
DROP TABLE IF EXISTS customer_orders_extras;
CREATE TABLE customer_orders_extras
WITH RECURSIVE orders_extras AS (
    SELECT
        order_line_id,
        SUBSTRING_INDEX(extras, ', ', 1) AS extras_split,
        IF(LOCATE(', ', extras) > 0, SUBSTRING(extras, LOCATE(', ', extras) + 1), NULL) AS remaining_values
    FROM customer_orders
        WHERE extras IS NOT NULL
    UNION ALL
    SELECT
        order_line_id,
        SUBSTRING_INDEX(remaining_values, ', ', 1) AS extras_split,
        IF(LOCATE(', ', remaining_values) > 0, SUBSTRING(remaining_values, LOCATE(', ', remaining_values) + 1), NULL)
    FROM
        orders_extras
    WHERE
        remaining_values IS NOT NULL
)
SELECT
    order_line_id,
    extras_split as extra_topping_id
FROM
    orders_extras order by order_line_id;
ALTER TABLE customer_orders_extras
MODIFY COLUMN extra_topping_id INTEGER;

-- Model Runner Orders Ratings
DROP TABLE IF EXISTS runner_orders_ratings;
CREATE TABLE runner_orders_ratings(
    order_id int,
    customer_id int,
    runner_id int,
    rating_score int,
    CONSTRAINT CHK_rating_score CHECK (rating_score between 0 and 5),
    CONSTRAINT FK_runner_ratings_runner_id FOREIGN KEY (runner_id)
        REFERENCES runners(runner_id) 
);
INSERT INTO runner_orders_ratings
(order_id, customer_id, runner_id, rating_score)
SELECT 
    ro.order_id,
    co.customer_id,
    ro.runner_id,
    FLOOR(RAND()*(5)) as rating_score
FROM runner_orders ro 
LEFT JOIN customer_orders co
    ON ro.order_id = co.order_id
WHERE ro.cancellation IS NULL
GROUP BY 1,2,3;
    
-- Add Supreme Pizza
DELETE FROM pizza_names WHERE pizza_id = 3;
INSERT INTO pizza_names
(pizza_id, pizza_name)
VALUES
(3, "Supreme");

DELETE FROM pizza_recipes WHERE pizza_id = 3;
INSERT INTO pizza_recipes
(pizza_id, toppings)
SELECT 
    3,
    GROUP_CONCAT(topping_id separator ", ")
FROM pizza_toppings
GROUP BY 1;

DELETE FROM pizza_recipes_split WHERE pizza_id = 3;
INSERT INTO pizza_recipes_split
(pizza_id, topping_id)
SELECT 
    3,
    topping_id
FROM pizza_toppings;


