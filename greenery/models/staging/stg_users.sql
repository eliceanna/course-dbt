{{
  config(
    materialized='view'
  )
}}

SELECT user_id
  , first_name AS user_first_name
  , last_name AS user_last_name
  , email 
  , phone_number
  , created_at AS user_created_at_utc
  , updated_at AS updated_at_utc
  , address_id

FROM {{ source('tutorial', 'users') }}