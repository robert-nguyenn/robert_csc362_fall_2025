USE red_river_climbs;

DROP VIEW IF EXISTS browse_climbs;
CREATE VIEW browse_climbs AS
SELECT
  c.climb_name,
  cg.grade_str,
  cr.crag_name,
  r.region_name,
  CASE
    WHEN sc.climb_id IS NOT NULL AND tc.climb_id IS NOT NULL THEN 'Mixed'
    WHEN sc.climb_id IS NOT NULL THEN 'Sport'
    WHEN tc.climb_id IS NOT NULL THEN 'Trad'
    ELSE 'Unknown'
  END AS style
FROM climbs AS c
JOIN climb_grades AS cg
  ON cg.grade_id = c.grade_id
JOIN crags AS cr
  ON cr.crag_id = c.crag_id
JOIN regions AS r
  ON r.region_id = cr.region_id
LEFT JOIN sport_climbs AS sc
  ON sc.climb_id = c.climb_id
LEFT JOIN trad_climbs  AS tc
  ON tc.climb_id = c.climb_id;
