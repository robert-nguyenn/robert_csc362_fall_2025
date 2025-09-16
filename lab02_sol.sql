/* Lab 2 — Robert Nguyen
   Part 3: Create movie_ratings DB, build tables with PK/FK, insert sample rows,
           and display table definitions + contents. */

-- start clean
DROP DATABASE IF EXISTS movie_ratings;
CREATE DATABASE movie_ratings;
USE movie_ratings;

-- MOVIES
CREATE TABLE movies (
    movie_id     INT           AUTO_INCREMENT PRIMARY KEY,
    movie_name   VARCHAR(200)  NOT NULL,
    release_date DATE          NOT NULL,
    genre        VARCHAR(200)  NOT NULL
);

-- CONSUMERS
CREATE TABLE consumers (
    consumer_id         INT           AUTO_INCREMENT PRIMARY KEY,
    consumer_first_name VARCHAR(50)   NOT NULL,
    consumer_last_name  VARCHAR(50)   NOT NULL,
    address             VARCHAR(100)  NOT NULL,
    city                VARCHAR(50)   NOT NULL,
    state               CHAR(2)       NOT NULL,
    zip_code            CHAR(5)       NOT NULL
);

-- RATINGS (links movies ↔ consumers)
CREATE TABLE ratings (
    movie_id    INT       NOT NULL,
    consumer_id INT       NOT NULL,
    when_rated  DATETIME  NOT NULL,
    rating      TINYINT   NOT NULL,
    PRIMARY KEY (movie_id, consumer_id, when_rated),
    FOREIGN KEY (movie_id)    REFERENCES movies(movie_id)
                              ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (consumer_id) REFERENCES consumers(consumer_id)
                              ON DELETE CASCADE ON UPDATE CASCADE
);

-- check table definitions
SHOW CREATE TABLE movies;
SHOW CREATE TABLE consumers;
SHOW CREATE TABLE ratings;

-- sample data (exactly as in the prompt)

INSERT INTO movies (movie_id, movie_name, release_date, genre) VALUES
(1, 'The Hunt for Red October',         '1990-03-02', 'Acton, Adventure, Thriller'),
(2, 'Lady Bird',                         '2017-12-01', 'Comedy, Drama'),
(3, 'Inception',                         '2010-08-16', 'Acton, Adventure, Science Fiction'),
(4, 'Monty Python and the Holy Grail',   '1975-04-03', 'Comedy');

INSERT INTO consumers (consumer_id, consumer_first_name, consumer_last_name, address, city, state, zip_code) VALUES
(1, 'Toru',   'Okada',   '800 Glenridge Ave',  'Hobart',     'IN', '46343'),
(2, 'Kumiko', 'Okada',   '864 NW Bohemia St',  'Vincentown', 'NJ', '08088'),
(3, 'Noboru', 'Wataya',  '342 Joy Ridge St',   'Hermitage',  'TN', '37076'),
(4, 'May',    'Kasahara','5 Kent Rd',          'East Haven', 'CT', '06512');

INSERT INTO ratings (movie_id, consumer_id, when_rated, rating) VALUES
(1, 1, '2010-09-02 10:54:19', 4),
(1, 3, '2012-08-05 15:00:01', 3),
(1, 4, '2016-10-02 23:58:12', 1),
(2, 3, '2017-03-27 00:12:48', 2),
(2, 4, '2018-08-02 00:54:42', 4);

-- show contents
SELECT * FROM movies;
SELECT * FROM consumers;
SELECT * FROM ratings;
