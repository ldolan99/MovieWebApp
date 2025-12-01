-- ==========================================================
-- 1. Create database and select it
-- ==========================================================
CREATE DATABASE IF NOT EXISTS moviedb
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE moviedb;

-- ==========================================================
-- 2. Core tables
-- ==========================================================

-- PERSON: base entity for actor/actress/producer/director/writer
CREATE TABLE person (
    person_id   INT AUTO_INCREMENT PRIMARY KEY,
    first_name  VARCHAR(50) NOT NULL,
    last_name   VARCHAR(50) NOT NULL,
    base_pay    DECIMAL(12,2) DEFAULT 0.00,   -- general pay rate
    CONSTRAINT uq_person_name UNIQUE (first_name, last_name)
) ENGINE=InnoDB;

-- MOVIE
CREATE TABLE movie (
    movie_id      INT AUTO_INCREMENT PRIMARY KEY,
    title         VARCHAR(200) NOT NULL,
    release_date  DATE NOT NULL,
    synopsis      TEXT,
    rating        VARCHAR(10),                -- e.g. G, PG, PG-13, R
    length_min    INT,                        -- in minutes
    category      VARCHAR(50),                -- e.g. Action, Drama
    cost          DECIMAL(12,2) NOT NULL,     -- to support "most expensive"
    CONSTRAINT uq_movie_title_release UNIQUE (title, release_date)
) ENGINE=InnoDB;

CREATE INDEX idx_movie_release_date ON movie (release_date);
CREATE INDEX idx_movie_cost ON movie (cost);

-- ==========================================================
-- 3. Role tables (subtypes of person)
-- ==========================================================

