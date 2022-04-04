{{ 
    config(
        materialized='table'
    ) 
}}

WITH base AS (

    SELECT 
        session_id
      , COUNT(DISTINCT 
              CASE 
                WHEN event_type = 'page_view' 
                  THEN session_id 
                  ELSE NULL 
              END) AS page_view
      , COUNT(DISTINCT 
              CASE 
                WHEN event_type = 'add_to_cart' 
                  THEN session_id 
                  ELSE NULL
              END) AS add_to_cart
      , COUNT(DISTINCT
              CASE
                WHEN event_type = 'checkout'
                  THEN session_id
                  ELSE NULL
              END) AS checkout
      , COUNT(DISTINCT 
              CASE
                WHEN is_order_event = 1
                  THEN order_id
                  ELSE NULL
              END) AS orders

    FROM {{ ref('fct_events') }}
    GROUP BY 1

)

SELECT *

FROM base
