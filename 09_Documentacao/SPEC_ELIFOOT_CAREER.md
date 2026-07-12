# Especificação de Projeto (SPEC): Elifoot Career Mode (champions-7-0 v3.0)

Esta especificação detalha o escopo técnico, regras de negócio, arquitetura de dados e fluxo de telas para a implementação do módulo **Elifoot Career Mode**. O sistema recria a dinâmica clássica do jogo *Elifoot 98* na web, utilizando o banco de dados do Supabase para renderizar elencos reais atualizados e logos do futebol brasileiro.

---

## 1. Escopo do Produto e Proposta de Valor

O **Elifoot Career Mode** é um simulador de carreira de técnico com foco em agilidade tática, mercado financeiro estrito e simulação de rodadas paralelas rápidas.

### Ganhos do Negócio (ROI & Retenção):
*   **Fator Nostalgia + Dados Reais:** Unir a mecânica consagrada do Elifoot à escalação oficial do Brasileirão 2026 atrai e retém fãs de futebol com custo zero de aquisição de tráfego.
*   **Sessões Rápidas de Jogo:** Diferente de managers complexos (como Football Manager), o Elifoot permite concluir uma temporada em 15 minutos, gerando alta taxa de retorno diário (D1).

---

## 2. Estrutura e Mapeamento de Dados (Supabase & Estado Local)

O estado do jogo será mantido na memória da sessão do usuário sob o objeto `elifootState` e sincronizado com o banco Supabase na tabela `coach_profiles` no término de cada rodada/temporada.

### Extensão do Schema DB (Mapeamento de Tabelas):
1.  **`coach_profiles` (Campos de Carreira):**
    *   `elifoot_club_id` (int): ID do time atual do treinador.
    *   `elifoot_prestige` (int): Reputação do técnico (0 a 100).
    *   `elifoot_coins` (bigint): Dinheiro em caixa do clube (representado em R$).
    *   `elifoot_stadium_capacity` (json): Capacidade por setor (Geral, Arquibancada, Cadeiras, Camarotes).
    *   `elifoot_stadium_ticket_prices` (json): Preços cobrados por tipo de ingresso.
2.  **`elifoot_squad_data` (Armazenamento Temporário do Elenco do Usuário):**
    *   `id` (UUID, PK)
    *   `coach_profile_id` (FK)
    *   `player_id` (FK para tabela `players`)
    *   `stamina` (int): Nível de energia física (0 a 100).
    *   `cards` (int): Status de suspensão (0 = ok, 1 = amarelo, 2 = suspenso por vermelho/3 amarelos).
    *   `is_injured` (boolean): Status médico.

---

## 3. Divisões e Calendário do Campeonato

O simulador organiza os 40 clubes cadastrados no Supabase em **4 divisões fixas de 10 times cada** (Série A, Série B, Série C, Série D).

*   **Formato de Pontos Corridos:** Turno e returno (18 rodadas).
*   **Promoção e Rebaixamento:**
    *   Os 3 primeiros colocados sobem para a divisão superior no final do campeonato.
    *   Os 3 últimos colocados caem para a divisão inferior.
*   **Taça Nacional (Copa Mata-Mata):** Competição paralela integrada em formato de playoffs de jogo único entre todos os 40 times.
*   **Ganho:** Estrutura competitiva dinâmica que mantém o usuário focado em lutar por títulos, acessos ou fuga do rebaixamento a cada rodada.

---

## 4. O Elenco e Escalação Tática

O elenco do usuário tem capacidade máxima de **24 jogadores**.

*   **Posições Simplificadas do Elifoot:**
    *   **G** (Goleiro), **D** (Defensor), **M** (Meio-Campo) e **A** (Atacante).
    *   *Mapeamento do DB:* O motor converterá as posições reais da API (ex: LE, ZAG, LD vira "D"; MC, ME, VOL vira "M") de forma transparente no carregamento.
*   **Stamina (Energia Física):**
    *   Jogar uma partida consome de 10% a 20% de stamina (influenciado pela idade e posição).
    *   Jogadores que descansam no banco recuperam 15% de stamina por rodada.
    *   **Ganho:** Incentiva o rodízio do elenco e valoriza a contratação de reservas de qualidade.

---

## 5. Simulador de Rodadas Simultâneas (Live Matches Ticker)

Esta é a tela principal de simulação da rodada. Exibe todos os 5 jogos da divisão em paralelo.

```
+-------------------------------------------------------------------+
|  [|| Pausar Simulação ]                        Cronômetro: 45'    |
+-------------------------------------------------------------------+
|  SE Palmeiras   1 - 0   CR Flamengo   (Gol: Rony 14')             |
|  Botafogo FR    0 - 1   São Paulo FC  (Gol: Calleri 32')          |
|  Cruzeiro EC    2 - 2   Atlético-MG   (Gol: Hulk 9', Kaio J. 41') |
|  ...                                                              |
+-------------------------------------------------------------------+
|  TABELA AO VIVO (SÉRIE A)                                         |
|  1. Palmeiras - 38 pts   |  3. Botafogo - 32 pts                  |
|  2. São Paulo - 35 pts   |  4. Flamengo - 30 pts                  |
+-------------------------------------------------------------------+
```

