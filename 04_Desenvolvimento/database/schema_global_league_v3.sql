-- ============================================================================
-- THE GLOBAL LEAGUE (CHAMPIONS 7-0 v3.0) — CANONICAL DATABASE SCHEMA
-- ============================================================================
-- Architecture: Supabase / PostgreSQL (SaaS Factory Standard Ecosystem)
-- Objective: Maintain 80 clubs (Série A, B, C, D) dynamically synced via API-Football
-- Features: Active Contract Integrity Protocol + Full Player & Coach Career History
-- Last Updated: Julho de 2026 (GETDATE() Audit Protocol)
-- ============================================================================

-- Enable UUID extension if not enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ----------------------------------------------------------------------------
-- 1. TEAMS TABLE (Clubes das 4 Divisões do Brasileirão 2026)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.teams (
    id BIGINT PRIMARY KEY, -- ID oficial canônico (API-Football / CBF BID, ex: 101, 102, 20002)
    name VARCHAR(150) NOT NULL,
    short_name VARCHAR(50) NOT NULL,
    badge_url TEXT NOT NULL,
    stadium_name VARCHAR(150) NOT NULL,
    stadium_capacity INTEGER NOT NULL,
    city VARCHAR(100) NOT NULL,
    state CHAR(2) NOT NULL,
    division INTEGER NOT NULL CHECK (division IN (1, 2, 3, 4)), -- 1: Série A, 2: Série B, etc.
    overall_rating INTEGER DEFAULT 75,
    attack_rating INTEGER DEFAULT 75,
    midfield_rating INTEGER DEFAULT 75,
    defense_rating INTEGER DEFAULT 75,
    goalkeeper_rating INTEGER DEFAULT 75,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- 2. COACHES TABLE (Técnicos Ativos e Histórico de Comando)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.coaches (
    id BIGSERIAL PRIMARY KEY,
    api_coach_id BIGINT UNIQUE, -- ID do técnico na API-Football
    name VARCHAR(150) NOT NULL,
    nationality VARCHAR(80) DEFAULT 'Brazil',
    team_id BIGINT REFERENCES public.teams(id) ON DELETE SET NULL,
    hired_date DATE NOT NULL DEFAULT CURRENT_DATE,
    contract_until DATE,
    is_active BOOLEAN DEFAULT TRUE, -- TRUE apenas para o técnico atual de Julho/2026
    tactical_style VARCHAR(80) DEFAULT 'Posicional Ofensivo',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Index para busca rápida do técnico ativo de cada time
CREATE INDEX IF NOT EXISTS idx_coaches_active_team ON public.coaches(team_id) WHERE is_active = TRUE;

-- ----------------------------------------------------------------------------
-- 3. PLAYERS TABLE (Plantel Ativo Inscrito — Julho 2026)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.players (
    id BIGSERIAL PRIMARY KEY,
    api_player_id BIGINT UNIQUE, -- ID canônico na API-Football / CBF
    name VARCHAR(150) NOT NULL,
    known_name VARCHAR(100) NOT NULL,
    position CHAR(2) NOT NULL CHECK (position IN ('GK', 'DF', 'MF', 'FW')),
    specific_role VARCHAR(50), -- Ex: 'Zagueiro', 'Volante', 'Ponta Direita', 'Centroavante'
    team_id BIGINT REFERENCES public.teams(id) ON DELETE SET NULL,
    jersey_number INTEGER,
    age INTEGER NOT NULL DEFAULT 25,
    nationality VARCHAR(80) DEFAULT 'Brazil',
    overall_rating INTEGER NOT NULL DEFAULT 75,
    potential_rating INTEGER NOT NULL DEFAULT 80,
    market_value_eur BIGINT DEFAULT 1000000,
    contract_status VARCHAR(30) DEFAULT 'ACTIVE' CHECK (contract_status IN ('ACTIVE', 'LOANED_OUT', 'TRANSFERRED_OUT', 'FREE_AGENT')),
    joined_date DATE DEFAULT CURRENT_DATE,
    last_synced_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Index para rápida extração do elenco de um time na rodada/início da jornada
CREATE INDEX IF NOT EXISTS idx_players_team_active ON public.players(team_id, position) WHERE contract_status = 'ACTIVE';

-- ----------------------------------------------------------------------------
-- 4. PLAYER CAREER HISTORY TABLE (Auditoria de Carreira e Linha do Tempo)
-- ----------------------------------------------------------------------------
-- Guarda o histórico imutável de cada jogador (transferências, empréstimos, evolução)
CREATE TABLE IF NOT EXISTS public.player_career_history (
    id BIGSERIAL PRIMARY KEY,
    player_id BIGINT NOT NULL REFERENCES public.players(id) ON DELETE CASCADE,
    season VARCHAR(10) NOT NULL, -- Ex: '2024', '2025', '2026'
    previous_team_id BIGINT REFERENCES public.teams(id) ON DELETE SET NULL,
    new_team_id BIGINT REFERENCES public.teams(id) ON DELETE SET NULL,
    previous_team_name VARCHAR(150), -- Backup textual em caso de clube externo/internacional
    new_team_name VARCHAR(150),
    event_type VARCHAR(50) NOT NULL CHECK (event_type IN ('INITIAL_REGISTRATION', 'TRANSFER_IN', 'TRANSFER_OUT', 'LOAN_IN', 'LOAN_OUT', 'CONTRACT_RENEWAL', 'OVR_EVOLUTION')),
    event_date DATE NOT NULL DEFAULT CURRENT_DATE,
    transfer_fee_eur BIGINT DEFAULT 0,
    appearances_in_season INTEGER DEFAULT 0,
    goals_in_season INTEGER DEFAULT 0,
    assists_in_season INTEGER DEFAULT 0,
    average_rating NUMERIC(4,2) DEFAULT 7.00,
    overall_before INTEGER,
    overall_after INTEGER,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Index para busca ultra-rápida do histórico no perfil do atleta
CREATE INDEX IF NOT EXISTS idx_player_career_history_player ON public.player_career_history(player_id, event_date DESC);

-- ----------------------------------------------------------------------------
-- 5. API SYNC AUDIT LOGS (Trilha de Auditoria - Sincronização Dinâmica)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.api_sync_audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sync_trigger VARCHAR(50) NOT NULL, -- Ex: 'NEW_USER_REGISTRATION', 'CAREER_JOURNEY_START', 'CRON_DAILY'
    user_id VARCHAR(100), -- ID do usuário que iniciou a jornada ou admin
    target_division INTEGER,
    teams_synced_count INTEGER DEFAULT 0,
    players_updated_count INTEGER DEFAULT 0,
    transfers_detected_count INTEGER DEFAULT 0,
    status VARCHAR(30) NOT NULL CHECK (status IN ('SUCCESS', 'PARTIAL', 'FAILED')),
    execution_time_ms INTEGER NOT NULL,
    error_details TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- 6. STORED PROCEDURE: RECORD TRANSFER & UPDATE HISTORY
-- ----------------------------------------------------------------------------
-- Função automática que registra o histórico sempre que o jogador muda de time ou overall
CREATE OR REPLACE FUNCTION public.fn_log_player_career_change()
RETURNS TRIGGER AS $$
BEGIN
    -- Se houve mudança de time (transferência real)
    IF (OLD.team_id IS DISTINCT FROM NEW.team_id) THEN
        INSERT INTO public.player_career_history (
            player_id,
            season,
            previous_team_id,
            new_team_id,
            event_type,
            event_date,
            overall_before,
            overall_after,
            notes
        ) VALUES (
            NEW.id,
            '2026',
            OLD.team_id,
            NEW.team_id,
            CASE WHEN NEW.team_id IS NULL THEN 'TRANSFER_OUT' ELSE 'TRANSFER_IN' END,
            CURRENT_DATE,
            OLD.overall_rating,
            NEW.overall_rating,
            'Sincronização Dinâmica via API-Football / CBF BID'
        );
    -- Se houve apenas evolução de OVR
    ELSIF (OLD.overall_rating IS DISTINCT FROM NEW.overall_rating) THEN
        INSERT INTO public.player_career_history (
            player_id,
            season,
            previous_team_id,
            new_team_id,
            event_type,
            event_date,
            overall_before,
            overall_after,
            notes
        ) VALUES (
            NEW.id,
            '2026',
            NEW.team_id,
            NEW.team_id,
            'OVR_EVOLUTION',
            CURRENT_DATE,
            OLD.overall_rating,
            NEW.overall_rating,
            'Evolução de desempenho/OVR detectada no início de jornada'
        );
    END IF;
    
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger atrelada à tabela players
DROP TRIGGER IF EXISTS trg_player_career_update ON public.players;
CREATE TRIGGER trg_player_career_update
    AFTER UPDATE ON public.players
    FOR EACH ROW
    EXECUTE FUNCTION public.fn_log_player_career_change();

-- ============================================================================
-- FINAL OF SCHEMA EXPORT
-- ============================================================================
