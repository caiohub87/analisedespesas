# Sistema de Despesas — Dilnor

Controle de despesas × faturamento + metas. App separado do saaslogistica (banco Supabase próprio), mesma stack (HTML + JS + Supabase + pdf.js). Visual: dashboard escuro.

## Arquivos

- **index.html** — **o sistema** (é só esse arquivo). Telas: Home, Enviar Relatório, Orçamento, Detalhamento, Auditoria.
- **_antigo/painel-escuro.html** — versão anterior (tema escuro), fora de uso. Guardada só por segurança.
- **vercel.json** — configuração de publicação (Vercel).
- **carga_parte_1..4_de_4.sql** — os 3.617 registros históricos (base atualizada até 23.07.2026), em 4 partes.
- **_setup/criar_tabelas.sql** — cria as 3 tabelas no Supabase.
- **_setup/corrigir_policies.sql** — ajusta as permissões (aceita o login .gerente).

## Como colocar no ar (2 passos)

### 1. Colar as chaves do Supabase no app
- Abra **index.html** no VS Code.
- Bem no começo do bloco `<script>` tem duas linhas marcadas **">>> COLE SUAS CHAVES <<<"**:
  ```js
  const SUPA_URL = '';   // cole aqui a Project URL
  const SUPA_KEY = '';   // cole aqui a anon public key
  ```
- Pegue os valores em **Supabase → (projeto de despesas) → Settings → API**:
  - **Project URL** → vai em `SUPA_URL` (ex.: `'https://xxxxx.supabase.co'`)
  - **anon public** → vai em `SUPA_KEY` (ex.: `'eyJhbGciOi...'`)
- Salve. (A chave anon é pública; pode ficar no arquivo — as policies do banco protegem os dados.)

### 2. Publicar
Escolha um jeito:
- **Vercel (arrastar):** entre no vercel.com → New Project → arraste esta pasta. Pronto, vira um site.
- **Mesmo repositório do saaslogistica:** copie esta pasta para dentro do repo (ex.: `/despesas/`) e faça deploy pelo fluxo que já usa.

> Sem as chaves, o app abre em **modo demonstração** (dados de exemplo). Com as chaves, pede login (`dilnor.gerente@gestao.app`).

## Setup do banco (Supabase) — só na primeira vez

1. **Criar tabelas:** SQL Editor → New query → cole `_setup/criar_tabelas.sql` → Run.
2. **Criar login:** Authentication → Users → Add user → `dilnor.gerente@gestao.app` + senha + ✅ Auto Confirm.
3. **Corrigir permissões:** SQL Editor → cole `_setup/corrigir_policies.sql` → Run.
3b. **Ampliar as metas:** SQL Editor → cole `_setup/atualizar_metas.sql` → Run. Adiciona `observacao` e `atualizado_em`; é seguro rodar de novo e não apaga nada.
4. **Carregar histórico:** rode as 4 partes `carga_parte_1..4_de_4.sql` (uma por vez).
   - Confira: `SELECT COUNT(*) FROM despesas WHERE unidade='dilnor';` → deve dar **3617**.

## Como usar (dia a dia)

- **Enviar relatório:** arraste o PDF do balancete ("124 - Por Conta"). O app lê período, faturamento e as contas, confere a soma com o total do PDF, você confirma o mês de competência e grava. Reenviar o mesmo mês **atualiza** (não duplica).
- **Orçamento (Lançamento de Metas Mensais):** escolha o mês nas setas ou nos seletores. Em cima ficam as metas gerais (faturamento, limite de despesas, economia, % máximo e uma observação do mês); embaixo, as metas por conta agrupadas por área, cada uma com valor e observação. Botões: **Copiar mês anterior**, **Limpar metas** e **Cancelar**. Nada vai para o banco antes de clicar em **Salvar metas** — apagar o valor e salvar remove a meta.
- **Análise por Área:** acompanhamento das metas do mês — quanto foi orçado, quanto já saiu, saldo e quais estouraram, por área e por conta.
- **Painel:** despesa do mês × faturamento, comparativo dos grupos e evolução mensal.

## Se fechar o navegador no meio do trabalho

O que você digita no Orçamento é guardado **automaticamente no navegador** (a cada meio segundo), separado por mês. Se fechar a aba, o navegador travar ou a máquina desligar, ao voltar em Orçamento aparece um aviso amarelo com a data do rascunho e os botões **Restaurar** / **Descartar**. Se o rascunho for de outro mês, o aviso traz o link para ir até ele.

Ao tentar fechar a aba com metas não salvas — ou com um relatório lido e ainda não gravado — o navegador pergunta antes de sair.

Dois avisos honestos:
- O rascunho fica **naquele computador e naquele navegador**. Em outra máquina (ou numa janela anônima) ele não aparece. O que vale em qualquer lugar é o que foi **salvo** no banco.
- Limpar os dados de navegação apaga o rascunho. **Salvar metas** é o que garante.

## Status

- [x] Banco criado + histórico carregado (3.617 registros)
- [x] App: painel, upload de PDF (parser validado, conferência bate), metas
- [ ] Colar chaves do Supabase e publicar
- [ ] Testar login e gravação reais
- [ ] Tela "Análise" (comparativos ano a ano) — a fazer

## Decisões registradas

- **Banco:** projeto Supabase próprio (separado do saaslogistica); hospedagem pode ser a mesma.
- **Login:** usuário dedicado (`dilnor.gerente@gestao.app`).
- **Upload:** PDF do "124 - Balancete"; competência (mês/ano) confirmada no upload.
- **Estrutura:** 15 grupos, destaque para os 4 principais (Geral, Predial, Depósito, Logística).
- **Metas:** TOTAL + 4 grupos principais + qualquer conta individual (subclasse). Na tabela `metas`, a coluna `alvo` guarda `'TOTAL'`, o código da área (3 dígitos, ex.: `'366'`) ou o código da conta (5 dígitos, ex.: `'35103'` = Água). Gerente digita com a referência (mês anterior + realizado) à vista.
- **Sinais:** despesa gravada positiva, crédito (juros recebidos, etc.) negativo — soma bate com o total do relatório.
