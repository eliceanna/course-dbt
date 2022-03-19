{{
  config(
    materialized='view'
  )
}}

SELECT product_id
  , name AS product_name
  , price AS product_price
  , inventory

FROM {{ source('tutorial', 'products') }}