INSERT INTO climbs (climb_name, grade_id, crag_id, climb_len_ft, climb_first_ascent_date, climb_established_date)
    VALUES ('Grand Bohemian',       12, 44, 70, '2004-1-1', '1998-9-2'),-- 1 sport
           ('Nomad',                12, 44, 75, '2013-1-1', NULL),      -- 2 sport
           ('Mission Creep',        11, 44, 60, NULL, '     2013-1-1'), -- 3 sport
           ('The Heretic',           8, 44, 45, NULL,       NULL),      -- 4 trad
           ('Spork',                11, 44, 70, NULL,       NULL),      -- 5 mixed route, with elements of sport AND trad.
           ('Vagabond',             12, 44, 65, NULL,       '2013-1-1'),-- 6 
           ('Parajna',              12, 44, 50, NULL,       NULL),      -- 7
           ('Licifer''s Unicycle',  10, 44, 60, '2014-1-1', '2014-1-1'),-- 8
           ('Choss Gully Wrangling', 8, 44, 80, NULL,       NULL),      -- 9
           ('Return to Balance',    11, 22, 50, '2005-1-1', '2003-8-2'),-- 10
           ('Child of the Earth',   12, 22, 60, NULL,       NULL),      -- 11
           ('Sacred Stones',        11,	22, 65, NULL,       NULL),      -- 12
           ('Go West',	             7,	22, 70, NULL,       NULL),      -- 13 trad
           ('Flash Point',          12,	22, 45, NULL,       NULL),      -- 14 trad
           ('Strip the Willows',    11, 22, 80, NULL,       NULL),      -- 15
           ('Thrillbillies',        10,	22, 90, NULL,       NULL),      -- 16
           ('Iron Lung',            12, 22, 50, NULL,       NULL),      -- 17
           ('Narcissus',            13, 44, 40, '2014-1-1', '2013-1-1');-- 18

INSERT INTO sport_climbs (climb_id, sport_climb_bolts)
    VALUES ( 1, 10), -- Grand Bohemian has 10 bolts,
           ( 5,  4), -- Spork has 4 bolts.
           (10,  5),
           (11,  6),
           (12,  7),
           (15,  8),
           (16,  9),
           (17,  6);

INSERT INTO trad_climbs (climb_id, trad_climb_descent)
    VALUES ( 4, 'rap rings'),      -- The Heretic has a bolt anchor to descend on.
           ( 5, 'rap rings'),      -- Spork has a bolt anchor to descend on.
           (13, 'rap rings'),
           (14, 'rap rings');


INSERT INTO climber_first_ascents (climber_id, climb_id)
    VALUES (2, 1),
           (2, 2),
           (54, 8),
           (55, 8),
           (56, 10),
           (57, 10),
           (58, 10),
           (54, 18),
           (55, 18);

-- TODO: Move estab dates to climbs INSERT.
INSERT INTO climber_climbs_established (climb_id, climber_id)
    VALUES ( 1,  1),
           (10,  1),
           ( 8, 54),
           ( 3,  2),
           ( 6,  2),
           (18, 54),
           (18, 55);

-- Q: Can we insert into a view? 
-- A: "Can not modify more than one base table through a join view"