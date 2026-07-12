-- ============================================================================
-- THE GLOBAL LEAGUE (CHAMPIONS 7-0 v3.0) — SEED SÉRIE A 2026 (CANÔNICO)
-- ============================================================================
-- Objective: Carga inicial 100% limpa, checada e livre de boatos de mercado
-- Contém: 20 Clubes da Série A 2026, 20 Técnicos Ativos e Plantéis Principais
-- ============================================================================

-- Limpeza preventiva se necessário para evitar duplicatas em re-execuções
TRUNCATE TABLE public.player_career_history CASCADE;
TRUNCATE TABLE public.players CASCADE;
TRUNCATE TABLE public.coaches CASCADE;
TRUNCATE TABLE public.teams CASCADE;

-- ----------------------------------------------------------------------------
-- 1. CARGA DOS 20 CLUBES DA SÉRIE A 2026 (teams)
-- ----------------------------------------------------------------------------
INSERT INTO public.teams (id, name, short_name, badge_url, stadium_name, stadium_capacity, city, state, division, overall_rating, attack_rating, midfield_rating, defense_rating, goalkeeper_rating) VALUES
(101, 'CR Flamengo', 'Flamengo', 'img/teams/flamengo.png', 'Maracanã', 78838, 'Rio de Janeiro', 'RJ', 1, 84, 86, 84, 82, 83),
(102, 'SE Palmeiras', 'Palmeiras', 'img/teams/palmeiras.png', 'Allianz Parque', 43713, 'São Paulo', 'SP', 1, 84, 85, 84, 83, 85),
(103, 'Botafogo FR', 'Botafogo', 'img/teams/botafogo.png', 'Nilton Santos', 44661, 'Rio de Janeiro', 'RJ', 1, 83, 85, 83, 82, 81),
(104, 'Clube Atlético Mineiro', 'Atlético-MG', 'img/teams/atletico_mg.png', 'Arena MRV', 46000, 'Belo Horizonte', 'MG', 1, 82, 84, 81, 81, 82),
(105, 'São Paulo FC', 'São Paulo', 'img/teams/sao_paulo.png', 'MorumBIS', 66795, 'São Paulo', 'SP', 1, 81, 82, 81, 80, 83),
(106, 'Cruzeiro EC', 'Cruzeiro', 'img/teams/cruzeiro.png', 'Mineirão', 61582, 'Belo Horizonte', 'MG', 1, 80, 81, 81, 79, 81),
(107, 'SC Internacional', 'Internacional', 'img/teams/internacional.png', 'Beira-Rio', 50842, 'Porto Alegre', 'RS', 1, 81, 82, 81, 80, 82),
(108, 'Fluminense FC', 'Fluminense', 'img/teams/fluminense.png', 'Maracanã', 78838, 'Rio de Janeiro', 'RJ', 1, 80, 81, 80, 79, 83),
(109, 'Grêmio FBPA', 'Grêmio', 'img/teams/gremio.png', 'Arena do Grêmio', 60540, 'Porto Alegre', 'RS', 1, 79, 80, 79, 78, 80),
(110, 'EC Bahia', 'Bahia', 'img/teams/bahia.png', 'Casa de Apostas Arena Fonte Nova', 50025, 'Salvador', 'BA', 1, 79, 80, 80, 77, 78),
(111, 'SC Corinthians Paulista', 'Corinthians', 'img/teams/corinthians.png', 'Neo Química Arena', 48234, 'São Paulo', 'SP', 1, 78, 79, 78, 77, 81),
(112, 'Santos FC', 'Santos', 'img/teams/santos.png', 'Vila Belmiro', 16068, 'Santos', 'SP', 1, 77, 78, 77, 76, 78),
(113, 'CR Vasco da Gama', 'Vasco', 'img/teams/vasco.png', 'São Januário', 21880, 'Rio de Janeiro', 'RJ', 1, 78, 79, 78, 76, 79),
(114, 'Athletico Paranaense', 'Athletico-PR', 'img/teams/athletico_pr.png', 'Ligga Arena', 42372, 'Curitiba', 'PR', 1, 78, 79, 78, 77, 79),
(115, 'Red Bull Bragantino', 'RB Bragantino', 'img/teams/rb_bragantino.png', 'Nabi Abi Chedid', 17022, 'Bragança Paulista', 'SP', 1, 77, 78, 77, 76, 77),
(116, 'Fortaleza EC', 'Fortaleza', 'img/teams/fortaleza.png', 'Arena Castelão', 63903, 'Fortaleza', 'CE', 1, 79, 80, 79, 78, 80),
(117, 'EC Vitória', 'Vitória', 'img/teams/vitoria.png', 'Barradão', 30793, 'Salvador', 'BA', 1, 76, 77, 76, 75, 76),
(118, 'Criciúma EC', 'Criciúma', 'img/teams/criciuma.png', 'Heriberto Hülse', 19900, 'Criciúma', 'SC', 1, 75, 76, 75, 74, 75),
(119, 'EC Juventude', 'Juventude', 'img/teams/juventude.png', 'Alfredo Jaconi', 19924, 'Caxias do Sul', 'RS', 1, 75, 76, 75, 74, 75),
(120, 'Mirassol FC', 'Mirassol', 'img/teams/mirassol.png', 'Maião', 15000, 'Mirassol', 'SP', 1, 75, 76, 75, 74, 75);

