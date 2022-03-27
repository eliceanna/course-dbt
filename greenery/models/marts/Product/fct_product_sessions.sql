{{ 
    config(
        materialized='table'
    ) 
}}

WITH base AS (

    SELECT 
        product_id
      , COUNT(DISTINCT 
              CASE 
                WHEN event_type = 'page_view' 
                  THEN session_id 
                  ELSE NULL 
              END) as product_sessions
      , COUNT(DISTINCT 
              CASE 
                WHEN event_type = 'add_to_cart' 
                  THEN session_id 
                  ELSE NULL
              END) AS product_added_to_cart
      , COUNT(DISTINCT 
              CASE
                WHEN is_order_event = 1
                  THEN order_id
                  ELSE NULL
              END) AS orders

    FROM {{ ref('fct_events') }}

    GROUP BY product_id

) , products AS (

    SELECT * FROM {{ ref('dim_products') }}

)

SELECT 
    products.product_id
  , products.product_name
  , COALESCE(base.product_sessions, 0) AS product_sessions
  , COALESCE(base.product_added_to_cart, 0) AS product_added_to_cart
  , COALESCE(base.orders, 0) AS orders
  , (product_added_to_cart::float4 / product_sessions::float4) * 100 AS conversion_rate

FROM products 
LEFT JOIN base
  ON products.product_id = base.product_id
