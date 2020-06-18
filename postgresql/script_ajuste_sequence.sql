/*
 * ps_wms.inventario
 */
alter sequence ps_wms.inventario_codigo_seq
  minvalue 0
  restart with 1000;
    
do $$
declare r record;
begin
	for r in
	select
	  *
	from
	  ps_wms.inventario a
	order by
	  a.codigo
	loop
	  update ps_wms.inventario i1 set codigo = nextval('ps_wms.inventario_codigo_seq') where i1.id = r.id;
	end loop;
end $$;

/*
 * ps_wms.ordem_recebimento
 */
alter sequence ps_wms.ordem_recebimento_codigo_seq
  minvalue 0
  restart with 100;
    
do $$
declare r record;
begin
	for r in
	select
	  *
	from
	  ps_wms.ordem_recebimento a
	order by
	  a.codigo
	loop
	  update ps_wms.ordem_recebimento i1 set codigo = nextval('ps_wms.ordem_recebimento_codigo_seq') where i1.id = r.id;
	end loop;
end $$;

/*
 * ps_wms.ordem_movimentacao
 */
alter sequence ps_wms.ordem_movimentacao_codigo_seq
  minvalue 0
  restart with 100;
    
do $$
declare r record;
begin
	for r in
	select
	  *
	from
	  ps_wms.ordem_movimentacao a
	order by
	  a.codigo
	loop
	  update ps_wms.ordem_movimentacao i1 set codigo = nextval('ps_wms.ordem_movimentacao_codigo_seq') where i1.id = r.id;
	end loop;
end $$;

/*
 * ps_wms.reserva
 */
alter sequence ps_wms.reserva_codigo_seq
  minvalue 0
  restart with 1000;
  
do $$
declare r record;
begin
	for r in
	select
	  *
	from
	  ps_wms.reserva a
	where
	  a.codigo > 1000
	order by
	  a.codigo
	loop
	  update ps_wms.reserva i1 set codigo = nextval('ps_wms.reserva_codigo_seq') where i1.id = r.id;
	end loop;
end $$;

/*
 * ps_wms.programacao
 */
alter sequence ps_wms.programacao_codigo_seq
  minvalue 0
  restart with 1000;
  
do $$
declare r record;
begin
	for r in
	select
	  *
	from
	  ps_wms.programacao a
	where
	  a.codigo > 100
	order by
	  a.codigo
	loop
	  update ps_wms.programacao i1 set codigo = nextval('ps_wms.programacao_codigo_seq') where i1.id = r.id;
	end loop;
end $$;

/*
 * ps_wms.volume_lista
 */
alter sequence ps_wms.volume_lista_codigo_seq
  minvalue 0
  restart with 1000;
  
do $$
declare r record;
begin
	for r in
	select
	  *
	from
	  ps_wms.volume_lista a
	order by
	  a.codigo
	loop
	  update ps_wms.volume_lista i1 set codigo = nextval('ps_wms.volume_lista_codigo_seq') where i1.id = r.id;
	end loop;
end $$;

/*
 * ps_wms.nota_fiscal
 */
alter sequence ps_wms.nota_fiscal_codigo_seq
  minvalue 0
  restart with 1000;
  
do $$
declare r record;
begin
	for r in
	select
	  *
	from
	  ps_wms.nota_fiscal a
	order by
	  a.codigo
	loop
	  update ps_wms.nota_fiscal i1 set codigo = nextval('ps_wms.nota_fiscal_codigo_seq') where i1.id = r.id;
	end loop;
end $$;

/*
 * ps_wms.previsao_entrada
 */
alter sequence ps_wms.previsao_entrada_codigo_seq
  minvalue 0
  restart with 1000;
  
do $$
declare r record;
begin
	for r in
	select
	  *
	from
	  ps_wms.previsao_entrada a
	order by
	  a.codigo
	loop
	  update ps_wms.previsao_entrada i1 set codigo = nextval('ps_wms.previsao_entrada_codigo_seq') where i1.id = r.id;
	end loop;
end $$;

/*
 * ps_wms.previsao_saida
 */
alter sequence ps_wms.previsao_saida_codigo_seq
  minvalue 0
  restart with 1000;
  
do $$
declare r record;
begin
	for r in
	select
	  *
	from
	  ps_wms.previsao_saida a
	order by
	  a.codigo
	loop
	  update ps_wms.previsao_saida i1 set codigo = nextval('ps_wms.previsao_saida_codigo_seq') where i1.id = r.id;
	end loop;
end $$;
