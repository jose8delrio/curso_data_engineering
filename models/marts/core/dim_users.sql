-- models/dim_users.sql


select *
from {{ ref('stg_sql_server_dbo__users') }}