USE red_river_climbs;

UPDATE climbs
   SET grade_id = (
         SELECT grade_id FROM climb_grades WHERE grade_str = '5.10b'
       )
 WHERE grade_id = (
         SELECT grade_id FROM climb_grades WHERE grade_str = '5.10a'
       );