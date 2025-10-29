DROP DATABASE IF EXISTS red_river_climbs;
CREATE DATABASE red_river_climbs;

USE red_river_climbs;

-- Who owns the various regions. In reality, this needs to be at crag level.
CREATE TABLE owners (
    owner_id INT AUTO_INCREMENT,
    owner_name  VARCHAR(64) NOT NULL,
    PRIMARY KEY (owner_id)
);

-- The regional locations of places to climb. Typically, this dictates where you park.
CREATE TABLE regions (
    region_id       INT AUTO_INCREMENT,
    region_name     VARCHAR(64),
    owner_id        INT DEFAULT 2, -- USFS more restrictive than RRGCC, encourages developer caution.
    PRIMARY KEY (region_id),
    FOREIGN KEY (owner_id) REFERENCES owners (owner_id) ON DELETE RESTRICT
);

-- Currently, no support for "sectors" i.e., "Bird Cage" is it's own crag.
CREATE TABLE crags (
    crag_id         INT AUTO_INCREMENT,
    crag_name       VARCHAR(64),
    region_id       INT,
    crag_approach   TEXT,
    PRIMARY KEY (crag_id),
    FOREIGN KEY (region_id) REFERENCES regions (region_id) ON DELETE NO ACTION -- Remove closed crags without deleting Route info; restore it if/when they open up
);

-- Systematize the grading scheme so that the DB can compare difficulties.
CREATE TABLE climb_grades (
    grade_id    INT AUTO_INCREMENT,
    grade_str   CHAR(5),
    PRIMARY KEY (grade_id)
);

CREATE TABLE climbs (
    climb_id                INT AUTO_INCREMENT,
    climb_name              VARCHAR(80) DEFAULT 'Open Project',
    grade_id                INT,
    crag_id                 INT,
    climb_len_ft            INT CHECK (climb_len_ft > 0), -- Climbs must not be stupidly short.
    climb_first_ascent_date DATE DEFAULT CURRENT_TIMESTAMP,
    climb_established_date  DATE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (climb_id),
    FOREIGN KEY (crag_id) REFERENCES crags (crag_id) ON DELETE NO ACTION,
    FOREIGN KEY (grade_id) REFERENCES climb_grades (grade_id) ON DELETE RESTRICT 
);

-- This is the subset table.
CREATE TABLE sport_climbs (
    climb_id            INT AUTO_INCREMENT,
    sport_climb_bolts   INT,
    PRIMARY KEY (climb_id),
    FOREIGN KEY (climb_id) REFERENCES climbs (climb_id) ON DELETE RESTRICT
);

-- Another subset table for traditional climbs.
CREATE TABLE trad_climbs (
    climb_id            INT AUTO_INCREMENT,
    trad_climb_descent  ENUM('rap from tree', 'walk off', 'rap rings'), -- Do as I say, not as I do.
    PRIMARY KEY (climb_id),
    FOREIGN KEY (climb_id) REFERENCES climbs (climb_id) ON DELETE RESTRICT
);



-- Create some views for convenience.
CREATE VIEW sport_climbs_view AS 
SELECT * 
  FROM climbs 
       INNER JOIN sport_climbs
       USING (climb_id); 

CREATE VIEW trad_climbs_view AS 
SELECT * 
  FROM climbs 
       NATURAL JOIN trad_climbs; -- Do as I say, not as I do.

CREATE VIEW mixed_climbs_view AS 
SELECT * FROM climbs 
         NATURAL JOIN sport_climbs 
         NATURAL JOIN trad_climbs;

-- If you're curious.
-- DESCRIBE sport_climbs_view;
-- DESCRIBE trad_climbs_view;

-- Store information about individual humans on the climbing scene, as climbers, developers.
CREATE TABLE climbers (
    climber_id              INT AUTO_INCREMENT,
    climber_first_name      VARCHAR(32),
    climber_last_name       VARCHAR(32),
    climber_email           VARCHAR(128) UNIQUE,
    climber_forum_handle    VARCHAR(32) UNIQUE, -- Website username.
    PRIMARY KEY (climber_id)
);

-- Relate climbers to the routes that they were the first to climb. FAs may consist of multiple people.
CREATE TABLE climber_first_ascents (
    climb_id            INT NOT NULL,
    climber_id          INT NOT NULL,   -- No NULLs; if you don't know who made the FA, don't include them in this table.
    PRIMARY KEY (climb_id, climber_id),
    FOREIGN KEY (climber_id) REFERENCES climbers (climber_id) ON DELETE NO ACTION,
    FOREIGN KEY (climb_id) REFERENCES climbs (climb_id) ON DELETE NO ACTION
);

-- Relate climbers to the routes that they established. Multiple names may be related to each climb.
CREATE TABLE climber_climbs_established (
    climb_id        INT NOT NULL,
    climber_id      INT NOT NULL,
    PRIMARY KEY (climb_id, climber_id),
    FOREIGN KEY (climb_id) REFERENCES climbs (climb_id) ON DELETE NO ACTION,
    FOREIGN KEY (climber_id) REFERENCES climbers (climber_id) ON DELETE NO ACTION
);


-- Populate the grades table with the needlessly complex grading scheme 
SOURCE dat/climb_grade_data.sql;

-- Populate owners table with preliminary list.
SOURCE dat/owner_data.sql;

-- Populate regions list with current regions list.
SOURCE dat/region_data.sql;

-- Populate climbers with some climbers.
SOURCE dat/climber_data.sql;

-- Populate the crags table with two regions's worth.
SOURCE dat/muir_valley_crag_data.sql;
SOURCE dat/miller_fork_crag_data.sql;

-- Populate the climbs table with some routes!
SOURCE dat/climb_data.sql;

-- Include logic for the complicated process that is adding a new route.
-- SOURCE logic/add_new_climb.sql;

-- Include example statements, some of which define views.
-- SOURCE examples/example_queries.sql;
-- SOURCE examples/having_example.sql;
-- SOURCE examples/home_page_table.sql;
-- SOURCE examples/monastery_hist_query.sql;
-- SOURCE examples/name_to_climber_id.sql;

-- Comments have to be EXACTLY THIS FORMAT FOR MY SILLY REFORMATTING TOOL TO WORK.
-- Two dashes, one space, SOURCE ...

	