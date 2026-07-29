-- Corrige as policies do módulo despesas para aceitar .gerente
-- Roda uma vez e é idempotente (seguro rodar de novo sem erro)

drop policy if exists "leitura unidade despesas" on despesas;
drop policy if exists "escrita admin despesas" on despesas;
create policy "leitura unidade despesas" on despesas
  for select to authenticated
  using ( lower(unidade) = split_part(auth.email(), '.', 1) );
create policy "escrita admin despesas" on despesas
  for all to authenticated
  using ( lower(unidade) = split_part(auth.email(), '.', 1) and (auth.email() like '%.admin@%' or auth.email() like '%.gerente@%') )
  with check ( lower(unidade) = split_part(auth.email(), '.', 1) and (auth.email() like '%.admin@%' or auth.email() like '%.gerente@%') );

drop policy if exists "leitura unidade fat" on despesas_faturamento;
drop policy if exists "escrita admin fat" on despesas_faturamento;
create policy "leitura unidade fat" on despesas_faturamento
  for select to authenticated
  using ( lower(unidade) = split_part(auth.email(), '.', 1) );
create policy "escrita admin fat" on despesas_faturamento
  for all to authenticated
  using ( lower(unidade) = split_part(auth.email(), '.', 1) and (auth.email() like '%.admin@%' or auth.email() like '%.gerente@%') )
  with check ( lower(unidade) = split_part(auth.email(), '.', 1) and (auth.email() like '%.admin@%' or auth.email() like '%.gerente@%') );

drop policy if exists "leitura unidade metas" on metas;
drop policy if exists "escrita admin metas" on metas;
create policy "leitura unidade metas" on metas
  for select to authenticated
  using ( lower(unidade) = split_part(auth.email(), '.', 1) );
create policy "escrita admin metas" on metas
  for all to authenticated
  using ( lower(unidade) = split_part(auth.email(), '.', 1) and (auth.email() like '%.admin@%' or auth.email() like '%.gerente@%') )
  with check ( lower(unidade) = split_part(auth.email(), '.', 1) and (auth.email() like '%.admin@%' or auth.email() like '%.gerente@%') );
