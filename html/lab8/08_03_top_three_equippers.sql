USE red_river_climbs;

SELECT
  CONCAT(cl.climber_first_name, ' ', cl.climber_last_name) AS climber_name,
  COUNT(*)                                                AS num_routes
FROM climber_climbs_established AS ce
JOIN climbers AS cl
  ON cl.climber_id = ce.climber_id
GROUP BY ce.climber_id, cl.climber_first_name, cl.climber_last_name
ORDER BY num_routes DESC, climber_name ASC
LIMIT 3;