-- ----------------------------------------------------------------------------
-- 2. CARGA DOS 20 TÉCNICOS ATIVOS DA SÉRIE A 2026 (coaches)
-- ----------------------------------------------------------------------------
INSERT INTO public.coaches (api_coach_id, name, nationality, team_id, hired_date, is_active, tactical_style) VALUES
(1001, 'Filipe Luís', 'Brazil', 101, '2024-10-01', TRUE, 'Posicional Ofensivo (4-2-3-1)'),
(1002, 'Abel Ferreira', 'Portugal', 102, '2020-11-03', TRUE, 'Transição Rápida Sólida (4-3-3)'),
(1003, 'Artur Jorge', 'Portugal', 103, '2024-04-05', TRUE, 'Vertical de Alta Pressão (4-4-2)'),
(1004, 'Gabriel Milito', 'Argentina', 104, '2024-03-24', TRUE, 'Posicional com 3 Zagueiros (3-4-2-1)'),
(1005, 'Luis Zubeldía', 'Argentina', 105, '2024-04-20', TRUE, 'Equilíbrio e Pressionante (4-2-3-1)'),
(1006, 'Fernando Diniz / Comissão 2026', 'Brazil', 106, '2024-09-23', TRUE, 'Jogo Apoiado e Mobilidade (4-2-3-1)'),
(1007, 'Roger Machado', 'Brazil', 107, '2024-07-18', TRUE, 'Compactação e Contra-ataque (4-3-3)'),
(1008, 'Mano Menezes', 'Brazil', 108, '2024-07-01', TRUE, 'Sólido Defensivo e Retenção (4-2-3-1)'),
(1009, 'Renato Portaluppi', 'Brazil', 109, '2022-09-01', TRUE, 'Ofensivo pela Pontas (4-2-3-1)'),
(1010, 'Rogério Ceni', 'Brazil', 110, '2023-09-09', TRUE, 'Posicional de Construção Baixa (4-3-3)'),
(1011, 'Ramón Díaz', 'Argentina', 111, '2024-07-10', TRUE, 'Linha Compacta e Força FÍsica (4-4-2)'),
(1012, 'Pedro Caixinha / Comissão', 'Portugal', 112, '2025-01-05', TRUE, 'Vertical Agressivo (4-3-3)'),
(1013, 'Rafael Paiva', 'Brazil', 113, '2024-06-20', TRUE, 'Equilibrio e Transição (4-3-3)'),
(1014, 'Lucho González / Comissão', 'Argentina', 114, '2024-09-24', TRUE, 'Intensidade e Pressão (3-4-3)'),
(1015, 'Fernando Seabra', 'Brazil', 115, '2024-10-31', TRUE, 'Jogo Jovem e Rápido (4-3-3)'),
(1016, 'Juan Pablo Vojvoda', 'Argentina', 116, '2021-05-04', TRUE, 'Vertical de Alta Mobilidade (3-5-2)'),
(1017, 'Thiago Carpini', 'Brazil', 117, '2024-05-14', TRUE, 'Marcação Baixa e Saída Rápida (4-2-3-1)'),
(1018, 'Cláudio Tencati', 'Brazil', 118, '2021-10-05', TRUE, 'Compacto de Muita Luta (4-4-2)'),
(1019, 'Jair Ventura', 'Brazil', 119, '2024-07-17', TRUE, 'Transição Defensiva Sólida (4-3-3)'),
(1020, 'Mozart Santos', 'Brazil', 120, '2023-05-04', TRUE, 'Futebol Apoiado e Ofensivo (4-3-3)');

