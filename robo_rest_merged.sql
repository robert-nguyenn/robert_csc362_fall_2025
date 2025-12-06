DROP DATABASE IF EXISTS robo_rest;
CREATE DATABASE robo_rest;
USE robo_rest;

--Hola :3

--customers
CREATE TABLE customers (
    customer_id         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    customer_username   VARCHAR(32) NOT NULL,
    PRIMARY KEY (customer_id)
);

--dishes 
CREATE TABLE dishes (
    dish_id             INT UNSIGNED NOT NULL AUTO_INCREMENT,
    dish_name           VARCHAR(64) NOT NULL,
    dish_price          DECIMAL(2,2) NOT NULL,
    PRIMARY KEY (dish_id)
);

--maintenance tasks
CREATE TABLE maintenance_tasks (
    maintenance_task_id             INT UNSIGNED AUTO_INCREMENT,
    maintenance_task_description    VARCHAR(50),
    PRIMARY KEY (maintenance_task_id)
);

CREATE TABLE robots (
    robot_id      INT UNSIGNED NOT NULL,
    PRIMARY KEY   (robot_id)
);

-- robot maintenance tasks
CREATE TABLE robot_maintenance_tasks (
    robot_id            INT UNSIGNED,
    maintenance_task_id INT UNSIGNED,
    PRIMARY KEY (robot_id, maintenance_task_id),
    FOREIGN KEY (robot_id) REFERENCES robots (robot_id),
    FOREIGN KEY (maintenance_task_id) REFERENCES maintenance_tasks (maintenance_task_id)
);


-- -- loyalty_promotions
-- CREATE loyalty_promotions (
--     loyalty_promotion_id    INT NOT NULL AUTO_INCREMENT,
--     total_order_cost_usd    DECIMAL(10,2),
--     num_free_orders         INT,
--     PRIMARY KEY (loyalty_promotion_id)
-- );

-- orders
CREATE TABLE orders (
    order_id        INT UNSIGNED NOT NULL AUTO_INCREMENT,
    order_lat       DECIMAL(8,6) NOT NULL,
    order_long      DECIMAL(9,6) NOT NULL,
    customer_id     INT UNSIGNED,
    robot_id        INT UNSIGNED,
    order_datetime  DATETIME DEFAULT CURRENT_TIMESTAMP(),
    PRIMARY KEY(order_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (robot_id) REFERENCES robots(robot_id)
);

-- order_dishes
CREATE TABLE order_dishes (
    order_id INT UNSIGNED NOT NULL,
    dish_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (order_id, dish_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (dish_id) REFERENCES dishes(dish_id)
);

-- SOURCE robo_rest_sample_data.sql;

INSERT INTO maintenance_tasks (maintenance_task_id, maintenance_task_description)
VALUES (1,"Replace drone battery"),
       (2,"Fix propellers"),
       (3,"Fix something else");
     



INSERT INTO robot_maintenance_tasks (maintenance_task_id, robot_id)
VALUES  (1, 1),
        (1, 2),
        (1, 3),
        (2, 2),
        (2, 1);

INSERT INTO dishes (dish_name, dish_price) 
VALUES  ('Classic Margherita Pizza', 9.99),
        ('Spicy Buffalo Wings',      7.49),
        ('Vegan Buddha Bowl',       11.25),
        ('Cheeseburger Combo',       8.75),
        ('Sushi Platter (8 pcs)',   13.50),
        ('Caesar Salad',             6.95),
        ('Chicken Alfredo Pasta',   12.40),
        ('Chocolate Lava Cake',      5.25),
        ('Tomato Soup',              4.10),
        ('Iced Caramel Latte',       3.95);


INSERT INTO loyalty_promotions (total_order_cost_usd, num_free_orders) 
VALUES  ( 50.00,  1),  
        (100.00,  2),  
        (250.00,  5),  
        (500.00, 10),   
        (750.00, 15);   




INSERT INTO order_dishes (order_id,dish_id) 
VALUES  (1,1),
        (1,2),
        (2,4);


-- INSERT INTO loyalty_promotions (total_order_cost_usd, num_free_orders) 
-- VALUES  ( 100, 1),
--         (1000, 2),
--         (2000, 3);
