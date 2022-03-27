{% set event_types = ['page_view', 'add_to_cart', 'checkout', 'package_shipped'] %}

{{ 
    config(
        materialized='table'
    ) 
}}


WITH events AS (

    SELECT *
      , MAX(is_order_event) OVER (PARTITION BY session_id) AS is_order_session
    FROM {{ ref('fct_events') }}

)

SELECT session_id
  , user_id
  , CASE WHEN is_order_session = 1 THEN TRUE ELSE FALSE END AS is_order_session

   {% for event_type in event_types %}
  , SUM(CASE WHEN event_type = '{{event_type}}' THEN 1 ELSE 0 END) AS session_{{event_type}}
   {% endfor %}

FROM events
GROUP BY 1,2,3