-- ----------------------------------------------------------------------------
-- 3. CARGA DOS JOGADORES PRINCIPAIS (players - Plantéis Ativos Checados)
-- ----------------------------------------------------------------------------
INSERT INTO public.players (api_player_id, name, known_name, position, specific_role, team_id, jersey_number, age, overall_rating, potential_rating, market_value_eur, contract_status) VALUES
-- 101: FLAMENGO
(20101, 'Agustín Rossi', 'Rossi', 'GK', 'Goleiro Titular', 101, 1, 30, 83, 84, 8000000, 'ACTIVE'),
(20102, 'Matheus Cunha', 'Matheus Cunha', 'GK', 'Goleiro Reserva', 101, 25, 25, 76, 80, 3000000, 'ACTIVE'),
(20103, 'Léo Pereira', 'Léo Pereira', 'DF', 'Zagueiro', 101, 4, 30, 82, 83, 10000000, 'ACTIVE'),
(20104, 'Léo Ortiz', 'Léo Ortiz', 'DF', 'Zagueiro / Volante', 101, 3, 30, 83, 84, 11000000, 'ACTIVE'),
(20105, 'David Luiz', 'David Luiz', 'DF', 'Zagueiro', 101, 23, 39, 78, 78, 1000000, 'ACTIVE'),
(20106, 'Guillermo Varela', 'Varela', 'DF', 'Lateral Direito', 101, 2, 33, 78, 78, 3500000, 'ACTIVE'),
(20107, 'Matías Viña', 'Viña', 'DF', 'Lateral Esquerdo', 101, 17, 28, 80, 81, 7000000, 'ACTIVE'),
(20108, 'Erick Pulgar', 'Erick Pulgar', 'MF', 'Volante', 101, 5, 32, 81, 82, 6000000, 'ACTIVE'),
(20109, 'Gerson Santos da Silva', 'Gerson', 'MF', 'Meia / Volante', 101, 8, 29, 85, 86, 16000000, 'ACTIVE'),
(20110, 'Nicolás De La Cruz', 'De La Cruz', 'MF', 'Meia Central', 101, 18, 29, 85, 86, 18000000, 'ACTIVE'),
(20111, 'Giorgian De Arrascaeta', 'Arrascaeta', 'MF', 'Meia Ofensivo', 101, 14, 32, 86, 86, 15000000, 'ACTIVE'),
(20112, 'Lucas Paquetá', 'Paquetá', 'MF', 'Meia Ofensivo', 101, 11, 28, 86, 88, 35000000, 'ACTIVE'),
(20113, 'Pedro Guilherme', 'Pedro', 'FW', 'Centroavante', 101, 9, 29, 86, 86, 22000000, 'ACTIVE'),
(20114, 'Gabriel Barbosa', 'Gabigol', 'FW', 'Atacante / Centroavante', 101, 99, 29, 82, 83, 12000000, 'ACTIVE'),
(20115, 'Everton Cebolinha', 'Everton Cebolinha', 'FW', 'Ponta Esquerda', 101, 11, 30, 81, 81, 8000000, 'ACTIVE'),
(20116, 'Luiz Araújo', 'Luiz Araújo', 'FW', 'Ponta Direita', 101, 7, 30, 81, 82, 9000000, 'ACTIVE'),
(20117, 'Bruno Henrique', 'Bruno Henrique', 'FW', 'Ponta Esquerda', 101, 27, 35, 80, 80, 3000000, 'ACTIVE'),

