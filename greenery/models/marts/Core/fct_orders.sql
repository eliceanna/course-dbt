{{
  config(
    materialized='table'
  )
}}

WITH orders AS (

    SELECT * FROM {{ ref('stg_orders') }} 

) , promos AS (

    SELECT * FROM {{ ref('stg_promos') }} 

) , order_items AS (

    SELECT order_id
      , COUNT(DISTINCT product_id) AS distinct_products_order
      , SUM(quantity) AS total_quantity_order
    FROM {{ ref('stg_order_items') }} 
    GROUP BY 1

) , addresses AS (

    SELECT * FROM {{ ref('stg_addresses') }}
   
)

SELECT 
  -- ids
    orders.order_id
  , orders.promo_id
  , orders.user_id
  , orders.tracking_id
  -- dates
  , orders.order_created_at_utc
  , orders.estimated_delivery_at_utc
  , orders.delivered_at_utc
  -- financial metrics
  , orders.order_cost
  , orders.shipping_cost
  , orders.order_total
  , promos.promo_discount
  , (orders.order_total - orders.order_cost - orders.shipping_cost) AS order_profit
  , (orders.order_total - orders.order_cost - orders.shipping_cost - promos.promo_discount) /  orders.order_total AS order_margin_percentage
  -- order info
  , addresses.country
  , orders.shipping_service
  , orders.order_status
  , order_items.distinct_products_order
  , order_items.total_quantity_order
  , CASE 
      WHEN DATE(orders.delivered_at_utc) <= DATE(orders.estimated_delivery_at_utc) 
        THEN TRUE
        ELSE FALSE
    END AS is_delivered_on_time
  , CAST(orders.order_created_at_utc AS date) - CAST(orders.delivered_at_utc AS date) AS days_from_order_to_delivery

FROM orders 
LEFT JOIN order_items
  ON orders.order_id = order_items.order_id
LEFT JOIN promos
  ON orders.promo_id = promos.promo_id
LEFT JOIN addresses
  ON orders.address_id = addresses.address_id 