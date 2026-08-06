-- CARGA DO FATURAMENTO HISTORICO (do Excel do gerente)
-- Rode UMA VEZ no Supabase -> SQL Editor -> New query -> Run.
--
-- SEGURO: usa ON CONFLICT DO NOTHING, entao meses que ja tem faturamento
-- vindo do PDF do ERP NAO sao tocados. Pode rodar de novo sem risco.
--
-- O Excel traz um unico numero por mes, sem separar bruto de liquido.
-- Ele foi gravado em fat_liquido, que e o campo que alimenta os graficos.
-- periodo_inicio/periodo_fim ficam nulos de proposito: nao sabemos o
-- periodo exato do ERP nesses meses, e nulo nao atrapalha a trava
-- anti-sobreposicao dos proximos envios de PDF.

INSERT INTO despesas_faturamento (unidade, ano, mes, fat_liquido) VALUES
('dilnor', 2022, 1, 5016385.0),
('dilnor', 2022, 2, 5390434.0),
('dilnor', 2022, 3, 6215583.0),
('dilnor', 2022, 4, 5915873.0),
('dilnor', 2022, 5, 5825589.0),
('dilnor', 2022, 6, 6516992.0),
('dilnor', 2022, 7, 5202629.0),
('dilnor', 2022, 8, 6167142.0),
('dilnor', 2022, 9, 6084677.0),
('dilnor', 2022, 10, 5585175.0),
('dilnor', 2022, 11, 7227473.0),
('dilnor', 2022, 12, 5842855.0),
('dilnor', 2023, 1, 5600442.0),
('dilnor', 2023, 2, 5504934.0),
('dilnor', 2023, 3, 6025970.0),
('dilnor', 2023, 4, 5695489.0),
('dilnor', 2023, 5, 7340650.0),
('dilnor', 2023, 6, 6776565.0),
('dilnor', 2023, 7, 6511455.0),
('dilnor', 2023, 8, 7889923.0),
('dilnor', 2023, 9, 5871256.0),
('dilnor', 2023, 10, 5871256.0),
('dilnor', 2023, 11, 6541132.0),
('dilnor', 2023, 12, 5312114.0),
('dilnor', 2024, 1, 5846498.0),
('dilnor', 2024, 2, 5958493.0),
('dilnor', 2024, 3, 5812068.0),
('dilnor', 2024, 4, 6523365.0),
('dilnor', 2024, 5, 7417652.0),
('dilnor', 2024, 6, 5945474.0),
('dilnor', 2024, 7, 6918049.0),
('dilnor', 2024, 8, 6527905.0),
('dilnor', 2024, 9, 6144669.98),
('dilnor', 2024, 10, 7149183.25),
('dilnor', 2024, 11, 6496749.73),
('dilnor', 2024, 12, 4869900.68),
('dilnor', 2025, 1, 6713745.63),
('dilnor', 2025, 2, 6269881.89),
('dilnor', 2025, 3, 6919767.87),
('dilnor', 2025, 4, 7200937.85),
('dilnor', 2025, 5, 7805001.0),
('dilnor', 2025, 6, 7087447.25),
('dilnor', 2025, 7, 8307519.48),
('dilnor', 2025, 8, 8156047.42),
('dilnor', 2025, 9, 10475072.66),
('dilnor', 2025, 10, 7411822.49),
('dilnor', 2025, 11, 9014313.8),
('dilnor', 2025, 12, 8075798.33),
('dilnor', 2026, 1, 8971918.41),
('dilnor', 2026, 2, 7797593.53),
('dilnor', 2026, 3, 7660098.05),
('dilnor', 2026, 4, 8899122.57),
('dilnor', 2026, 5, 9196625.44),
('dilnor', 2026, 6, 8855606.45)
ON CONFLICT (unidade, ano, mes) DO NOTHING;

-- Conferencia:
--   SELECT ano, count(*) FROM despesas_faturamento WHERE unidade='dilnor' GROUP BY ano ORDER BY ano;
