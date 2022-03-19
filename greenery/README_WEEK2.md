What is our user repeat rate?

WITH orders_per_user AS (
    SELECT COUNT(CASE WHEN number_of_orders > 0 THEN 1 ELSE 0 END) AS customer_with_at_least_1_order
     , COUNT(CASE WHEN number_of_orders >= 2 THEN 1 ELSE 0 END) AS customers_with_more_than_1_order
    FROM dim_users
)

SELECT 

(CAST(customers_with_more_than_1_order AS FLOAT) / customer_with_at_least_1_order)*100 AS repeat_rate

FROM orders_per_user


---> ± 79%


What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

- Session frequency and duration - how often do they browse the website and how much time they spend on the website (are they engaged users)
- Number of orders they placed already > the more orders they have placed the more likely is they are a loyal customer and will likely order again. 
- Recency of orders - if they haven't placed an order for a very long time they probably have churned.
- Shipping on time vs delayed shipping

If we had more data -- customer satisfaction score / order review (after an order) is one type of indicator that can help identify customers who are likely to order or not order again. 

Explain the marts models you added. Why did you organize the models in the way you did?

In the core folder, I added two dim tables - users and products and two fact tables - events and orders. 
In the marketing folder, I added one fact table that contains order data aggregated on the customer level. This is to understand which customers are valuable for the business and which ones might need more marketing effort in order to order again.
In the product folder, I added one intermediate table to aggregate the events data, and one prod fact table to combine the aggregated events with user data. The intermediate table can be reused for other purposes as well.


Testing
1. What assumptions are you making about each model? (i.e. why are you adding each test?)


Unique and not_null tests: primary keys

Positive values test: order cost, shipping cost, order total amount, order quantity, product price, discount amount
Expect column values to be integer type test: order quantity
I haven't added any tests to my marts models yet, given that the transformations I applied so far are not too heavy and the calculations are relatively straightforward.

2. Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?

Answer

I haven't found any bad data yet. (But I'm sure after adding more complext business logic, or as the data size grows, there definitely will be.)

3. Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.

Answer

I would schedule dbt jobs to refresh models and run tests on a daily basis. I would then integrate dbt jobs notifications to relevant Slack channels so that stakeholders would get notified immediately after a job failed.

