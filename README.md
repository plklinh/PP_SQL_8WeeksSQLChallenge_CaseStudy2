# PP_SQL_8WeeksSQLChallenge_CaseStudy2

# PersonalProject_SQL_8WeeksSQLChallenge_CaseStudy3

This project data and problem statement are courtesy of **8 Week SQL Challenge** by Danny Ma and the Data with Danny team. 
Please find the source data and details [here](https://8weeksqlchallenge.com/case-study-2/).

The goal is to assist a fictional pizzeria in cleaning their data and finding ways to optimize their operations with basic calculations.
The data cleaning component makes this challenge differ from Case Study 3 - where the data was basically clean and the main objective was on practicing queries.

## Data 
### Original Data
The original data consists of 6 tables:
*Dim Tables*
- pizza_names: list of all avaialable pizza types
- pizza_toppings: list of all available pizza toppings
- pizza_recipes: comma-separated list of toppings for each pizza type
- pizza_runners: list of pizza runners
*Fact Tables*
- runner_orders: details on order deliveries, including cancellation status, runner, pickup time, distance and time taken 
- customer_orders: details on pizza orders, including order time, requested extra and excluded toppings

### Data Cleaning & Remodelling
The original data had the various evident quality issues:
- Null values were inconsistently encoded as null, or empty string.
    - *Solution*: Re-encode as null
- Distance and duration values had units stored alongside the numeric value as text.
    - *Solution*: Remove unit and convert columns to numeric data type. Also rename column to have the unit of measure included for clarity
- Some columns had improper data types such as pickup time being stored as text.
    - *Solution*: Update column to proper data type

These aside, the data had some modelling problems that would have made it harder to work with.
- In particular, the pizza recipe, extras and exclusions were stored as CSV.
- This meant the data was not normalized, and made joining with dimensions like pizza toppings or calculations based on said columns to be more difficult.
- *Solution*:
    - This gave me a chance to look into a query concept I've rarely used before which is *Recursive Table Expression*. I'd like to credit Stackoverflow for the basic query template.
    - Applying this technique, I restructured the pizza_recipes table to long format, and also extracted two addtional tables for extras and exclusions.   

### Cleaned and Remodelled Data
The cleaned and remodelled data has the following tables.

This new structure allowed me to use more straightforward joins to answer the challenge questions, as opposed to having to parsing the CSV values then join.
- pizza_runners
- pizza_names
- pizza_toppings
- *(Added)* pizza_recipes_split
- runner_orders
- customer_orders
- *(Added)* customer_orders_extras
- *(Added)* customer_orders_exclusions

## Getting Started

The Data with Danny team provided [instructions](https://8weeksqlchallenge.com/case-study-2/) for setting up the data.

For this project, I created a **MySQL** database instance on my local machine.

The main files for this project are as follows. All the queries are written using **MySQL**.
- **Data_Definition.sql**: Run this file first to set up the original data as instructed.
- **Data_Cleaning.sql**: Run this file second to do basic data cleaning
- **Data_Remodelling.sql**: Run this file third to complete the data remodelling. This file also contains the answers to some of the questions in section E for adding an additional pizza type.
- **Project_Pizza_Runner**: Lastly, run this file for the data analysis challenge questions.

There is an addtional config file **config.yaml** containing database connection credentials. This is excluded from the repo. 
- I needed this to use Python + SQL Alchemy the ipynb file, because I kept having syntax issues with the SQL cells in Visual Studio Code.
- In hindsight, I should have debugged more to find out what's wrong with my IDE setup, but going with Python did end up being somewhat useful as it allowed me to do some quick visualizations with pandas.
- It's also my first time working with config/yaml file. I'm most likely not doing it correctly, so this is something I need to look into more.