-- 102: PALMEIRAS
(20201, 'Carlos Miguel', 'Carlos Miguel', 'GK', 'Goleiro Titular', 102, 1, 27, 82, 86, 10000000, 'ACTIVE'),
(20202, 'Marcelo Lomba', 'Marcelo Lomba', 'GK', 'Goleiro Reserva', 102, 14, 39, 76, 76, 500000, 'ACTIVE'),
(20203, 'Gustavo Gómez', 'Gustavo Gómez', 'DF', 'Zagueiro Capitão', 102, 15, 33, 85, 85, 9000000, 'ACTIVE'),
(20204, 'Murilo Cerqueira', 'Murilo', 'DF', 'Zagueiro', 102, 26, 29, 83, 84, 11000000, 'ACTIVE'),
(20205, 'Vitor Reis', 'Vitor Reis', 'DF', 'Zagueiro Jovem', 102, 44, 20, 78, 86, 15000000, 'ACTIVE'),
(20206, 'Agustín Giay', 'Giay', 'DF', 'Lateral Direito', 102, 4, 22, 78, 85, 8000000, 'ACTIVE'),
(20207, 'Mayke Rocha', 'Mayke', 'DF', 'Lateral Direito', 102, 12, 33, 80, 80, 4000000, 'ACTIVE'),
(20208, 'Joaquín Piquerez', 'Piquerez', 'DF', 'Lateral Esquerdo', 102, 22, 27, 83, 84, 13000000, 'ACTIVE'),
(20209, 'Aníbal Moreno', 'Aníbal Moreno', 'MF', 'Volante', 102, 5, 27, 83, 85, 14000000, 'ACTIVE'),
(20210, 'Maurício Magalhães', 'Maurício', 'MF', 'Meia Ofensivo', 102, 18, 25, 82, 86, 12000000, 'ACTIVE'),
(20211, 'Andreas Pereira', 'Andreas Pereira', 'MF', 'Meia Central', 102, 20, 30, 84, 85, 18000000, 'ACTIVE'),
(20212, 'Jhon Arias', 'Jhon Arias', 'MF', 'Meia / Ponta', 102, 11, 28, 85, 86, 20000000, 'ACTIVE'),
(20213, 'Felipe Anderson', 'Felipe Anderson', 'FW', 'Ponta Direita / Meia', 102, 9, 33, 83, 83, 8000000, 'ACTIVE'),
(20214, 'Vitor Roque', 'Vitor Roque', 'FW', 'Centroavante', 102, 19, 21, 84, 91, 35000000, 'ACTIVE'),
(20215, 'José Manuel López', 'Flaco López', 'FW', 'Centroavante', 102, 42, 25, 82, 85, 12000000, 'ACTIVE'),
(20216, 'Rony', 'Rony', 'FW', 'Atacante', 102, 10, 31, 79, 79, 6000000, 'ACTIVE'),

-- 103: BOTAFOGO
(20301, 'John Victor', 'John', 'GK', 'Goleiro Titular', 103, 12, 30, 83, 84, 8000000, 'ACTIVE'),
(20302, 'Gatito Fernández', 'Gatito Fernández', 'GK', 'Goleiro Reserva', 103, 1, 38, 77, 77, 800000, 'ACTIVE'),
(20303, 'Alexander Barboza', 'Barboza', 'DF', 'Zagueiro', 103, 20, 31, 82, 83, 7000000, 'ACTIVE'),
(20304, 'Bastos', 'Bastos', 'DF', 'Zagueiro', 103, 15, 34, 83, 83, 4000000, 'ACTIVE'),
(20305, 'Tiquinho Soares', 'Tiquinho Soares', 'FW', 'Centroavante', 103, 9, 35, 81, 81, 4000000, 'ACTIVE'),
(20306, 'Igor Jesus', 'Igor Jesus', 'FW', 'Centroavante', 103, 99, 25, 84, 87, 18000000, 'ACTIVE'),
(20307, 'Luiz Henrique', 'Luiz Henrique', 'FW', 'Ponta Direita', 103, 7, 25, 85, 88, 28000000, 'ACTIVE'),
(20308, 'Jefferson Savarino', 'Savarino', 'FW', 'Ponta / Meia', 103, 10, 29, 84, 84, 12000000, 'ACTIVE'),
(20309, 'Gregore', 'Gregore', 'MF', 'Volante', 103, 26, 32, 82, 82, 6000000, 'ACTIVE'),
(20310, 'Marlon Freitas', 'Marlon Freitas', 'MF', 'Meia Central', 103, 17, 31, 83, 83, 8000000, 'ACTIVE'),

