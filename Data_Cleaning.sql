use PP_8WSC_pizza_runner;

-- Clean runner_orders
-- Standardize 'null' and '' encoding to NULL
update runner_orders
set pickup_time = NULL
where pickup_time = 'null';

update runner_orders
set distance = NULL
where distance = 'null';

update runner_orders
set duration = NULL
where duration = 'null';

update runner_orders
set cancellation = NULL
where cancellation = 'null' or cancellation = '' ;

-- Update data type for pickup_time
alter table runner_orders
modify column pickup_time timestamp;

-- Clean distance - remove text and convert to float
alter table runner_orders
add column distance_km float(3);

update runner_orders
set distance_km = cast(replace(distance,"km","") as float(3));

alter table runner_orders
drop column distance;

-- Clean duration - remove text and convert to float
alter table runner_orders
add column duration_minutes float(3);

update runner_orders
set duration_minutes = cast(substring(duration, 1,2) as float(3));

alter table runner_orders
drop column duration;


-- Clean customer_orders
-- Standardize 'null' and '' encoding to NULL
update customer_orders
set exclusions = NULL
where exclusions = "null" or exclusions = "";

update customer_orders
set extras = NULL
where extras = "null" or extras = "";
