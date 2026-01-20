
-- Advanced SQL (Window Functions)

-- Objective: Analyze traffic behavior per user without collapsing the session details.

DROP TABLE IF EXISTS ventas.logs_actividad;

CREATE TABLE ventas.logs_actividad(
	usuario VARCHAR(50),
	fecha_acceso TIMESTAMP,
	kb_descargados INT
);

INSERT INTO ventas.logs_actividad(usuario,fecha_acceso,kb_descargados)
VALUES
('bastihan_admin','2026-01-15 08:30:00',1500),
('bastihan_admin','2026-01-15 10:45:00',3200),
('ana_analista','2026-01-15 09:00:00,500),
('ana_analista,'2026-01-15 11:30:00',1100),
('bastihan_admin',2026-01-15 14:20:00',800);

SELECT
	usuario,
	fecha_acceso,
	kb_descargados,
	SUM(kb_descargados) OVER(PARTITION BY usuario) AS total_por_usuario,
	DENSE_RANK() OVER(ORDER BY kb_descargados DESC) AS ranking_descarga,
	COALESCE(kb_descargados - LAG(kb_descargados) OVER(PARTITION BY usuario ORDER BY fecha_acceso),0) AS diff_kb
FROM ventas.logs_actividad;
