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
  END AS style,
  COALESCE(fa_names.first_ascensionists, 'Unknown') AS first_ascensionists,
  COALESCE(dev_names.developers, 'Unknown') AS developers
FROM climbs AS c
INNER JOIN climb_grades AS cg
  ON cg.grade_id = c.grade_id
INNER JOIN crags AS cr
  ON cr.crag_id = c.crag_id
INNER JOIN regions AS r
  ON r.region_id = cr.region_id
LEFT JOIN sport_climbs AS sc
  ON sc.climb_id = c.climb_id
LEFT JOIN trad_climbs AS tc
  ON tc.climb_id = c.climb_id
LEFT JOIN (
  SELECT 
    cfa.climb_id,
    GROUP_CONCAT(CONCAT(cl.climber_first_name, ' ', cl.climber_last_name) 
                 ORDER BY cl.climber_last_name SEPARATOR ', ') AS first_ascensionists
  FROM climber_first_ascents AS cfa
  INNER JOIN climbers AS cl ON cl.climber_id = cfa.climber_id
  GROUP BY cfa.climb_id
) AS fa_names ON fa_names.climb_id = c.climb_id
LEFT JOIN (
  SELECT 
    cce.climb_id,
    GROUP_CONCAT(CONCAT(cl.climber_first_name, ' ', cl.climber_last_name) 
                 ORDER BY cl.climber_last_name SEPARATOR ', ') AS developers
  FROM climber_climbs_established AS cce
  INNER JOIN climbers AS cl ON cl.climber_id = cce.climber_id
  GROUP BY cce.climb_id
) AS dev_names ON dev_names.climb_id = c.climb_id;