-- PRODUCER
CREATE TABLE producer (
    producer_id INT AUTO_INCREMENT PRIMARY KEY,
    person_id   INT NOT NULL,
    position    VARCHAR(50),
    CONSTRAINT fk_producer_person
        FOREIGN KEY (person_id) REFERENCES person(person_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- DIRECTOR
CREATE TABLE director (
    director_id INT AUTO_INCREMENT PRIMARY KEY,
    person_id   INT NOT NULL,
    position    VARCHAR(50),
    CONSTRAINT fk_director_person
        FOREIGN KEY (person_id) REFERENCES person(person_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- WRITER
CREATE TABLE writer (
    writer_id    INT AUTO_INCREMENT PRIMARY KEY,
    person_id    INT NOT NULL,
    contribution VARCHAR(100),
    CONSTRAINT fk_writer_person
        FOREIGN KEY (person_id) REFERENCES person(person_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ACTOR
CREATE TABLE actor (
    actor_id INT AUTO_INCREMENT PRIMARY KEY,
    person_id INT NOT NULL,
    role      VARCHAR(100),
    CONSTRAINT fk_actor_person
        FOREIGN KEY (person_id) REFERENCES person(person_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ACTRESS
CREATE TABLE actress (
    actress_id INT AUTO_INCREMENT PRIMARY KEY,
    person_id  INT NOT NULL,
    role       VARCHAR(100),
    CONSTRAINT fk_actress_person
        FOREIGN KEY (person_id) REFERENCES person(person_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ==========================================================
-- 4. Association tables (Movie <-> Roles)
-- ==========================================================

-- Movies produced by producers
CREATE TABLE movie_producer (
    movie_id    INT NOT NULL,
    producer_id INT NOT NULL,
    PRIMARY KEY (movie_id, producer_id),
    CONSTRAINT fk_mp_movie
        FOREIGN KEY (movie_id) REFERENCES movie(movie_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_mp_producer
        FOREIGN KEY (producer_id) REFERENCES producer(producer_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Movies directed by directors
CREATE TABLE movie_director (
    movie_id    INT NOT NULL,
    director_id INT NOT NULL,
    PRIMARY KEY (movie_id, director_id),
    CONSTRAINT fk_md_movie
        FOREIGN KEY (movie_id) REFERENCES movie(movie_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_md_director
        FOREIGN KEY (director_id) REFERENCES director(director_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Movies written by writers
CREATE TABLE movie_writer (
    movie_id  INT NOT NULL,
    writer_id INT NOT NULL,
    PRIMARY KEY (movie_id, writer_id),
    CONSTRAINT fk_mw_movie
        FOREIGN KEY (movie_id) REFERENCES movie(movie_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_mw_writer
        FOREIGN KEY (writer_id) REFERENCES writer(writer_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Actors in movies (include pay for that specific movie)
CREATE TABLE movie_actor (
    movie_id   INT NOT NULL,
    actor_id   INT NOT NULL,
    pay_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (movie_id, actor_id),
    CONSTRAINT fk_ma_movie
        FOREIGN KEY (movie_id) REFERENCES movie(movie_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_ma_actor
        FOREIGN KEY (actor_id) REFERENCES actor(actor_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Actresses in movies (include pay for that specific movie)
CREATE TABLE movie_actress (
    movie_id   INT NOT NULL,
    actress_id INT NOT NULL,
    pay_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (movie_id, actress_id),
    CONSTRAINT fk_mf_movie
        FOREIGN KEY (movie_id) REFERENCES movie(movie_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_mf_actress
        FOREIGN KEY (actress_id) REFERENCES actress(actress_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ==========================================================
-- 5. Theatre & Screening to support transactions 3 & 4
-- ==========================================================

CREATE TABLE theatre (
    theatre_id INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    location   VARCHAR(200)
) ENGINE=InnoDB;

CREATE TABLE screening (
    screening_id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id     INT NOT NULL,
    theatre_id   INT NOT NULL,
    start_time   DATETIME NOT NULL,
    status       ENUM('COMING_SOON', 'SCREENED', 'PLAYING') NOT NULL DEFAULT 'COMING_SOON',
    CONSTRAINT fk_screening_movie
        FOREIGN KEY (movie_id) REFERENCES movie(movie_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_screening_theatre
        FOREIGN KEY (theatre_id) REFERENCES theatre(theatre_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE INDEX idx_screening_movie ON screening (movie_id);
CREATE INDEX idx_screening_theatre ON screening (theatre_id);

-- ==========================================================
-- 6. Sample data (at least two rows per table)
-- ==========================================================

-- PERSON
INSERT INTO person (first_name, last_name, base_pay) VALUES
('John',   'Producer', 150000.00),
('Emily',  'Producer', 180000.00),
('Steven', 'Director', 200000.00),
('Nolan',  'Director', 250000.00),
('Alice',  'Writer',   90000.00),
('Bob',    'Writer',   95000.00),
('Tom',    'Actor',    120000.00),
('Chris',  'Actor',    110000.00),
('Emma',   'Actress',  130000.00),
('Scarlett','Actress', 140000.00);

-- MOVIE
INSERT INTO movie (title, release_date, synopsis, rating, length_min, category, cost) VALUES
('Wolf Of Wall Street', '2013', 'Based on the true story of Jordan Belfort, from his rise to a wealthy stock-broker living the high life to his fall involving crime, corruption and the federal government.', 'R', 180, 'Action', 80000000.00),
('The Notebook', '2004', 'An elderly man reads to a woman with dementia the story of two young lovers whose romance is threatened by the difference in their respective social classes.', 'PG-13', 121, 'Romance', 30000000.00),
('Interstellar', '2014', 'When Earth becomes uninhabitable in the future, a farmer and ex-NASA pilot, Joseph Cooper, is tasked to pilot a spacecraft, along with a team of researchers, to find a new planet for humans..', 'PG-13', 134, 'Sci-Fi', 120000000.00);

-- PRODUCER
-- Assume person_id 1 and 2 are producers
INSERT INTO producer (person_id, position) VALUES
(1, 'Executive Producer'),
(2, 'Line Producer');

-- DIRECTOR
-- Assume person_id 3 and 4 are directors
INSERT INTO director (person_id, position) VALUES
(3, 'Director'),
(4, 'Director');

-- WRITER
-- Assume person_id 5 and 6 are writers
INSERT INTO writer (person_id, contribution) VALUES
(5, 'Screenplay'),
(6, 'Story');

-- ACTOR
-- Assume person_id 7 and 8 are actors
INSERT INTO actor (person_id, role) VALUES
(7, 'Lead Actor'),
(8, 'Supporting Actor');

-- ACTRESS
-- Assume person_id 9 and 10 are actresses
INSERT INTO actress (person_id, role) VALUES
(9,  'Lead Actress'),
(10, 'Supporting Actress');

-- MOVIE_PRODUCER (link movies to producers)
-- Action Blast produced by both producers
INSERT INTO movie_producer (movie_id, producer_id) VALUES
(1, 1),
(1, 2),
(2, 2),
(3, 1);

-- MOVIE_DIRECTOR
INSERT INTO movie_director (movie_id, director_id) VALUES
(1, 1),
(2, 2),
(3, 2);

-- MOVIE_WRITER
INSERT INTO movie_writer (movie_id, writer_id) VALUES
(1, 1),
(1, 2),
(2, 1),
(3, 2);

-- MOVIE_ACTOR
INSERT INTO movie_actor (movie_id, actor_id, pay_amount) VALUES
(1, 1, 5000000.00),   -- Tom in Action Blast
(1, 2, 2000000.00),   -- Chris in Action Blast
(2, 1, 3000000.00),   -- Tom in Romantic Tale
(3, 2, 4000000.00);   -- Chris in SciFi Epic

-- MOVIE_ACTRESS
INSERT INTO movie_actress (movie_id, actress_id, pay_amount) VALUES
(1, 1, 6000000.00),   -- Emma in Action Blast
(1, 2, 2500000.00),   -- Scarlett in Action Blast
(2, 1, 3500000.00),   -- Emma in Romantic Tale
(3, 2, 7000000.00);   -- Scarlett in SciFi Epic

-- THEATRE
INSERT INTO theatre (name, location) VALUES
('Downtown Cinema', 'City Center'),
('Grand Multiplex', 'Mall District');

-- SCREENING
-- Movie 1 (Action Blast) coming soon and screened
INSERT INTO screening (movie_id, theatre_id, start_time, status) VALUES
(1, 1, '2024-06-01 19:00:00', 'COMING_SOON'),
(1, 1, '2024-06-10 19:00:00', 'SCREENED'),
(2, 2, '2024-06-05 20:00:00', 'COMING_SOON'),
(3, 1, '2024-09-01 18:00:00', 'COMING_SOON');

SHOW WARNINGS;