{% snapshot orders_snapshot_check %}

    {{
        config(
          target_schema='snapshots',
          strategy='check',
          unique_key='order_id',
          check_cols=['status']
        )
    }}

    SELECT * FROM {{ source('tutorial', 'orders') }}

{% endsnapshot %}