USE robo_rest;

DROP PROCEDURE IF EXISTS cancel_order;

DELIMITER $$

CREATE PROCEDURE cancel_order(
    IN p_order_id INT UNSIGNED
)
BEGIN
    DECLARE order_time DATETIME;
    DECLARE time_diff INT;
    
    SELECT order_datetime INTO order_time
    FROM orders
    WHERE order_id = p_order_id;
    
    IF order_time IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Order not found';
    END IF;
    
    SET time_diff = TIMESTAMPDIFF(MINUTE, order_time, NOW());
    
    IF time_diff > 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot cancel order older than 10 minutes';
    END IF;
    
    DELETE FROM order_dishes
    WHERE order_id = p_order_id;
    
    DELETE FROM orders
    WHERE order_id = p_order_id;
    
    SELECT 'Order cancelled successfully' AS message;
END$$

DELIMITER ;
