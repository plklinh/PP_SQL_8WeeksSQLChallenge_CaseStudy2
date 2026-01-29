-- Credit: https://stackoverflow.com/questions/17942508/sql-split-values-to-multiple-rows

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