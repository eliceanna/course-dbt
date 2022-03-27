{{ 
    config(
        materialized='table'
    ) 
}}

SELECT * 
FROM {{ metrics.metric(
    metric_name='orders',
    grain='week',
    dimensions=['country', 'order_status'],
    secondary_calculations=[
        metrics.period_over_period(comparison_strategy="ratio", interval=1, alias="pop_1wk"),
        metrics.period_over_period(comparison_strategy="difference", interval=1),

        metrics.period_to_date(aggregate="average", period="month", alias="this_month_average"),
        metrics.period_to_date(aggregate="sum", period="year"),

        metrics.rolling(aggregate="average", interval=4, alias="avg_past_4wks"),
        metrics.rolling(aggregate="min", interval=4)
    ],
    start_date='2020-01-01'
) }}