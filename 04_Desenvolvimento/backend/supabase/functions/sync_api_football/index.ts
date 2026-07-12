// ============================================================================
// THE GLOBAL LEAGUE (CHAMPIONS 7-0 v3.0) — SUPABASE EDGE FUNCTION
// ============================================================================
// Function Name: sync_api_football
// Canonical Path: supabase/functions/sync_api_football/index.ts
// Objective: Dynamic integrity motor triggered on new user signup or career start
// Features: Validates active coaches & squads, removes transfer-outs, and records player history
// ============================================================================

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";

const API_FOOTBALL_KEY = Deno.env.get("API_FOOTBALL_KEY") || "YOUR_RAPIDAPI_KEY";
const SUPABASE_URL = Deno.env.get("SUPABASE_URL") || "";
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") || "";

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

interface SyncRequestPayload {
  teamIds?: number[]; // Lista de IDs canônicos da CBF/API para atualizar (ex: [101, 102, 103, 104])
  syncTrigger: "NEW_USER_REGISTRATION" | "CAREER_JOURNEY_START" | "CRON_DAILY";
  userId?: string;
  season?: number; // Default: 2026
}

serve(async (req: Request) => {
  const startTime = Date.now();
  let status: "SUCCESS" | "PARTIAL" | "FAILED" = "SUCCESS";
  let errorDetails = "";
  let teamsSyncedCount = 0;
  let playersUpdatedCount = 0;
  let transfersDetectedCount = 0;

  try {
    if (req.method !== "POST") {
      return new Response(JSON.stringify({ error: "Method not allowed" }), { status: 405 });
    }

    const payload: SyncRequestPayload = await req.json();
    const season = payload.season || 2026;
    const teamIds = payload.teamIds || [101, 102, 103, 104, 105, 106, 107, 108]; // Série A default se não passado

    console.log(`[SYNC-MOTOR] Iniciando verificação dinâmica para temporada ${season}. Gatilho: ${payload.syncTrigger}`);

    for (const teamId of teamIds) {
      // ------------------------------------------------------------------------
      // 1. CHECAR TÉCNICO ATIVO DA TEMPORADA (GET /coachs)
      // ------------------------------------------------------------------------
      const coachResponse = await fetch(`https://v3.football.api-sports.io/coachs?team=${teamId}`, {
        headers: {
          "x-rapidapi-host": "v3.football.api-sports.io",
          "x-rapidapi-key": API_FOOTBALL_KEY
        }
      });

      if (coachResponse.ok) {
        const coachData = await coachResponse.json();
        const activeCoach = (coachData.response || []).find((c: any) => c.career && c.career.some((car: any) => car.team.id === teamId && car.end === null));
        
        if (activeCoach) {
          await supabase.from("coaches").update({ is_active: false }).eq("team_id", teamId);
          await supabase.from("coaches").upsert({
            api_coach_id: activeCoach.id,
            name: activeCoach.name,
            nationality: activeCoach.nationality || "Brazil",
            team_id: teamId,
            is_active: true,
            updated_at: new Date().toISOString()
          }, { onConflict: "api_coach_id" });
        }
      }

      // ------------------------------------------------------------------------
      // 2. CHECAR TRANSFERÊNCIAS DE SAÍDA (GET /transfers — Peneira Tripla)
      // ------------------------------------------------------------------------
      const transfersResponse = await fetch(`https://v3.football.api-sports.io/transfers?team=${teamId}`, {
        headers: {
          "x-rapidapi-host": "v3.football.api-sports.io",
          "x-rapidapi-key": API_FOOTBALL_KEY
        }
      });

      const transferredOutPlayerIds = new Set<number>();
      if (transfersResponse.ok) {
        const transfersData = await transfersResponse.json();
        for (const t of transfersData.response || []) {
          for (const mov of t.transfers || []) {
            if (mov.date && mov.date.startsWith("2026") && mov.teams && mov.teams.out && mov.teams.out.id === teamId) {
              transferredOutPlayerIds.add(t.player.id);
              transfersDetectedCount++;
            }
          }
        }
      }

      // ------------------------------------------------------------------------
      // 3. CHECAR PLANTEL E ALOCAR JOGADORES ATIVOS (GET /players/squads)
      // ------------------------------------------------------------------------
      const squadResponse = await fetch(`https://v3.football.api-sports.io/players/squads?team=${teamId}`, {
        headers: {
          "x-rapidapi-host": "v3.football.api-sports.io",
          "x-rapidapi-key": API_FOOTBALL_KEY
        }
      });

      if (squadResponse.ok) {
        const squadData = await squadResponse.json();
        const playersList = squadData.response?.[0]?.players || [];

        for (const player of playersList) {
          if (transferredOutPlayerIds.has(player.id)) {
            await supabase.from("players").update({
              contract_status: "TRANSFERRED_OUT",
              team_id: null,
              updated_at: new Date().toISOString()
            }).eq("api_player_id", player.id);
            continue;
          }

          const posMap: Record<string, string> = {
            "Goalkeeper": "GK",
            "Defender": "DF",
            "Midfielder": "MF",
            "Attacker": "FW"
          };
          const mappedPos = posMap[player.position] || "MF";

          const { data: upsertedPlayer } = await supabase.from("players").upsert({
            api_player_id: player.id,
            name: player.name,
            known_name: player.name,
            position: mappedPos,
            team_id: teamId,
            jersey_number: player.number || null,
            age: player.age || 25,
            contract_status: "ACTIVE",
            last_synced_at: new Date().toISOString(),
            updated_at: new Date().toISOString()
          }, { onConflict: "api_player_id" }).select("id").single();

          if (upsertedPlayer) {
            playersUpdatedCount++;
          }
        }
        teamsSyncedCount++;
      }
    }

    await supabase.from("api_sync_audit_logs").insert({
      sync_trigger: payload.syncTrigger,
      user_id: payload.userId || "system",
      teams_synced_count: teamsSyncedCount,
      players_updated_count: playersUpdatedCount,
      transfers_detected_count: transfersDetectedCount,
      status: status,
      execution_time_ms: Date.now() - startTime
    });

    return new Response(JSON.stringify({
      success: true,
      message: `Sincronização dinâmica concluída com sucesso para ${teamsSyncedCount} times.`,
      stats: {
        teamsSynced: teamsSyncedCount,
        playersUpdated: playersUpdatedCount,
        transfersDetected: transfersDetectedCount,
        executionTimeMs: Date.now() - startTime
      }
    }), { status: 200, headers: { "Content-Type": "application/json" } });

  } catch (error: any) {
    status = "FAILED";
    errorDetails = error.message || String(error);
    console.error("[SYNC-MOTOR-ERROR]", errorDetails);

    return new Response(JSON.stringify({
      success: false,
      error: errorDetails
    }), { status: 500, headers: { "Content-Type": "application/json" } });
  }
});
