-- Amplia a tabela de metas: observação por linha e data da última alteração.
-- Roda UMA VEZ no Supabase → SQL Editor → New query → Run.
-- É seguro rodar de novo: não apaga nem altera nenhuma meta já cadastrada.

alter table metas add column if not exists observacao text;
alter table metas add column if not exists atualizado_em timestamptz default now();

-- Preenche a data nas metas que já existiam (usa a data de criação).
update metas set atualizado_em = created_at where atualizado_em is null;

-- A coluna "alvo" passa a aceitar, além de 'TOTAL' e do código da área (3 dígitos):
--   'FATURAMENTO' = meta de faturamento do mês
--   'ECONOMIA'    = meta de economia do mês
--   'NOTA'        = observação geral do mês (valor_meta fica 0)
--   código de 5 dígitos = meta de uma conta (ex.: '35103' = ÁGUA)
-- Nenhuma restrição precisa ser criada: a coluna já é texto livre.
