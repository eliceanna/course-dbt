{{
  config(
    materialized='view'
  )
}}

SELECT order_id
  , promo_id
  , user_id
  , address_id
  , created_at AS order_created_at_utc
  , CAST(order_cost AS DECIMAL(19,2)) AS order_cost
  , CAST(shipping_cost AS DECIMAL(19,2)) AS shipping_cost
  , CAST(order_total AS DECIMAL(19,2)) AS order_total
  , tracking_id
  , shipping_service
  , estimated_delivery_at AS estimated_delivery_at_utc
  , delivered_at AS delivered_at_utc 
  , status AS order_status

FROM {{ source('tutorial', 'orders') }}