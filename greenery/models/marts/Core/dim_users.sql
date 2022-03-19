{{
  config(
    materialized='table'
  )
}}

WITH stg_users AS (

    SELECT * FROM {{ ref('stg_users') }}

) , stg_addresses AS (
    
    SELECT * FROM {{ ref('stg_addresses') }}

) , stg_orders AS (

    SELECT * FROM {{ ref('stg_orders') }}

) , order_stats AS (

    SELECT
      
      user_id
    , MIN(order_created_at_utc) AS first_order_created_at_utc
    , MAX(order_created_at_utc) AS last_order_created_at_utc
    , COUNT(DISTINCT order_id) AS number_of_orders

  FROM stg_orders
  GROUP BY 1

)

SELECT stg_users.user_id
  , CONCAT(stg_users.user_first_name, stg_users.user_last_name) AS user_name
  , stg_users.email 
  , stg_users.phone_number
  , stg_users.user_created_at_utc
  , stg_users.updated_at_utc
  , stg_addresses.address AS user_address
  , stg_addresses.state AS user_state
  , stg_addresses.country AS user_country
  , order_stats.first_order_created_at_utc
  , order_stats.last_order_created_at_utc
  , order_stats.number_of_orders

FROM stg_users
LEFT JOIN stg_addresses
  ON stg_users.address_id = stg_addresses.address_id
LEFT JOIN order_stats 
  ON stg_users.user_id = order_stats.user_id