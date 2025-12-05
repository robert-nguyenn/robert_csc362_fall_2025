USE red_river_climbs;

-- Function to get grade_id from grade string
DROP FUNCTION IF EXISTS get_grade_id;
DELIMITER $$
CREATE FUNCTION get_grade_id(grade_string VARCHAR(10))
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE grade_id_result INT;
    SELECT grade_id INTO grade_id_result 
    FROM climb_grades 
    WHERE grade_str = grade_string;
    RETURN grade_id_result;
END$$
DELIMITER ;

UPDATE climbs
   SET grade_id = get_grade_id('5.10b')
 WHERE grade_id = get_grade_id('5.10a');