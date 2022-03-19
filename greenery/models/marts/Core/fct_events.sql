{{
  config(
    materialized='table'
  )
}}

WITH stg_events AS (

    SELECT * FROM {{ ref('stg_events') }}

)

SELECT event_id
  , session_id
  , user_id
  , event_type
  , page_url
  , event_created_at_utc
  , order_id
  , product_id
  , CASE
      WHEN order_id IS NOT NULL
        THEN 1 
      ELSE 0
    END AS is_order_event

FROM stg_events