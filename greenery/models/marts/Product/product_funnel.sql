WITH sessions AS (

    SELECT * FROM {{ ref('fct_sessions') }}

), funnel AS (

    SELECT 
        'Total Sessions' AS funnel_step
      , SUM(CASE 
              WHEN page_view > 0
                OR add_to_cart > 0
                OR checkout > 0 
                OR orders = 1
                  THEN 1 
                  ELSE 0 
            END) AS data_value

    FROM sessions

    UNION ALL

    SELECT
        'Add to Cart Sessions' AS funnel_step
      , SUM(CASE 
              WHEN add_to_cart > 0
                OR checkout > 0 
                OR orders = 1
                  THEN 1 
                  ELSE 0 
            END) AS data_value

    FROM sessions

    UNION ALL
    
    SELECT
       'Checkout Sessions' AS funnel_step
      , SUM(CASE WHEN checkout > 0 
                   OR orders = 1
                     THEN 1 
                     ELSE 0 
            END) AS data_value

    FROM sessions

    UNION ALL
    
    SELECT
        'Purchase Sessions' AS funnel_step,
        SUM(orders) AS data_value

    FROM sessions

), previous_steps AS (

    SELECT 
        funnel_step
      , data_value
      , LAG(data_value) OVER () AS previous_step
      , FIRST_VALUE(data_value) OVER () AS first_step

    FROM funnel 

), final AS (

    SELECT 
        funnel_step
      , data_value
      , previous_step
      , ROUND(data_value / previous_step::numeric, 2) AS previous_step_conversion
      , (1 - ROUND(data_value / previous_step::numeric, 2)) * 100 AS previous_step_conversion_drop_off
      , ROUND(data_value / first_step::numeric, 2) AS first_step_conversion
      , (1 - ROUND(data_value / first_step::numeric, 2)) * 100 AS first_step_conversion_drop_off

    FROM previous_steps
)

SELECT *

FROM final