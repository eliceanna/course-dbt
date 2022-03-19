{{ 
    config(
        materialized='table'
    ) 
}}

WITH users AS (

    SELECT * FROM {{ ref('stg_users') }} 

) , orders AS (

    SELECT * FROM {{ ref('stg_orders') }} 

) , order_stats AS (

    SELECT user_id
      , COUNT(DISTINCT order_id) AS total_orders
      , COUNT(DISTINCT CASE 
                         WHEN promo_id IS NOT NULL
                           THEN order_id 
                         ELSE NULL 
                        END) AS promo_orders
      , SUM(order_total) AS total_revenue
      , COUNT(DISTINCT CASE 
                         WHEN DATE(delivered_at_utc) <= DATE(estimated_delivery_at_utc) 
                           THEN order_id
                           ELSE NULL
                        END ) AS orders_delivered_on_time

    FROM orders
    GROUP BY 1

)

SELECT users.user_id
    , CONCAT(users.user_first_name, users.user_last_name) AS user_name
    , email
    , order_stats.total_orders
    , order_stats.promo_orders
    , order_stats.total_revenue
    , order_stats.orders_delivered_on_time
    , order_stats.orders_delivered_on_time / total_orders AS on_time_order_ratio
    
FROM users 
LEFT JOIN order_stats
  ON users.user_id = order_stats.user_id
