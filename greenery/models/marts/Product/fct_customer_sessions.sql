{{ 
    config(
        materialized='table'
    ) 
}}

WITH session_duration AS (

    SELECT session_id
      , MIN(event_created_at_utc) AS session_first_event
      , MAX(event_created_at_utc) AS session_last_event

    FROM {{ ref('fct_events')}}
    GROUP BY 1

) , users AS (

    SELECT * FROM {{ ref('dim_users')}}

) , int_session_events_agg AS (

    SELECT * FROM {{ ref('int_session_events_agg')}}

)

SELECT int_session_events_agg.session_id
  , int_session_events_agg.user_id
  , users.user_name
  , users.email
  , int_session_events_agg.session_page_view
  , int_session_events_agg.is_order_session
  , session_duration.session_first_event
  , session_duration.session_last_event
  , (session_last_event - session_first_event) / 60 AS session_duration_minutes

FROM int_session_events_agg
LEFT JOIN users
  ON int_session_events_agg.user_id = users.user_id
LEFT JOIN session_duration
  ON int_session_events_agg.session_id = session_duration.session_id