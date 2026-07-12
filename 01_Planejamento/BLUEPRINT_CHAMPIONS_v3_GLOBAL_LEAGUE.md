# 🏆 BLUEPRINT ARQUITETURAL — CHAMPIONS 7-0 v3.0 (THE GLOBAL LEAGUE)
**Autor:** Antigravity AI & Gabriel Maximiano (MaxxSystem Software Factory)  
**Data:** Julho de 2026  
**Status:** Aguardando Aprovação do Cliente (Gate de Planejamento & Discovery Gate)

---

## 📋 1. Visão Geral do Produto (Executive Summary)

O projeto **Champions 7-0** está saindo da fase de MVP local (onde dados e troféus ficavam confinados na memória do navegador de um único computador) para se tornar uma **Plataforma Competitiva na Nuvem (e-Sport de Draft & Simulação Tática)**.

O objetivo da versão **3.0 — The Global League** é criar uma experiência competitiva contínua, viciante e de alta durabilidade, onde jogadores de qualquer lugar (amigos da escola, comunidade online) criam seus perfis de treinadores, acumulam pontos de Elo e disputam divisões globais em tempo real na nuvem utilizando a stack **Vercel + Supabase PostgreSQL**.

---

## 🏛️ 2. Arquitetura de Dados na Nuvem (Supabase PostgreSQL Schema)

Abaixo está a modelagem de dados relacional e escalável que será implantada na sua conta conectada do Supabase, com segurança de nível de linha (`RLS - Row Level Security`) e índices otimizados para consultas de ranking instantâneas:

```sql
-- 1. Tabela de Perfis de Treinador (Coach Profiles)
CREATE TABLE public.coach_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    auth_user_id UUID UNIQUE, -- Opcional para login via Supabase Auth / ou Convidado Sincronizado
    username VARCHAR(30) UNIQUE NOT NULL,
    avatar_id VARCHAR(50) DEFAULT 'avatar-classic-1',
    division VARCHAR(20) DEFAULT 'Série C' CHECK (division IN ('Série C', 'Série B', 'Liga de Elite (Série A)')),
    trophies_elo INTEGER DEFAULT 1000 NOT NULL,
    coins INTEGER DEFAULT 100 NOT NULL,
    total_wins INTEGER DEFAULT 0 NOT NULL,
    total_matches INTEGER DEFAULT 0 NOT NULL,
    goals_scored INTEGER DEFAULT 0 NOT NULL,
    goals_conceded INTEGER DEFAULT 0 NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Índice para busca ultrarrápida do Leaderboard Mundial ordenado por Elo e Gols
CREATE INDEX idx_leaderboard_elo ON public.coach_profiles (trophies_elo DESC, (goals_scored - goals_conceded) DESC);

-- 2. Tabela de Esquadrões Salvos / Drafts da Nuvem (Para modo PVP / Desafios)
CREATE TABLE public.saved_drafts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    profile_id UUID REFERENCES public.coach_profiles(id) ON DELETE CASCADE,
    team_name VARCHAR(60) NOT NULL,
    formation VARCHAR(10) NOT NULL,
    tactical_style VARCHAR(20) DEFAULT 'equilibrado',
    roster_json JSONB NOT NULL, -- Escalação completa (Titulares e 7 Reservas) com química e atributos
    chemistry INTEGER NOT NULL,
    avg_rating INTEGER NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. Histórico e Auditoria de Partidas (Matches Log)
CREATE TABLE public.matches_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_profile_id UUID REFERENCES public.coach_profiles(id) ON DELETE CASCADE,
    opponent_name VARCHAR(60) NOT NULL,
    is_pvp BOOLEAN DEFAULT false,
    opponent_profile_id UUID REFERENCES public.coach_profiles(id) ON DELETE SET NULL,
    user_goals INTEGER NOT NULL,
    opp_goals INTEGER NOT NULL,
    is_win BOOLEAN NOT NULL,
    elo_change INTEGER NOT NULL,
    coins_earned INTEGER NOT NULL,
    played_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. Ídolos e Lendas Desbloqueadas na Loja (Pack Opener)
CREATE TABLE public.unlocked_legends (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    profile_id UUID REFERENCES public.coach_profiles(id) ON DELETE CASCADE,
    legend_name VARCHAR(60) NOT NULL,
    card_tier VARCHAR(20) DEFAULT 'ICON 99',
    unlocked_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(profile_id, legend_name)
);
```

---

## 🎨 3. Mapa de Telas & Nova Experiência de Usuário (Wireframes Visuais)

A interface preservará a estética **Retro-Samba Gold / Neo-Brutalista** (verde neon, dourado imperial, preto profundo com sombras rígidas e efeitos 3D de cartas), mas ganhará uma navegabilidade de e-Sport em 5 módulos principais:

### 📱 Módulo 1: Lobby Principal & Painel do Treinador (Nuvem)
* **Card de Treinador:** Exibe o escudo personalizado, Nome, Divisão Atual (Série C, B ou A com ícone de troféu brilhante), Pontuação de Elo, Moedas de Ouro (`🪙`) e Estatísticas.
* **Tabela de Classificação Global (Ao Vivo):** Abas interativas (`[Série A - Elite]`, `[Série B]`, `[Série C]`). Os 10 primeiros colocados ganham destaques dourados/prateados. Indicadores de **+30 Elo hoje** ou **Zona de Rebaixamento (-50 Elo)**.

