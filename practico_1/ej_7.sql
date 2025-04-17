WITH espacios_libres AS (
  SELECT ST_Transform(geometry, 32721) AS geom
  FROM v_sig_espacios_publicos
),
padrones_mvd AS (
  SELECT p.*
  FROM v_mdg_parcelas_geom p
    JOIN ideuy_limites_departamentales_igm_20220211 d ON ST_Within(
      ST_Transform(p.geometry, 32721),
      ST_Transform(d.geometry, 32721)
    )
  WHERE d.NOMBRE = 'Montevideo'
),
padrones_cercanos AS (
  SELECT DISTINCT p.gid
  FROM padrones_mvd p
    JOIN espacios_libres e ON ST_DWithin(ST_Transform(p.geometry, 32721), e.geom, 1000)
)
SELECT p.*
FROM padrones_mvd p
WHERE p.gid NOT IN (
    SELECT gid
    FROM padrones_cercanos
  );

;