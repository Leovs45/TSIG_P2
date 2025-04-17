-- 5)
SELECT st_length(st_linemerge(st_union(geom)))
FROM ft_vias
where nom_calle = 'Magallanes';

-- 10)
SELECT m.gid
FROM ft_manzanas m
WHERE st_intersect(
    m.geom,
    st_buffer(
      SELECT st_intersection (
          SELECT st_linemerge (st_union(geom))
          FROM ft_vias
          WHERE nom_calle = 'Magallanes'
        ),
        (
          SELECT st_linemerge (st_union (geom))
          FROM ft_vias
          WHERE nom_calle = 'colonia'
        )
    ),
    20
  )
);