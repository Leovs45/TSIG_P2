-- 1) Devolver los ejes de la calle Magallanes en los siguientes formatos y comparar resultados:
-- a) WKT (Well-Known Text)
SELECT ST_AsText(geometry)
FROM v_sig_vias
WHERE UPPER(NOM_CALLE) = 'MAGALLANES';

-- b) EWKT (Extended Well-Known Text, incluye SRID)
SELECT ST_AsEWKT(geometry)
FROM v_sig_vias
WHERE UPPER(NOM_CALLE) = 'MAGALLANES';

-- c) GML (Geography Markup Language)
SELECT ST_AsGML(geometry)
FROM v_sig_vias
WHERE UPPER(NOM_CALLE) = 'MAGALLANES';

-- d) KML (Keyhole Markup Language)
SELECT ST_AsKML(geometry)
FROM v_sig_vias
WHERE UPPER(NOM_CALLE) = 'MAGALLANES';

-- e) GeoJSON
SELECT ST_AsGeoJSON(geometry)
FROM v_sig_vias
WHERE UPPER(NOM_CALLE) = 'MAGALLANES';

-- 2) Longitud de la calle Magallanes utilizando SUM:
SELECT SUM(ST_Length(geometry)) AS longitud_total
FROM v_sig_vias
WHERE UPPER(NOM_CALLE) = 'MAGALLANES';

--3) Unión de los ejes de Magallanes en WKT:
SELECT ST_AsText(ST_Union(geometry)) AS geometria_unida
FROM v_sig_vias
WHERE UPPER(NOM_CALLE) = 'MAGALLANES';

-- 4) LineString único con ST_LineMerge:
SELECT ST_AsText(ST_LineMerge(ST_Union(geometry))) AS linea_merged
FROM v_sig_vias
WHERE UPPER(NOM_CALLE) = 'MAGALLANES';

-- 5) Longitud sin usar SUM:
SELECT ST_Length(ST_Union(geometry)) AS longitud_sin_sum
FROM v_sig_vias
WHERE UPPER(NOM_CALLE) = 'MAGALLANES';

-- 6) Área en km² del departamento de Florida:
-- Opción A - con ::geography:
SELECT ST_Area(geometry::geography) / 1000000 AS area_km2
FROM ideuy_limites_departamentales_igm_20220211
WHERE UPPER(NOMBRE) = 'FLORIDA';

-- Opción B - reproyección (por ejemplo a UTM 32721):
SELECT ST_Area(ST_Transform(geometry, 32721)) / 1000000 AS area_km2
FROM ideuy_limites_departamentales_igm_20220211
WHERE UPPER(NOMBRE) = 'FLORIDA';

-- 7) Cantidad de puntos del polígono de Maldonado:
SELECT ST_NPoints(geometry) AS cantidad_puntos
FROM ideuy_limites_departamentales_igm_20220211
WHERE UPPER(NOMBRE) = 'MALDONADO';

-- 8) Departamento que contiene Magallanes:
-- a) Usando ST_Contains:
SELECT d.NOMBRE
FROM ideuy_limites_departamentales_igm_20220211 d
  JOIN v_sig_vias v ON ST_Contains(d.geometry, v.geometry)
WHERE UPPER(v.NOM_CALLE) = 'MAGALLANES'
LIMIT 1;

-- b) Usando ST_Within:
SELECT d.NOMBRE
FROM ideuy_limites_departamentales_igm_20220211 d
  JOIN v_sig_vias v ON ST_Within(v.geometry, d.geometry)
WHERE UPPER(v.NOM_CALLE) = 'MAGALLANES'
LIMIT 1;

-- 9) Nombres de calles que cruzan con Magallanes:
SELECT DISTINCT v2.NOM_CALLE
FROM v_sig_vias v1
  JOIN v_sig_vias v2 ON ST_Intersects(v1.geometry, v2.geometry)
WHERE UPPER(v1.NOM_CALLE) = 'MAGALLANES'
  AND UPPER(v2.NOM_CALLE) <> 'MAGALLANES';

-- 10) Manzanas en el cruce de Magallanes y Colonia:
SELECT m.*
FROM v_sig_vias v1
  JOIN v_sig_vias v2 ON ST_Intersects(v1.geometry, v2.geometry)
  JOIN v_sig_manzanas_materializadas m ON ST_Intersects(
    m.geometry,
    ST_Intersection(v1.geometry, v2.geometry)
  )
WHERE UPPER(v1.NOM_CALLE) = 'MAGALLANES'
  AND UPPER(v2.NOM_CALLE) = 'COLONIA';

-- 11) Calidad de datos geográficos
-- a) Ejes que tocan manzanas (ST_Touches):
SELECT v.*
FROM v_sig_vias v
  JOIN v_sig_manzanas_materializadas m ON ST_Touches(v.geometry, m.geometry);

-- b) Ejes contenidos en manzanas (ST_Within):
SELECT v.*
FROM v_sig_vias v
  JOIN v_sig_manzanas_materializadas m ON ST_Within(v.geometry, m.geometry);

-- c) Ejes que empiezan o terminan dentro de manzanas:
SELECT v.*
FROM v_sig_vias v
  JOIN v_sig_manzanas_materializadas m ON ST_Within(ST_StartPoint(v.geometry), m.geometry)
  OR ST_Within(ST_EndPoint(v.geometry), m.geometry);

-- d) Ejes con puntos interiores dentro de manzanas, pero que no empiezan ni terminan dentro:
SELECT v.*
FROM v_sig_vias v
  JOIN v_sig_manzanas_materializadas m ON ST_Within(ST_PointN(v.geometry, 2), m.geometry)
WHERE NOT ST_Within(ST_StartPoint(v.geometry), m.geometry)
  AND NOT ST_Within(ST_EndPoint(v.geometry), m.geometry);