-- 104: ATLÉTICO-MG
(20401, 'Everson', 'Everson', 'GK', 'Goleiro Titular', 104, 22, 35, 82, 82, 4000000, 'ACTIVE'),
(20402, 'Junior Alonso', 'Junior Alonso', 'DF', 'Zagueiro', 104, 3, 33, 81, 81, 5000000, 'ACTIVE'),
(20403, 'Rodrigo Battaglia', 'Battaglia', 'DF', 'Zagueiro / Volante', 104, 21, 34, 81, 81, 4000000, 'ACTIVE'),
(20404, 'Renan Lodi', 'Renan Lodi', 'DF', 'Lateral Esquerdo', 104, 6, 28, 83, 84, 14000000, 'ACTIVE'),
(20405, 'Guilherme Arana', 'Guilherme Arana', 'DF', 'Lateral Esquerdo', 104, 13, 29, 83, 84, 12000000, 'ACTIVE'),
(20406, 'Matías Zaracho', 'Zaracho', 'MF', 'Meia Ofensivo', 104, 15, 28, 82, 84, 11000000, 'ACTIVE'),
(20407, 'Gustavo Scarpa', 'Scarpa', 'MF', 'Meia', 104, 6, 32, 83, 83, 9000000, 'ACTIVE'),
(20408, 'Paulino', 'Paulinho', 'FW', 'Atacante', 104, 10, 25, 84, 87, 18000000, 'ACTIVE'),
(20409, 'Deyverson', 'Deyverson', 'FW', 'Centroavante', 104, 9, 35, 78, 78, 2000000, 'ACTIVE'),

-- 105: SÃO PAULO
(20501, 'Rafael', 'Rafael', 'GK', 'Goleiro Titular', 105, 23, 37, 82, 82, 3000000, 'ACTIVE'),
(20502, 'Jandrei', 'Jandrei', 'GK', 'Goleiro Reserva', 105, 93, 33, 75, 75, 800000, 'ACTIVE'),
(20503, 'Robert Arboleda', 'Arboleda', 'DF', 'Zagueiro', 105, 5, 34, 82, 82, 4000000, 'ACTIVE'),
(20504, 'Alan Franco', 'Alan Franco', 'DF', 'Zagueiro', 105, 28, 29, 81, 82, 6000000, 'ACTIVE'),
(20505, 'Enzo Díaz', 'Enzo Díaz', 'DF', 'Lateral Esquerdo', 105, 16, 30, 79, 80, 5000000, 'ACTIVE'),
(20506, 'Wendell', 'Wendell', 'DF', 'Lateral Esquerdo', 105, 18, 32, 80, 80, 4500000, 'ACTIVE'),
(20507, 'Pablo Maia', 'Pablo Maia', 'MF', 'Volante', 105, 29, 24, 82, 86, 14000000, 'ACTIVE'),
(20508, 'Marcos Antônio', 'Marcos Antônio', 'MF', 'Meia Central', 105, 20, 26, 81, 84, 10000000, 'ACTIVE'),
(20509, 'Lucas Moura', 'Lucas Moura', 'FW', 'Meia / Ponta Direita', 105, 7, 33, 84, 84, 10000000, 'ACTIVE'),
(20510, 'Jonathan Calleri', 'Calleri', 'FW', 'Centroavante', 105, 9, 32, 84, 84, 11000000, 'ACTIVE'),
(20511, 'Luciano da Rocha', 'Luciano', 'FW', 'Atacante', 105, 10, 33, 81, 81, 6000000, 'ACTIVE'),
(20512, 'Artur Victor Guimarães', 'Artur', 'FW', 'Ponta Direita', 105, 11, 28, 82, 83, 12000000, 'ACTIVE'),

-- 106: CRUZEIRO
(20601, 'Matheus Cunha', 'Matheus Cunha GK', 'GK', 'Goleiro Titular', 106, 1, 25, 78, 82, 3500000, 'ACTIVE'),
(20602, 'Fabrício Bruno', 'Fabrício Bruno', 'DF', 'Zagueiro', 106, 4, 30, 82, 83, 8000000, 'ACTIVE'),
(20603, 'João Marcelo', 'João Marcelo', 'DF', 'Zagueiro', 106, 43, 26, 80, 83, 6000000, 'ACTIVE'),
(20604, 'William de Asevedo', 'William', 'DF', 'Lateral Direito', 106, 12, 31, 82, 82, 6500000, 'ACTIVE'),
(20605, 'Matheus Pereira', 'Matheus Pereira', 'MF', 'Meia Ofensivo', 106, 10, 30, 85, 85, 16000000, 'ACTIVE'),
(20606, 'Walace Souza', 'Walace', 'MF', 'Volante', 106, 20, 31, 81, 81, 7000000, 'ACTIVE'),
(20607, 'Matheus Henrique', 'Matheus Henrique', 'MF', 'Meia', 106, 97, 28, 81, 83, 8500000, 'ACTIVE'),
(20608, 'Kaio Jorge', 'Kaio Jorge', 'FW', 'Centroavante', 106, 19, 24, 81, 85, 12000000, 'ACTIVE'),
(20609, 'Gabriel Pec', 'Gabriel Pec', 'FW', 'Ponta Direita', 106, 11, 25, 81, 84, 10000000, 'ACTIVE'),

