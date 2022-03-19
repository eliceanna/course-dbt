{{ 
    config(
        materialized='table'
    ) 
}}

WITH events AS (

    SELECT *
      , MAX(is_order_event) OVER (PARTITION BY session_id) AS is_order_session
    FROM {{ ref('fct_events') }}
    GRO

)

SELECT session_id
  , user_id
  , CASE WHEN is_order_session = 1 THEN TRUE ELSE FALSE END AS is_order_session
  , SUM(CASE WHEN event_type = 'page_view' THEN 1 ELSE 0 END) AS session_page_views
  
FROM events
GROUP BY 1,2,3
