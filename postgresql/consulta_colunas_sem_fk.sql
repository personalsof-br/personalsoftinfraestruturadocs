select
  c0.table_schema,
  c0.table_name,
  c0.column_name
from
  information_schema.columns c0
where
  c0.table_schema = 'ps_wms'
  and c0.column_name like '%_id'
	and not exists (
    select
      tc0.constraint_name,
      tc0.table_name,
      kcu0.column_name, 
      ccu0.table_name AS foreign_table_name,
      ccu0.column_name AS foreign_column_name 
    from 
      information_schema.table_constraints tc0
      inner join information_schema.key_column_usage kcu0 on tc0.constraint_name = kcu0.constraint_name
      inner join information_schema.constraint_column_usage AS ccu0 on ccu0.constraint_name = tc0.constraint_name
    where
      tc0.constraint_type = 'FOREIGN KEY' and tc0.table_schema = c0.table_schema and tc0.table_name = c0.table_name and kcu0.column_name = c0.column_name
  )
order by
  c0.table_name,
  c0.column_name