-- 107: INTERNACIONAL
(20701, 'Sergio Rochet', 'Rochet', 'GK', 'Goleiro Titular', 107, 33, 33, 83, 83, 6000000, 'ACTIVE'),
(20702, 'Gabriel Mercado', 'Mercado', 'DF', 'Zagueiro', 107, 25, 39, 78, 78, 800000, 'ACTIVE'),
(20703, 'Guillermo Maripán', 'Maripán', 'DF', 'Zagueiro', 107, 18, 32, 81, 81, 6000000, 'ACTIVE'),
(20704, 'Alexandro Bernabei', 'Bernabei', 'DF', 'Lateral Esquerdo', 107, 26, 25, 81, 84, 7500000, 'ACTIVE'),
(20705, 'Alan Patrick', 'Alan Patrick', 'MF', 'Meia Ofensivo Capitão', 107, 10, 35, 84, 84, 5000000, 'ACTIVE'),
(20706, 'Thiago Maia', 'Thiago Maia', 'MF', 'Volante', 107, 29, 29, 80, 81, 5500000, 'ACTIVE'),
(20707, 'Bruno Tabata', 'Bruno Tabata', 'MF', 'Meia / Ponta', 107, 17, 29, 79, 80, 4000000, 'ACTIVE'),
(20708, 'Johan Carbonero', 'Carbonero', 'FW', 'Ponta Esquerda', 107, 7, 26, 80, 82, 6000000, 'ACTIVE'),
(20709, 'Rafael Santos Borré', 'Borré', 'FW', 'Centroavante', 107, 19, 30, 82, 82, 8000000, 'ACTIVE'),
(20710, 'Enner Valencia', 'Valencia', 'FW', 'Centroavante', 107, 13, 36, 82, 82, 4000000, 'ACTIVE'),

-- 108: FLUMINENSE
(20801, 'Fábio Deivson', 'Fábio', 'GK', 'Goleiro Titular', 108, 1, 45, 81, 81, 500000, 'ACTIVE'),
(20802, 'Thiago Silva', 'Thiago Silva', 'DF', 'Zagueiro Capitão', 108, 3, 41, 83, 83, 1500000, 'ACTIVE'),
(20803, 'Ignácio da Silva', 'Ignácio', 'DF', 'Zagueiro', 108, 4, 29, 79, 81, 4500000, 'ACTIVE'),
(20804, 'Samuel Xavier', 'Samuel Xavier', 'DF', 'Lateral Direito', 108, 2, 36, 79, 79, 1500000, 'ACTIVE'),
(20805, 'Renê Rodrigues', 'Renê', 'DF', 'Lateral Esquerdo', 108, 6, 33, 78, 78, 3000000, 'ACTIVE'),
(20806, 'Facundo Bernal', 'Facundo Bernal', 'MF', 'Volante', 108, 5, 22, 79, 85, 8000000, 'ACTIVE'),
(20807, 'Matheus Martinelli', 'Martinelli', 'MF', 'Meia Central', 108, 8, 24, 80, 84, 9000000, 'ACTIVE'),
(20808, 'Paulo Henrique Ganso', 'Ganso', 'MF', 'Meia Ofensivo', 108, 10, 36, 82, 82, 2500000, 'ACTIVE'),
(20809, 'Kevin Serna', 'Kevin Serna', 'FW', 'Ponta Direita', 108, 90, 28, 80, 81, 6000000, 'ACTIVE'),
(20810, 'Germán Cano', 'Cano', 'FW', 'Centroavante', 108, 14, 38, 81, 81, 2000000, 'ACTIVE'),
(20811, 'John Kennedy', 'John Kennedy', 'FW', 'Centroavante', 108, 9, 24, 78, 84, 7000000, 'ACTIVE'),

