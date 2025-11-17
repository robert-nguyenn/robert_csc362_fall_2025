USE red_river_climbs;

-- The set of climb_ids to remove
-- (repeated subquery keeps this portable and easy to read)
DELETE FROM climber_first_ascents
 WHERE climb_id IN (
   SELECT climb_id
     FROM climbs
    WHERE (climb_established_date >= '2010-01-01'
        OR climb_first_ascent_date >= '2010-01-01')
 );

DELETE FROM climber_climbs_established
 WHERE climb_id IN (
   SELECT climb_id
     FROM climbs
    WHERE (climb_established_date >= '2010-01-01'
        OR climb_first_ascent_date >= '2010-01-01')
 );

DELETE FROM sport_climbs
 WHERE climb_id IN (
   SELECT climb_id
     FROM climbs
    WHERE (climb_established_date >= '2010-01-01'
        OR climb_first_ascent_date >= '2010-01-01')
 );

DELETE FROM trad_climbs
 WHERE climb_id IN (
   SELECT climb_id
     FROM climbs
    WHERE (climb_established_date >= '2010-01-01'
        OR climb_first_ascent_date >= '2010-01-01')
 );

DELETE FROM climbs
 WHERE climb_id IN (
   SELECT climb_id
     FROM climbs
    WHERE (climb_established_date >= '2010-01-01'
        OR climb_first_ascent_date >= '2010-01-01')
 );
