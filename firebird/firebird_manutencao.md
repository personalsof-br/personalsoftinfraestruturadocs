### Consulta de transações ativas

```sql
select
  a0.mon$attachment_id,
  a0.mon$attachment_name,
  a0.mon$user,
  a0.mon$role,
  a0.mon$remote_process,
  a0.mon$remote_host,
  a0.mon$remote_os_user,
  t0.mon$transaction_id,
  t0.mon$state,
  t0.mon$timestamp,
  s0.mon$sql_text
from
  mon$attachments a0
  inner join mon$transactions t0 on t0.mon$attachment_id = a0.mon$attachment_id
  left join mon$statements s0 on s0.mon$transaction_id = t0.mon$transaction_id
order by
  t0.mon$timestamp
```

### Finalização de transações ativas há mais de 1 hora

```sql
delete from mon$attachments x where x.mon$attachment_id in (  
select
  a0.mon$attachment_id
from
  mon$attachments a0
  inner join mon$transactions t0 on t0.mon$attachment_id = a0.mon$attachment_id
  left join mon$statements s0 on s0.mon$transaction_id = t0.mon$transaction_id
where
  t0.mon$timestamp < dateadd(hour, -1, current_timestamp)
order by
  t0.mon$timestamp)
```
