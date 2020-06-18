-- role readonly
create role readonly;

grant usage on schema <schema> to readonly;
grant select on all tables in schema <schema> TO readonly;

create user <user> password '<password>';
grant readonly to <user>;