### Regras do Motor de Simulação:
*   **Tempo Acelerado:** A partida dura 9 segundos reais (1 segundo de tela = 10 minutos de jogo).
*   **Cálculo de Probabilidade:** A cada "minuto" simulado, o sistema calcula chances de gol baseadas na força do ataque de um time contra a defesa do outro.
*   **Botão de Pausa:** O usuário pode pausar o relógio a qualquer momento para fazer substituições táticas urgentes se um jogador se lesionar ou cansar.
*   **Live Table:** A classificação se reordena instantaneamente na lateral da tela a cada gol marcado nos 5 campos.
*   **Ganho:** Tensão e dinamismo idênticos à emoção do Elifoot original.

---

## 6. Mercado de Leilões Dinâmicos e Contra-lances CPU

O mercado de transferências é baseado em leilões rápidos de 10 segundos por atleta listado.

*   **Leilão de Compra:**
    *   Um jogador livre ou de outro clube é anunciado com lance inicial baseado no OVR e idade.
    *   O usuário clica em "+ Dar Lance" (adiciona 5% ao valor).
    *   A CPU (controlando times rivais) simula contra-lances automáticos baseados no orçamento virtual do seu nível de divisão.
    *   O cronômetro reinicia para 3 segundos a cada lance nos momentos finais (efeito *anti-sniper*).
*   **Leilão de Venda:**
    *   O usuário escolhe um jogador de seu elenco e o coloca no leilão.
    *   Diferentes times controlados pela CPU dão lances concorrentes. O usuário decide aceitar ou recusar a maior proposta financeira apresentada.
*   **Ganho:** A interatividade do leilão contra a IA cria uma experiência de negociação competitiva divertida e rápida.

---

## 7. Finanças do Clube e Expansão do Estádio

O usuário gerencia as contas do clube em um balanço financeiro semanal:

```
SALDO ATUAL: R$ 5.200.000

RECEITAS (Rodada em Casa):
(+) Bilheteria: R$ 850.000 (Público: 35.000 / Cap: 40.000)
(+) Patrocínio Semanal: R$ 200.000

DESPESAS:
(-) Salários do Elenco: R$ 380.000
(-) Manutenção do CT: R$ 50.000
(-) Juros de Empréstimo: R$ 20.000

SALDO FINAL: R$ 5.800.000
```

*   **Precificação de Ingressos:** O usuário define o preço dos setores (Geral, Arquibancada, Cadeiras, Camarotes). Se cobrar muito alto, a ocupação cai; se cobrar muito baixo, deixa de lucrar.
*   **Expansão de Capacidade:** Investir fundos para aumentar a capacidade física dos setores do estádio, permitindo maiores arrecadações no futuro.
*   **Balanço de Salários:** Jogadores de maior OVR exigem maiores salários. Elencos muito inflados podem levar o clube à insolvência.
*   **Ganho:** Desafio econômico real. O jogador precisa gerenciar o crescimento desportivo em equilíbrio com a saúde financeira do clube.

---

## 8. Prestígio do Treinador: Demissão, Convites e Carreira

A progressão do usuário é medida pelo seu prestígio profissional (reputação de 0 a 100):

*   **Perda do Emprego (Demissão):**
    *   Ocorre caso o time seja rebaixado de forma vexatória ou se o caixa do clube permanecer no vermelho (insolvente) por 3 semanas seguidas.
    *   **Penalidade:** O treinador perde prestígio e precisa aceitar o cargo em um time sorteado da Série D (4ª divisão) com baixos recursos para recomeçar.
*   **Convites da CPU:**
    *   No final da temporada, se o prestígio do técnico estiver alto, clubes de divisões superiores com OVRs maiores enviarão propostas de contratação.
    *   O usuário escolhe se permanece para subir o clube atual de divisão ou se muda de time para buscar títulos mais rapidamente.
*   **Ganho:** Senso de longevidade e conquista. O jogador constrói um legado de carreira através de múltiplos clubes.

---

## 9. Proteção do Módulo Draft (Draft Shield)

*   **Segregação Visual:** Os novos botões e telas estarão contidos no contêiner isolado `#screen-elifoot-container` (dividido em `#elifoot-ct`, `#elifoot-match`, `#elifoot-auction`).
*   **Segregação Lógica:** Todas as funções começarão com o prefixo `elifoot*` (ex: `elifootInit()`, `elifootSimulateMatch()`) e ficarão dentro de `js/career/elifoot-core.js` e arquivos auxiliares, não compartilhando variáveis com o loop de Draft do `app.js`.

---
*Especificação de Projeto (SPEC) redigida em 11 de Julho de 2026.*
*Maxx AI Software Factory - Documento GD-DS-003-ELIFOOT.*
