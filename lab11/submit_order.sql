USE robo_rest;

DROP PROCEDURE IF EXISTS submit_order;

DELIMITER $$

CREATE PROCEDURE submit_order(
    IN p_customer_id INT UNSIGNED,
    IN p_order_lat DECIMAL(8,6),
    IN p_order_long DECIMAL(9,6),
    IN p_robot_id INT UNSIGNED,
    IN p_dish_ids TEXT
)
BEGIN
    DECLARE new_order_id INT UNSIGNED;
    DECLARE dish_id_val INT UNSIGNED;
    DECLARE comma_pos INT;
    DECLARE remaining_dishes TEXT;
    
    INSERT INTO orders (customer_id, order_lat, order_long, robot_id, order_datetime)
    VALUES (p_customer_id, p_order_lat, p_order_long, p_robot_id, NOW());
    
    SET new_order_id = LAST_INSERT_ID();
    
    -- Process the comma-separated dish IDs
    SET remaining_dishes = p_dish_ids;
    
    WHILE LENGTH(remaining_dishes) > 0 DO
        SET comma_pos = LOCATE(',', remaining_dishes);
        
        IF comma_pos > 0 THEN
            SET dish_id_val = CAST(SUBSTRING(remaining_dishes, 1, comma_pos - 1) AS UNSIGNED);
            SET remaining_dishes = SUBSTRING(remaining_dishes, comma_pos + 1);
        ELSE
            SET dish_id_val = CAST(remaining_dishes AS UNSIGNED);
            SET remaining_dishes = '';
        END IF;
        
        INSERT INTO order_dishes (order_id, dish_id)
        VALUES (new_order_id, dish_id_val);
    END WHILE;
    
    SELECT new_order_id AS order_id;
END$$

DELIMITER ;
