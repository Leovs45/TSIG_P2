-- 1) Devolver los ejes de la calle Magallanes en los siguientes formatos y comparar resultados:
-- a) WKT
SELECT ST_AsText(geom)
FROM ft_vias
WHERE nom_calle = 'Magallanes';

-- b) EWKT
SELECT ST_AsEWKT(geom)
FROM ft_vias
WHERE nom_calle = 'Magallanes';

-- c) GML
SELECT ST_AsGML(geom)
FROM ft_vias
WHERE nom_calle = 'Magallanes';

-- d) KML
SELECT ST_AsKML(geom)
FROM ft_vias
WHERE nom_calle = 'Magallanes';

-- e) GeoJSON
SELECT ST_AsGeoJSON(geom)
FROM ft_vias
WHERE nom_calle = 'Magallanes';

-- 2) Longitud de la calle Magallanes utilizando SUM:
SELECT SUM(ST_Length(geom))
FROM ft_vias
WHERE nom_calle = 'Magallanes';

--3) Unión de los ejes de Magallanes en WKT -> Es un MultiLineString
SELECT ST_AsText(ST_Union(geom))
FROM ft_vias
WHERE nom_calle = 'Magallanes';

-- 4) LineString único con ST_LineMerge:
SELECT ST_AsText(ST_LineMerge(ST_Union(geom)))
FROM ft_vias
WHERE nom_calle = 'Magallanes';

--! 5) Longitud sin usar SUM: (Esta mal, ver la solución del profe)
SELECT ST_Length(ST_Union(geometry)) AS longitud_sin_sum
FROM v_sig_vias
WHERE UPPER(NOM_CALLE) = 'MAGALLANES';

-- 6) Área en km² del departamento de Florida: Se transforma la geometria para que Area no trabaje en grados y se divide entre 1M para pasar de m cuadrados a km cuadrados
SELECT ST_Area(ST_Transform(geometry, 32721)) / 1000000 AS area_km2
FROM ft_limites_dep
WHERE Nombre = 'Florida';

-- 7) Cantidad de puntos del polígono de Maldonado:
SELECT ST_NPoints(geometry) AS cantidad_puntos
FROM ft_limites_dep
WHERE UPPER(NOMBRE) = 'MALDONADO';

-- 8) Departamento que contiene Magallanes:
-- a) Usando ST_Contains:
SELECT d.NOMBRE
FROM ft_limites_dep d
  JOIN v_sig_vias v ON ST_Contains(d.geometry, v.geometry)
WHERE UPPER(v.NOM_CALLE) = 'MAGALLANES';

-- b) Usando ST_Within:
SELECT d.NOMBRE
FROM ft_limites_dep d
  JOIN v_sig_vias v ON ST_Within(v.geometry, d.geometry)
WHERE UPPER(v.NOM_CALLE) = 'MAGALLANES';

-- 9) Nombres de calles que cruzan con Magallanes:
SELECT DISTINCT v2.NOM_CALLE
FROM v_sig_vias v1
  JOIN v_sig_vias v2 ON ST_Intersects(v1.geometry, v2.geometry)
WHERE UPPER(v1.NOM_CALLE) = 'MAGALLANES'
  AND UPPER(v2.NOM_CALLE) <> 'MAGALLANES';

--! 10) Manzanas en el cruce de Magallanes y Colonia: (Esta mal, ver la solución del profe)
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
SELECT e.gid
FROM ft_vias e
JOIN ft_manzanas m ON ST_Touches(e.geom, m.geom);

-- b) Ejes contenidos en manzanas (ST_Within):
SELECT e.gid
FROM ft_vias e
JOIN ft_manzanas m ON ST_Within(e.geom, m.geom);

-- c) Ejes que empiezan o terminan dentro de manzanas:
SELECT e.gid
FROM ft_vias e
JOIN ft_manzanas m
  ON ST_Contains(m.geom, ST_StartPoint(e.geom))
     OR ST_Contains(m.geom, ST_EndPoint(e.geom));

-- d) Ejes con puntos interiores dentro de manzanas, pero que no empiezan ni terminan dentro:
SELECT e.gid
FROM ft_vias e
JOIN ft_manzanas m
  ON ST_Contains(m.geom, e.geom)
WHERE NOT (
  ST_Contains(m.geom, ST_StartPoint(e.geom)) OR
  ST_Contains(m.geom, ST_EndPoint(e.geom))
);