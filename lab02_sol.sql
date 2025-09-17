/* Lab 2 — Robert Nguyen
   Part 3: Create movie_ratings DB, build tables with PK/FK, insert sample rows,
           and display table definitions + contents. */

/* Comment out part 1-4
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
(1, 'The Hunt for Red October',         '1990-03-02', 'Action, Adventure, Thriller'),
(2, 'Lady Bird',                         '2017-12-01', 'Comedy, Drama'),
(3, 'Inception',                         '2010-08-16', 'Action, Adventure, Science Fiction'),
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

-- generate a report
SELECT consumer_first_name, consumer_last_name, movie_name, rating
  FROM movies
       NATURAL JOIN ratings
       NATURAL JOIN consumers;
*/


-- Part 5
/* ---------------------------------------------------------------------------
   Problem: movies.genre stores multiple comma-separated values ('Action, Adventure, Thriller').
   That is a multivalued, non-atomic attribute (violates 1NF) and makes searching/indexing/updating hard.
   Fix: remove genre from MOVIES, add a GENRES lookup and a MOVIE_GENRES junction (many-to-many).
--------------------------------------------------------------------------- */

DROP DATABASE IF EXISTS movie_ratings;
CREATE DATABASE movie_ratings;
USE movie_ratings;

-- MOVIES (no genre column now)
CREATE TABLE movies (
    movie_id     INT          AUTO_INCREMENT PRIMARY KEY,
    movie_name   VARCHAR(200) NOT NULL,
    release_date DATE         NOT NULL
);

-- GENRES lookup
CREATE TABLE genres (
    genre_id   INT         AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(50) NOT NULL UNIQUE
);

-- CONSUMERS (same as before)
CREATE TABLE consumers (
    consumer_id         INT          AUTO_INCREMENT PRIMARY KEY,
    consumer_first_name VARCHAR(50)  NOT NULL,
    consumer_last_name  VARCHAR(50)  NOT NULL,
    address             VARCHAR(100) NOT NULL,
    city                VARCHAR(50)  NOT NULL,
    state               CHAR(2)      NOT NULL,
    zip_code            CHAR(5)      NOT NULL
);

-- RATINGS (same as before)
CREATE TABLE ratings (
    movie_id    INT      NOT NULL,
    consumer_id INT      NOT NULL,
    when_rated  DATETIME NOT NULL,
    rating      TINYINT  NOT NULL,
    PRIMARY KEY (movie_id, consumer_id, when_rated),
    FOREIGN KEY (movie_id)    REFERENCES movies(movie_id)
                              ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (consumer_id) REFERENCES consumers(consumer_id)
                              ON DELETE CASCADE ON UPDATE CASCADE
);

-- MOVIE_GENRES junction (movies ↔ genres)
CREATE TABLE movie_genres (
    movie_id INT NOT NULL,
    genre_id INT NOT NULL,
    PRIMARY KEY (movie_id, genre_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
                           ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
                           ON DELETE CASCADE ON UPDATE CASCADE
);

-- sample data
INSERT INTO movies (movie_id, movie_name, release_date) VALUES
(1, 'The Hunt for Red October',       '1990-03-02'),
(2, 'Lady Bird',                      '2017-12-01'),
(3, 'Inception',                      '2010-08-16'),
(4, 'Monty Python and the Holy Grail','1975-04-03');

INSERT INTO consumers (consumer_id, consumer_first_name, consumer_last_name, address, city, state, zip_code) VALUES
(1, 'Toru',   'Okada',   '800 Glenridge Ave', 'Hobart',     'IN', '46343'),
(2, 'Kumiko', 'Okada',   '864 NW Bohemia St', 'Vincentown', 'NJ', '08088'),
(3, 'Noboru', 'Wataya',  '342 Joy Ridge St',  'Hermitage',  'TN', '37076'),
(4, 'May',    'Kasahara','5 Kent Rd',         'East Haven', 'CT', '06512');

INSERT INTO ratings (movie_id, consumer_id, when_rated, rating) VALUES
(1, 1, '2010-09-02 10:54:19', 4),
(1, 3, '2012-08-05 15:00:01', 3),
(1, 4, '2016-10-02 23:58:12', 1),
(2, 3, '2017-03-27 00:12:48', 2),
(2, 4, '2018-08-02 00:54:42', 4);

-- genres and mappings (normalized)
INSERT INTO genres (genre_id, genre_name) VALUES
(1, 'Action'), (2, 'Adventure'), (3, 'Thriller'),
(4, 'Comedy'), (5, 'Drama'), (6, 'Science Fiction');

INSERT INTO movie_genres (movie_id, genre_id) VALUES
(1, 1), (1, 2), (1, 3),
(2, 4), (2, 5),
(3, 1), (3, 2), (3, 6),
(4, 4);

SELECT * FROM movies;
SELECT * FROM genres;
SELECT * FROM movie_genres;

SELECT consumer_first_name, consumer_last_name, movie_name, rating
  FROM movies
       NATURAL JOIN ratings
       NATURAL JOIN consumers;
