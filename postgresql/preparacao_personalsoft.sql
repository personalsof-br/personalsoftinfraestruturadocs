--Descricao=Criando o usuário 'postgres'
--Term=--^
do $$
begin
  if (current_user <> 'postgres') then
    raise exception 'Requer usuário postgres';
  end if;
end $$;
--^

--Descricao=Criando o usuário 'personalsoft'
--Term=--^
do $$
begin
  if (not exists (select * from pg_catalog.pg_roles a where a.rolname = 'personalsoft')) then
    create role personalsoft inherit login password 'personalsoft';
  end if;
end $$;
--^

--Descricao=Criando o usuário 'personalsoft_app'
--Term=--^
do $$
begin
  if (not exists (select * from pg_catalog.pg_roles a where a.rolname = 'personalsoft_app')) then
    create role personalsoft_app inherit login password 'personalsoft_app';
  end if;
end $$;
--^

--Descricao=Criando o grupo 'personalsoft_rw'
--Term=--^
do $$
begin
  if (not exists (select * from pg_catalog.pg_roles a where a.rolname = 'personalsoft_rw')) then
    create role personalsoft_rw noinherit nologin;
  end if;
end $$;
--^

--Descricao=Criando o grupo 'personalsoft_ro'
--Term=--^
do $$
begin
  if (not exists (select * from pg_catalog.pg_roles a where a.rolname = 'personalsoft_ro')) then
    create role personalsoft_ro noinherit nologin;
  end if;
end $$;
--^

grant all on database postgres to personalsoft;

grant personalsoft_ro to personalsoft_app;
grant personalsoft_rw to personalsoft_app;