### 📱 Módulo 2: Seletor de Modos de Campeonato (O Grande Salto de Conteúdo)
* **⚡ Modo 1: Copa Relâmpago 7-0 (Clássico):** O formato rápido de 3 jogos de grupo + 4 eliminatórias para quem tem pouco tempo ou quer testar um combo tático rápido.
* **🇧🇷 Modo 2: Campeonato Brasileiro 2026 — As 4 Divisões (Turno e Returno):** O verdadeiro teste de resistência do futebol nacional! Você disputa o **Campeonato Brasileiro de 2026** divido em 4 Séries (A, B, C e D). Tabela em tempo real com pontos corridos (3 pts vitória, 1 empate), artilharia, melhor defesa e acesso/rebaixamento no final!
* **⚔️ Modo 3: Arena PVP (Desafiar a Comunidade):** Sorteie um oponente real entre os times salvos na nuvem por outros jogadores ou digite o **Código de Desafio (`#DRAFT-9982`)** do seu amigo da escola para disputar o clássico!

### 📱 Módulo 3: Draft Tático Ampliado & Banco de Reservas (11 + 7)
* **Escalação de 18 Jogadores:** O Draft agora sorteia os **11 Titulares no Campo Tático e 7 Reservas no Banco lateral**.
* **Indicador de Química e Sinergia:** Conexões por clubes históricos (Linhas Neon SVG) e bônus por posição natural e estilo tático.
* **Janela de Transferências do Campeonato Brasileiro:** No decorrer do campeonato, a cada 5 rodadas o treinador pode abrir o painel de trocas, selecionar 1 carta do seu elenco e rodar a roleta para escolher entre 3 novos candidatos para reforçar a equipe!

### 📱 Módulo 4: Simulador Tático Adaptativo 2.0 (Mais Inteligente e Dificuldade Dinâmica)
* **Gestão de Stamina / Fadiga (`⚡ 100% → 35%`):** Jogadores que atuam seguidamente ficam cansados (barra amarela/vermelha). Se a energia baixar de 40%, o jogador perde 3 pontos de rating no campo e corre risco de lesão! O treinador deve arrastar jogadores do banco de reservas no intervalo.
* **IA Inteligente & Contra-Medidas Táticas:**
  * Se você estiver jogando no `OFENSIVO` e abrindo 2x0 no primeiro tempo, a IA adversária mudará para `RETRANCA E CONTRA-ATAQUE` ou `PRESSÃO ALTA`.
  * O narrador de texto avisará: *“🚨 O técnico adversário alterou o esquema para Pressão Total! Sua defesa está sob ataque pesado!”*
* **Cartões e Clima:** O jogo sorteará condições climáticas (`☀️ Sol / 🌧️ Chuva Pesada`). Na chuva, chutes de longe ganham +20% de precisão e passes curtos perdem 15%. Faltas duras geram cartões amarelos e vermelhos (expulsão reduz em 25% a força da defesa).
* **Decisão por Pênaltis Dramática:** Com bônus de **+5 Troféus/Elo na Nuvem** para o vencedor em caso de empates no mata-mata.

### 📱 Módulo 5: Loja de Moedas & Abertura de Pacotes (Pack Opener de Lendas)
* **Acúmulo de Moedas (`🪙 Moedas 7-0`):** Ganhe moedas por vitórias, goleadas, clean sheets e títulos no Campeonato Brasileiro.
* **Loja de Pacotes Premium:**
  * 📦 **Pacote Ouro (250 Moedas):** Garante pelo menos 1 carta de Ouro (Rating 90+) no próximo draft.
  * 📦 **Pacote Lendário Ícones (800 Moedas):** Desbloqueia permanentemente uma carta histórica secreta (*Pelé '70*, *Ronaldo '02*, *Ronaldinho '05*, *Maldini '03*) para a sua conta na nuvem! O card ganha uma animação com fogos de artifício e brilho dourado infinito na tela!

---

## 📅 4. Roadmap de Execução & Microentregas (Para Aprovação)

Para mantermos o projeto 100% funcional na Vercel a cada etapa, dividimos a construção em **3 Sprints de Microentregas Aprováveis**:

| Sprint | Nome da Microentrega | O que será construído e entregue | Prazo / Status |
| :---: | :---: | :---: | :---: |
| **SPRINT 1** | **Nuvem & Ranking Global (Supabase Core)** | Conexão com Supabase PostgreSQL, criação das tabelas, tela de login do treinador, perfil com troféus de Elo na nuvem e substituição da tabela local pelo **Ranking Mundial ao Vivo (Divisões C, B e A)**. | **Aguardando Validação** |
| **SPRINT 2** | **Banco de Reservas, Fadiga & IA Adaptativa** | Expansão do Draft para incluir **7 reservas**, barra de Stamina/Fadiga em tempo real, substituições no intervalo, cartões (amarelo/vermelho), clima da partida e a **IA Adaptativa** que muda de tática para te desafiar. | Sequencial |
| **SPRINT 3** | **Campeonato Brasileiro 2026 (4 Divisões), PVP & Loja de Lendas** | Criação do modo **Campeonato Brasileiro 2026 (Série A, B, C e D)** com pontos corridos, artilharia, janela de transferências a cada 5 jogos, arena de desafios entre jogadores na nuvem (PVP) e a **Loja de Pacotes com Ícones 99**. | Sequencial |

---

## 🚦 5. Gate de Validação e Discovery Gate (Em Andamento)

Obedecendo ao **Discovery Gate** da MaxxSystem, o módulo do **Campeonato Brasileiro 2026** está passando primeiro pela validação e verificação de dados reais das 4 divisões oficiais da temporada de 2026 (elencos, técnicos, escudos e força média) no arquivo `DADOS_CAMPEONATO_BRASILEIRO_2026.md` antes de qualquer linha de código ser escrita!
