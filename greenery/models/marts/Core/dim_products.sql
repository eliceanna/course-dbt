{{
  config(
    materialized='table'
  )
}}

SELECT product_id
  , product_name
  , product_price
  , inventory

FROM {{ ref('stg_products') }} p