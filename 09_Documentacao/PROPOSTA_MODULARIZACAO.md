# Proposta de Arquitetura Modular: champions-7-0 (v3.0)

Esta proposta apresenta o plano para a reestruturação e expansão modular do simulador **champions-7-0**, permitindo a inclusão de novos recursos e fases sem introduzir riscos de regressão ou alterações no **Módulo Draft** existente, que permanecerá 100% isolado.

---

## 1. Princípio da Arquitetura de Isolamento (Draft Shield)

Para blindar o Módulo Draft (que hoje controla a seleção de lendas, entrosamento de eras e a simulação de partidas da Copa), adotamos o padrão **De-coupling de Estado e Escopos**:

```mermaid
graph TD
    %% Nós principais
    Lobby[Lobby & Leaderboard] --> Draft[Módulo Draft - app.js]
    Lobby --> Career[Módulo Carreira - Novo Core]

    %% Detalhes do Draft (Intocado)
    subgraph Módulo Draft (Legado Isolado)
        Draft --> StateDraft[state global]
        Draft --> HTMLDraft[tela-draft & tela-simulador]
    end

    %% Novos Módulos de Carreira
    subgraph Novo Ecossistema Modular (Carreira)
        Career --> StateCareer[careerState isolado]
        Career --> ModMatch[Módulo de Partida - career-match.js]
        Career --> ModRPG[Módulo Narrativo - career-rpg.js]
        Career --> ModTraining[Módulo de Treino - career-training.js]
        Career --> ModUI[Telas Separadas - HTML Isolado]
    end
```

---

## 2. Divisão dos Novos Módulos

Propomos a criação de **4 módulos lógicos de Carreira**, cada um implementado em arquivos JS e estruturas HTML independentes.

### Módulo A: Motor de Partida da Liga (career-match.js)
*   **Descrição:** Executa a simulação da partida da rodada da Série A/B/C/D. Diferente da `tela-simulador` do Draft, este motor calcula o resultado com base no OVR de Defesa/Meio/Ataque do clube do jogador contra os atributos do adversário brasileiro, oferecendo um *Live Ticker* estilizado.
*   **Ganhos & ROI:**
    *   *Retenção:* Entrega o clímax da rodada. Acompanhar os gols minuto a minuto de times nacionais cria alto engajamento.
    *   *Segurança:* Evita conflitos de variáveis globais de tempo de jogo (`currentMatchMinute`, `simIntervalId`) com o simulador de lendas.

### Módulo B: Eventos Narrativos & Dilemas (career-rpg.js)
*   **Descrição:** Um orquestrador de eventos aleatórios ou engatilhados entre rodadas (ex: coletiva pós-derrota, reclamações de salário, propostas de suborno de cartolas). Exibe popups de decisão que afetam a moral do time (`careerState.moral`), os fundos (`careerState.career_coins`) e a pressão da diretoria.
*   **Ganhos & ROI:**
    *   *Fator Replay:* Torna cada campanha única. O usuário não está apenas simulando números; ele está vivendo a história de um treinador no Brasil.
    *   *Monetização Indireta:* O acúmulo e gasto de moedas devido a eventos narrativos equilibra a economia do jogo.

### Módulo C: Gestão de Metas & Diretoria (career-objectives.js)
*   **Descrição:** Cria o "Boardroom" (Conselho da Diretoria) no CT. No início de cada temporada, a diretoria gera 3 metas (ex: "Terminar no G4", "Economizar 20.000 moedas", "Fazer mais de 50 gols"). Cumprir ou falhar altera a estabilidade do cargo.
*   **Ganhos & ROI:**
    *   *Profundidade de Gameplay:* O jogador tem metas claras de curto e longo prazo.
    *   *Feedback Loop:* Dá valor às decisões de mercado (contratar jogadores mais caros para atingir metas desportivas vs. economizar para bater metas financeiras).

### Módulo D: Desenvolvimento & CT (career-training.js)
*   **Descrição:** Permite investir `career_coins` e gastar energia física do elenco para treinar e evoluir atributos setoriais (Upgrade de OVR do ataque, defesa, meio e goleiro) ou melhorar as instalações de DM (reduz chance de lesão).
*   **Ganhos & ROI:**
    *   *Sustentabilidade de Moedas:* Cria um "ralo de moedas" saudável, evitando que o jogador acumule moedas indefinidamente sem ter onde gastar no mercado de transferências.

---

## 3. Estruturação Física de Arquivos

Para manter o repositório organizado e em conformidade com o padrão da Maxx AI Software Factory, os arquivos serão organizados da seguinte forma:

```
04_Desenvolvimento/
├── frontend/
│   ├── css/
│   │   ├── style.css (Lobby & Geral)
│   │   └── career-theme.css (Estilos Dark Premium específicos)
│   ├── js/
│   │   ├── app.js (Auth, Lobby, Leaderboard e Módulo Draft Intocado)
│   │   ├── supabase-client.js (Infra de Nuvem)
│   │   └── career/ (Pasta dedicada ao Novo Módulo)
│   │       ├── career-core.js (Gerenciador de telas e estado geral)
│   │       ├── career-match.js (Motor de simulação e placar da rodada)
│   │       ├── career-rpg.js (Dilemas, moral e torcida)
│   │       └── career-training.js (Upgrades e CT)
│   └── index.html (Importa os novos scripts no final do body)
```

---

## 4. Estratégia de Não-Interferência no HTML (`index.html`)

Toda a interface dos novos módulos de Carreira ficará contida dentro das telas exclusivas do Brasileirão:
*   `#screen-career-select` (Seleção de Time)
*   `#screen-career-ct` (Centro de Treinamento)
*   `#screen-career-match` (Nova - Tela de Simulação da Rodada)
*   `#screen-career-event` (Nova - Overlay/Modal para Dilemas Narrativos)

A função global `showScreen(screenId)` do `app.js` continuará sendo usada para transicionar entre as telas de Carreira e o Lobby, ocultando completamente o ecossistema do Draft quando a Carreira estiver ativa e vice-versa.

---
*Proposta elaborada em 10 de Julho de 2026.*
*Alinhada com as diretrizes do AGENTS.md da MaxxSystem.*
