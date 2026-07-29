-- Cria as 3 tabelas do módulo de despesas
-- Roda UMA VEZ no Supabase → SQL Editor → New query → Run

create table if not exists despesas (
  id bigint generated always as identity primary key,
  unidade text not null,
  ano int not null,
  mes int not null,
  grupo text not null,
  grupo_nome text,
  codigo int not null,
  conta text,
  valor numeric default 0,
  periodo_inicio date,
  periodo_fim date,
  created_at timestamptz default now(),
  unique (unidade, ano, mes, codigo)
);
alter table despesas enable row level security;
drop policy if exists "leitura unidade despesas" on despesas;
drop policy if exists "escrita admin despesas" on despesas;
create policy "leitura unidade despesas" on despesas
  for select to authenticated
  using ( lower(unidade) = split_part(auth.email(), '.', 1) );
create policy "escrita admin despesas" on despesas
  for all to authenticated
  using ( lower(unidade) = split_part(auth.email(), '.', 1) and (auth.email() like '%.admin@%' or auth.email() like '%.gerente@%') )
  with check ( lower(unidade) = split_part(auth.email(), '.', 1) and (auth.email() like '%.admin@%' or auth.email() like '%.gerente@%') );

create table if not exists despesas_faturamento (
  id bigint generated always as identity primary key,
  unidade text not null,
  ano int not null,
  mes int not null,
  fat_bruto numeric,
  fat_liquido numeric,
  cmv numeric,
  saldo_bruto numeric,
  periodo_inicio date,
  periodo_fim date,
  created_at timestamptz default now(),
  unique (unidade, ano, mes)
);
alter table despesas_faturamento enable row level security;
drop policy if exists "leitura unidade fat" on despesas_faturamento;
drop policy if exists "escrita admin fat" on despesas_faturamento;
create policy "leitura unidade fat" on despesas_faturamento
  for select to authenticated
  using ( lower(unidade) = split_part(auth.email(), '.', 1) );
create policy "escrita admin fat" on despesas_faturamento
  for all to authenticated
  using ( lower(unidade) = split_part(auth.email(), '.', 1) and (auth.email() like '%.admin@%' or auth.email() like '%.gerente@%') )
  with check ( lower(unidade) = split_part(auth.email(), '.', 1) and (auth.email() like '%.admin@%' or auth.email() like '%.gerente@%') );

create table if not exists metas (
  id bigint generated always as identity primary key,
  unidade text not null,
  ano int not null,
  mes int not null,
  alvo text not null,
  valor_meta numeric default 0,
  created_at timestamptz default now(),
  unique (unidade, ano, mes, alvo)
);
alter table metas enable row level security;
drop policy if exists "leitura unidade metas" on metas;
drop policy if exists "escrita admin metas" on metas;
create policy "leitura unidade metas" on metas
  for select to authenticated
  using ( lower(unidade) = split_part(auth.email(), '.', 1) );
create policy "escrita admin metas" on metas
  for all to authenticated
  using ( lower(unidade) = split_part(auth.email(), '.', 1) and (auth.email() like '%.admin@%' or auth.email() like '%.gerente@%') )
  with check ( lower(unidade) = split_part(auth.email(), '.', 1) and (auth.email() like '%.admin@%' or auth.email() like '%.gerente@%') );
