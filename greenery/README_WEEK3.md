## Part 1

### Question 1: 

_What is our overall conversion rate?_

```
WITH base AS (

  SELECT 
      COUNT(DISTINCT session_id) AS distinct_sessions
    , COUNT(DISTINCT order_id) AS orders
    
  FROM dbt_elisaveta_aleksieva.stg_events
  
)

SELECT (orders::float4 / distinct_sessions::float4) * 100 AS conversion_rate
FROM base 
```

**Answer:**
---> ± 62.46%

### Question 2: 
_What is our conversion rate by product?_

**Answer:**
| Product Name        | Conversion Rate    |
| --------------------| -------------------|
| Bird of Paradise    | 55.000001192092896 |  
| Devil's Ivy         | 53.33333611488342  |
| Dragon Tree         | 54.83871102333069  |
| Pothos              | 39.34426307678223  |
| Philodendron        | 51.61290168762207  |
| Rubber Plant        | 59.25925970077515  |
| Angel Wings Begonia | 52.45901346206665  |
| Pilea Peperomioides | 52.542370557785034 |
| Majesty Palm        | 56.71641826629639  |
| Aloe Vera           | 55.384618043899536 |
| Spider Plant        | 50.847458839416504 |
| Bamboo              | 62.68656849861145  |
| Alocasia Polly      | 52.941179275512695 |
| Arrow Head          | 61.90476417541504  |
| Pink Anthurium      | 50                 |
| Ficus               | 51.47058963775635  |
| Jade Plant          | 52.173912525177    |
| ZZ Plant            | 55.55555820465088  |
| Calathea Makoyana   | 60.37735939025879  |
| Birds Nest Fern     | 51.28205418586731  |
| Monstera            | 53.06122303009033  |
| Cactus              | 58.1818163394928   |
| Orchid              | 49.33333396911621  |
| Money Tree          | 46.42857015132904  |
| Ponytail Palm       | 42.85714328289032  |
| Boston Fern         | 53.96825671195984  |
| Peace Lily          | 53.03030014038086  |
| Fiddle Leaf Fig     | 53.57142686843872  |
| Snake Plant         | 46.5753436088562   |
| String of pearls    | 68.75              |


## Part 2

**Answer:** 
```
Added a macro to int_session_events_agg.sql to count event_types per session

```

## Part 4 

**Answer:** 
```
Installed dbt-metrics and added a model called order_period_over_period which includes secondary calculations on the primary metric - orders such as WoW, weekly AVG for a specific month and rolling avg. Primary metric is defined in the core_schema.yml and the macro is called in the orders_period_over_period.sql

[Package documentation link](https://hub.getdbt.com/dbt-labs/metrics/latest/)
 
```
