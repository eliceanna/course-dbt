{{
  config(
    materialized='view'
  )
}}

SELECT promo_id
  , CAST(discount AS DECIMAL(4,2)) AS promo_discount
  , status AS promo_status

FROM {{ source('tutorial', 'promos') }}