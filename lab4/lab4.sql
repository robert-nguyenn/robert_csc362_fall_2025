-- Lab 4 - Flying Carpets Gallery

SET FOREIGN_KEY_CHECKS = 0;

-- Drop triggers first (if they exist)
DROP TRIGGER IF EXISTS trg_sales_no_loss_ins;
DROP TRIGGER IF EXISTS trg_sales_no_loss_upd;
DROP TRIGGER IF EXISTS trg_trials_no_overlap_ins;
DROP TRIGGER IF EXISTS trg_trials_no_overlap_upd;
DROP TRIGGER IF EXISTS trg_trials_max4_ins;
DROP TRIGGER IF EXISTS trg_trials_max4_upd;

-- Drop tables child -> parent
DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Trials;
DROP TABLE IF EXISTS Rugs;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Addresses;

SET FOREIGN_KEY_CHECKS = 1;

-- Tables

CREATE TABLE Addresses (
  address_id       INT AUTO_INCREMENT PRIMARY KEY,
  address_street   VARCHAR(100) NOT NULL,
  address_city     VARCHAR(60)  NOT NULL,
  address_state    CHAR(2)      NOT NULL,
  address_zipcode  VARCHAR(10)  NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Customers (
  customer_id        INT AUTO_INCREMENT PRIMARY KEY,
  address_id         INT NOT NULL,
  customer_firstname VARCHAR(40) NOT NULL,
  customer_lastname  VARCHAR(40) NOT NULL,
  customer_phone     VARCHAR(20) NULL,
  CONSTRAINT uq_customer_phone UNIQUE (customer_phone),    -- many NULLs allowed
  CONSTRAINT fk_customers_address
    FOREIGN KEY (address_id) REFERENCES Addresses(address_id)
    ON DELETE RESTRICT                                        -- customers require an address
) ENGINE=InnoDB;

CREATE TABLE Rugs (
  rug_inventory_number INT PRIMARY KEY,
  rug_country_of_origin VARCHAR(40) NOT NULL,
  rug_year_made         INT NOT NULL,
  rug_style             VARCHAR(40) NOT NULL,
  rug_material          VARCHAR(20) NOT NULL,
  rug_width             DECIMAL(6,2) NOT NULL,   
  rug_length            DECIMAL(6,2) NOT NULL,   
  rug_date_acquired     DATE NOT NULL,
  rug_original_price    DECIMAL(12,2) NOT NULL,
  rug_markup_percent    DECIMAL(6,2) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Sales (
  sale_id              INT AUTO_INCREMENT PRIMARY KEY,
  rug_inventory_number INT NOT NULL,
  customer_id          INT NOT NULL,
  sale_date            DATE NOT NULL,
  sale_price           DECIMAL(12,2) NOT NULL,
  sale_returned_date   DATE NULL,
  CONSTRAINT fk_sales_rug
    FOREIGN KEY (rug_inventory_number) REFERENCES Rugs(rug_inventory_number)
    ON DELETE RESTRICT,
  CONSTRAINT fk_sales_customer
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
    ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE Trials (
  trial_id                   INT AUTO_INCREMENT PRIMARY KEY,
  rug_inventory_number       INT NOT NULL,
  customer_id                INT NULL,
  trial_start_date           DATE NOT NULL,
  trial_expected_return_date DATE NOT NULL,
  trial_actual_return_date   DATE NULL,
  CONSTRAINT fk_trials_rug
    FOREIGN KEY (rug_inventory_number) REFERENCES Rugs(rug_inventory_number)
    ON DELETE RESTRICT,
  CONSTRAINT fk_trials_customer
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
    ON DELETE SET NULL                                  -- privacy delete policy
) ENGINE=InnoDB;

-- Helpful index for overlap checks
CREATE INDEX ix_trials_rug_dates
ON Trials (rug_inventory_number, trial_start_date, trial_expected_return_date, trial_actual_return_date);

-- Business-rule triggers

DELIMITER $$

-- BR1: No-loss sale unless rug has been held 2+ years.
CREATE TRIGGER trg_sales_no_loss_ins
BEFORE INSERT ON Sales
FOR EACH ROW
BEGIN
  DECLARE v_cost DECIMAL(12,2);
  DECLARE v_acq  DATE;

  SELECT rug_original_price, rug_date_acquired
  INTO v_cost, v_acq
  FROM Rugs
  WHERE rug_inventory_number = NEW.rug_inventory_number;

  IF NEW.sale_price < v_cost
     AND NEW.sale_date < DATE_ADD(v_acq, INTERVAL 2 YEAR) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Loss not allowed before 2 years.';
  END IF;
END$$

CREATE TRIGGER trg_sales_no_loss_upd
BEFORE UPDATE ON Sales
FOR EACH ROW
BEGIN
  DECLARE v_cost DECIMAL(12,2);
  DECLARE v_acq  DATE;

  SELECT rug_original_price, rug_date_acquired
  INTO v_cost, v_acq
  FROM Rugs
  WHERE rug_inventory_number = NEW.rug_inventory_number;

  IF NEW.sale_price < v_cost
     AND NEW.sale_date < DATE_ADD(v_acq, INTERVAL 2 YEAR) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Loss not allowed before 2 years.';
  END IF;
END$$

-- BR3: No overlapping trials for the same rug.
-- Treat each trial's "end" as actual_return if present; otherwise expected_return.
CREATE TRIGGER trg_trials_no_overlap_ins
BEFORE INSERT ON Trials
FOR EACH ROW
BEGIN
  DECLARE v_conflicts INT;

  SELECT COUNT(*) INTO v_conflicts
  FROM Trials t
  WHERE t.rug_inventory_number = NEW.rug_inventory_number
    AND t.trial_start_date < COALESCE(NEW.trial_actual_return_date, NEW.trial_expected_return_date)
    AND COALESCE(t.trial_actual_return_date, t.trial_expected_return_date) > NEW.trial_start_date
    AND (t.trial_actual_return_date IS NULL OR t.trial_actual_return_date > NEW.trial_start_date);

  IF v_conflicts > 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Overlapping trial/reservation for this rug.';
  END IF;
END$$

CREATE TRIGGER trg_trials_no_overlap_upd
BEFORE UPDATE ON Trials
FOR EACH ROW
BEGIN
  DECLARE v_conflicts INT;

  SELECT COUNT(*) INTO v_conflicts
  FROM Trials t
  WHERE t.rug_inventory_number = NEW.rug_inventory_number
    AND t.trial_id <> NEW.trial_id
    AND t.trial_start_date < COALESCE(NEW.trial_actual_return_date, NEW.trial_expected_return_date)
    AND COALESCE(t.trial_actual_return_date, t.trial_expected_return_date) > NEW.trial_start_date
    AND (t.trial_actual_return_date IS NULL OR t.trial_actual_return_date > NEW.trial_start_date);

  IF v_conflicts > 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Overlapping trial/reservation for this rug.';
  END IF;
END$$

-- BR4: Max 4 active (not yet returned) trials per customer.
CREATE TRIGGER trg_trials_max4_ins
BEFORE INSERT ON Trials
FOR EACH ROW
BEGIN
  DECLARE v_active INT;

  IF NEW.customer_id IS NOT NULL THEN
    SELECT COUNT(*) INTO v_active
    FROM Trials
    WHERE customer_id = NEW.customer_id
      AND trial_actual_return_date IS NULL;

    IF v_active >= 4 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Customer already has 4 active trials.';
    END IF;
  END IF;
END$$

CREATE TRIGGER trg_trials_max4_upd
BEFORE UPDATE ON Trials
FOR EACH ROW
BEGIN
  DECLARE v_active INT;

  IF NEW.customer_id IS NOT NULL AND NEW.trial_actual_return_date IS NULL THEN
    SELECT COUNT(*) INTO v_active
    FROM Trials
    WHERE customer_id = NEW.customer_id
      AND trial_actual_return_date IS NULL
      AND trial_id <> NEW.trial_id;

    IF v_active >= 4 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Customer already has 4 active trials.';
    END IF;
  END IF;
END$$

DELIMITER ;

-- BR2 (phone unique/nullable) and BR5 (privacy deletion policy) are handled
-- by the UNIQUE constraint + FK ON DELETE rules above.

-- Sample Data

INSERT INTO Addresses (address_street, address_city, address_state, address_zipcode) VALUES
('68 Country Drive', 'Roseville', 'MI', '48066'),                 
('9044 Piper Lane', 'North Royalton', 'OH', '44133'),             
('747 East Harrison Lane', 'Atlanta', 'GA', '30303'),             
('47 East Harrison Lane',  'Atlanta', 'GA', '30303'),             
('78 Corona Rd.', 'Fullerton', 'CA', '92831'),                    
('386 Silver Spear Ct', 'Coraopolis', 'PA', '15108');             

INSERT INTO Customers (address_id, customer_firstname, customer_lastname, customer_phone) VALUES
(1, 'Akira',    'Ingram',  '(926) 252-6716'),
(2, 'Meredith', 'Spencer', '(817) 530-5994'),
(3, 'Marco',    'Page',    '(588) 799-6535'),
(4, 'Sandra',   'Page',    '(997) 697-2666'),
(5, 'Gloria',   'Gomez',   NULL),
(6, 'Bria',     'Le',      NULL);

INSERT INTO Rugs (rug_inventory_number, rug_country_of_origin, rug_year_made, rug_style, rug_material,
                  rug_width, rug_length, rug_date_acquired, rug_original_price, rug_markup_percent)
VALUES
(1214, 'Turkey', 1925, 'Ushak',  'Wool', 5.00,  7.00, '2017-04-06',   625.00, 100.00),
(1219, 'Iran',   1910, 'Tabriz', 'Silk', 10.00, 14.00,'2017-04-06', 28000.00,  75.00),
(1277, 'India',  2017, 'Agra',   'Wool', 8.00, 10.00, '2017-06-15',  1200.00, 100.00),
(1278, 'India',  2017, 'Agra',   'Wool', 4.00,  6.00, '2017-06-15',   450.00, 120.00);

-- Trial Post-It example: Sept 1 – Akira Ingram trials the 5x7 Turkey Ushak; expected back Sept 15.
INSERT INTO Trials (rug_inventory_number, customer_id, trial_start_date, trial_expected_return_date, trial_actual_return_date)
VALUES (
  1214,
  (SELECT customer_id FROM Customers WHERE customer_firstname='Akira' AND customer_lastname='Ingram'),
  '2017-09-01','2017-09-15', NULL
);

-- Sales sample (three rows from the sheet)
INSERT INTO Sales (rug_inventory_number, customer_id, sale_date, sale_price, sale_returned_date) VALUES
(1214, (SELECT customer_id FROM Customers WHERE customer_firstname='Gloria'  AND customer_lastname='Gomez'),   '2017-12-14',  990.00, NULL),
(1277, (SELECT customer_id FROM Customers WHERE customer_firstname='Bria'    AND customer_lastname='Le'),      '2017-12-24', 2400.00, NULL),
(1219, (SELECT customer_id FROM Customers WHERE customer_firstname='Meredith' AND customer_lastname='Spencer'), '2017-12-24', 40000.00, '2017-12-26');