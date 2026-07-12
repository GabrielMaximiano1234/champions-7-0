# Status - champions-7-0

- [2026-07-09] Codigo local importado para o ecossistema e estruturado em 13 pastas.
- [2026-07-09] **SPRINT 1 — Microentrega 1 CONCLUÍDA:** Segurança & Schema v3 no Supabase.
  - Criadas 4 novas tabelas v3.0: `coach_profiles`, `saved_drafts`, `matches_log`, `unlocked_legends`.
  - RLS habilitado em todas as 9 tabelas do banco (`teams`, `coaches`, `players`, `player_career_history`, `api_sync_audit_logs` + as 4 novas).
  - Políticas configuradas: leitura pública para dados de referência e leaderboard; escrita restrita ao dono do perfil.
  - Índice `idx_leaderboard_elo` criado para ordenação ultrarrápida do ranking mundial.
  - Próximo passo: ~~Microentrega 2~~ ✅ CONCLUÍDA.
- [2026-07-09] **SPRINT 1 — Microentrega 2 CONCLUÍDA:** Chave de API Real & Expansão do Cliente.
  - Substituída a `SUPABASE_ANON_KEY` placeholder pela chave ativa do projeto `zzarhsvlwaecjnjyxvsa`.
  - Módulo `supabase-client.js` expandido com 5 novas funções: `getCoachProfileByUsername`, `createCoachProfile`, `updateCoachStats`, `loadGlobalLeaderboard` + fallback de leaderboard.
  - Validação de dados: 13 times visíveis, 27 jogadores ativos, coach_profiles pronto para receber registros.
  - `GlobalLeagueDB` v3.0 exportado para `window` com todas as funções necessárias para as próximas microentregas.
  - Próximo passo: ~~Microentrega 3~~ ✅ CONCLUÍDA.
- [2026-07-09] **SPRINT 1 — Microentrega 3 CONCLUÍDA:** Perfis de Treinador na Nuvem.
  - `initSession()` reescrita como `async`: busca perfil atualizado na nuvem por username a cada sessão; fallback offline via `localStorage`.
  - `registerUser()` reescrita como `async`: fluxo de login/cadastro por apelido único via `createCoachProfile()` / `getCoachProfileByUsername()`. Sem senha — acesso pelo apelido global.
  - `renderLeaderboard()` reescrita como `async`: ranking carregado de `coach_profiles` na nuvem via `loadGlobalLeaderboard()`. Estado vazio com mensagem motivacional.
  - `logoutUser()`: apaga apenas o cache de sessão local. Dados do treinador ficam seguros na nuvem.
  - `processarFimDeCampeonato()`: mutações de stats migradas para campos v3.0 (`trophies_elo`, `total_wins`, `goals_scored`, `goals_conceded`). Sync com nuvem via `updateCoachStats()` de forma assíncrona (não bloqueia UI).
  - `updateHudInfo()`: lê campos v3.0 com fallback `??` para campos legados.
  - `index.html`: tela de auth simplificada — apenas campo de apelido + hint sobre ranking global.
  - Próximo passo: ~~Microentrega 4~~ ✅ CONCLUÍDA (wiring já existia — M3 completou o trabalho).
- [2026-07-09] **SPRINT 1 CONCLUÍDO ✅** — Nuvem & Ranking Global: todas as 4 microentregas entregues.
- [2026-07-09] **Remoção do Histórico de Jogadores:** modal `#modal-player-history` removido do HTML e JS.
- [2026-07-09] **Modo Carreira Brasileirão — Fase 1 + 2 ENTREGUES:**
  - Migration DB: `coach_profiles` ganhou `current_club_id`, `career_season`, `career_coins`; criada tabela `career_contracts` com RLS.
  - HTML: 2 novas telas isoladas (`screen-career-select`, `screen-career-ct`) com filtros de divisão, grid de clubes, abas Elenco/Mercado e filtros de posição/clube.
  - Botão "🏟️ MODO CARREIRA BRASILEIRÃO" adicionado ao Lobby.
  - JS: Engine completo (`careerState`, `showCareerSelectScreen`, `showCareerCT`, `loadCareerClubs`, `loadSquad`, `loadMarket`, `contractPlayer`, `formatCurrency`) totalmente separado do modo draft.
  - Modo Draft: **NÃO foi alterado** — isolamento garantido.
  - Próximo: Fase 3 (Disputar Rodada) — Sprint 2.
- [2026-07-10] **Benchmark Competitivo & Diagnóstico:**
  - Realizado o benchmark completo do concorrente `thefenomeno.com` (Simulador de Carreira de Jogador com RPG).
  - Criado o dossiê detalhado em `09_Documentacao/BENCHMARK_THE_FENOMENO.md` contendo a comparação de propostas de valor, diagnóstico de capacidades (Forte/Fraco/Defasado) e o plano de evolução para o `champions-7-0` com foco em identidade visual premium, barra de progresso visual de temporada, objetivos da diretoria e dilemas/eventos narrativos interativos.
- [2026-07-10] **Proposta de Arquitetura Modular:**
  - Desenvolvida a proposta em `09_Documentacao/PROPOSTA_MODULARIZACAO.md` apresentando a blindagem do Módulo Draft (Draft Shield) e o plano físico e lógico para adicionar a Simulação de Partida de Liga, RPG de Dilemas, Gestão de Metas da Diretoria e Desenvolvimento no Modo Carreira de forma 100% isolada e segura contra regressões.
- [2026-07-10] **Plano de Ação Elifoot:**
  - Analisado o vídeo de referência do clássico `Elifoot 98`.
  - Elaborado o plano de ação detalhado em `09_Documentacao/PLANO_DE_ACAO_ELIFOOT.md` mapeando a criação do módulo de carreira "Elifoot Moderno" utilizando a API e banco de dados do Supabase (`teams`, `players` e logos integrados) para as divisões A, B, C e D.
  - O plano de ação descreve o fluxo de escalação e stamina, simulação simultânea com cronômetro acelerado e gols em tempo real (Live Match Screen), leilão dinâmico contra CPU, gestão de finanças/estádio e convites/demissões de técnicos.
- [2026-07-10] **Especificação de Projeto (SPEC) Elifoot:**
  - Criada a especificação técnica completa em `09_Documentacao/SPEC_ELIFOOT_CAREER.md`.
  - Detalhadas as regras de negócio de divisões (10 times por divisão, 18 rodadas, acesso e descenso), conversão de posições modernas para clássicas (G, D, M, A), lógica matemática da simulação paralela de jogos, algoritmo de leilões com contra-lances da CPU, gestão financeira detalhada (bilheteria vs salários), expansão de setores do estádio e fluxo de convite/demissão de técnicos.
- [2026-07-10] **Roadmap de Telas e Campos Elifoot:**
  - Criado o roadmap detalhado de telas em `09_Documentacao/ROADMAP_TELAS_ELIFOOT.md`.
  - Especificadas as 8 telas consecutivas (Lobby, Seleção de Clube, Centro de Treinamento, Gestão de Elenco, Mercado de Transferências, Finanças/Estádio, Simulador Simultâneo de Rodadas, Balanço de Fim de Temporada) com os inputs/outputs correspondentes e IDs de interface únicos.
  - Mapeado o vínculo de persistência e progresso do técnico diretamente com a tabela `coach_profiles` no Supabase, garantindo a atualização do ranking online global por Elo (troféus), títulos e gols.