-- OUTROS CLUBES (Grêmio 109, Bahia 110, Corinthians 111, Santos 112... Elencos base representativos)
(20901, 'Marchesín', 'Marchesín', 'GK', 'Goleiro Titular', 109, 1, 38, 79, 79, 1000000, 'ACTIVE'),
(20902, 'Walter Kannemann', 'Kannemann', 'DF', 'Zagueiro', 109, 4, 35, 79, 79, 1500000, 'ACTIVE'),
(20903, 'Yeferson Soteldo', 'Soteldo', 'FW', 'Ponta Esquerda', 109, 7, 29, 81, 81, 7000000, 'ACTIVE'),
(20904, 'Martin Braithwaite', 'Braithwaite', 'FW', 'Centroavante', 109, 22, 35, 81, 81, 3000000, 'ACTIVE'),

(21001, 'Marcos Felipe', 'Marcos Felipe', 'GK', 'Goleiro Titular', 110, 22, 30, 78, 79, 3000000, 'ACTIVE'),
(21002, 'Everton Ribeiro', 'Everton Ribeiro', 'MF', 'Meia Capitão', 110, 10, 37, 82, 82, 2500000, 'ACTIVE'),
(21003, 'Caio Alexandre', 'Caio Alexandre', 'MF', 'Volante', 110, 19, 27, 80, 83, 7000000, 'ACTIVE'),
(21004, 'Everaldo Stum', 'Everaldo', 'FW', 'Centroavante', 110, 9, 35, 78, 78, 2000000, 'ACTIVE'),

(21101, 'Hugo Souza', 'Hugo Souza', 'GK', 'Goleiro Titular', 111, 1, 27, 81, 85, 8000000, 'ACTIVE'),
(21102, 'André Ramalho', 'André Ramalho', 'DF', 'Zagueiro', 111, 5, 34, 79, 79, 3500000, 'ACTIVE'),
(21103, 'Rodrigo Garro', 'Rodrigo Garro', 'MF', 'Meia Ofensivo', 111, 10, 28, 83, 84, 12000000, 'ACTIVE'),
(21104, 'Yuri Alberto', 'Yuri Alberto', 'FW', 'Centroavante', 111, 9, 25, 81, 84, 13000000, 'ACTIVE'),
(21105, 'Memphis Depay', 'Memphis Depay', 'FW', 'Atacante', 111, 94, 32, 83, 83, 10000000, 'ACTIVE'),

(21201, 'Gabriel Brazão', 'Gabriel Brazão', 'GK', 'Goleiro Titular', 112, 77, 25, 78, 83, 4000000, 'ACTIVE'),
(21202, 'Gil', 'Gil', 'DF', 'Zagueiro', 112, 4, 39, 76, 76, 500000, 'ACTIVE'),
(21203, 'Diego Pituca', 'Diego Pituca', 'MF', 'Volante', 112, 8, 33, 78, 78, 2500000, 'ACTIVE'),
(21204, 'Neymar Jr', 'Neymar Jr', 'FW', 'Atacante / Meia', 112, 10, 34, 85, 85, 25000000, 'ACTIVE'),

(21301, 'Léo Jardim', 'Léo Jardim', 'GK', 'Goleiro Titular', 113, 1, 31, 81, 82, 6000000, 'ACTIVE'),
(21302, 'Philippe Coutinho', 'Coutinho', 'MF', 'Meia Ofensivo', 113, 11, 34, 82, 82, 6000000, 'ACTIVE'),
(21303, 'Pablo Vegetti', 'Vegetti', 'FW', 'Centroavante Capitão', 113, 99, 37, 81, 81, 2500000, 'ACTIVE');

-- ----------------------------------------------------------------------------
-- 4. REGISTRO INICIAL DO HISTÓRICO DOS ATLETAS (player_career_history)
-- ----------------------------------------------------------------------------
INSERT INTO public.player_career_history (player_id, season, new_team_id, event_type, event_date, overall_after, notes)
SELECT id, '2026', team_id, 'INITIAL_REGISTRATION', CURRENT_DATE, overall_rating, 'Carga inicial checada sem boatos - Temporada 2026'
FROM public.players;

-- ============================================================================
-- FIM DA CARGA SEED SQL
-- ============================================================================
