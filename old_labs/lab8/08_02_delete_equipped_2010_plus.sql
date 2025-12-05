USE red_river_climbs;

-- Create view to identify climbs equipped in 2010 or later
DROP VIEW IF EXISTS climbs_to_delete;
CREATE VIEW climbs_to_delete AS
SELECT climb_id
FROM climbs
WHERE (climb_established_date >= '2010-01-01'
    OR climb_first_ascent_date >= '2010-01-01');

-- Delete from all related tables using the view
DELETE FROM climber_first_ascents
 WHERE climb_id IN (SELECT climb_id FROM climbs_to_delete);

DELETE FROM climber_climbs_established
 WHERE climb_id IN (SELECT climb_id FROM climbs_to_delete);

DELETE FROM sport_climbs
 WHERE climb_id IN (SELECT climb_id FROM climbs_to_delete);

DELETE FROM trad_climbs
 WHERE climb_id IN (SELECT climb_id FROM climbs_to_delete);

DELETE FROM climbs
 WHERE climb_id IN (SELECT climb_id FROM climbs_to_delete);
