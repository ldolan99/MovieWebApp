
CREATE DATABASE IF NOT EXISTS moviedb
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE moviedb;

DROP TABLE IF EXISTS movie_watch;
DROP TABLE IF EXISTS movie_producer;
DROP TABLE IF EXISTS movie_director;
DROP TABLE IF EXISTS movie_writer;
DROP TABLE IF EXISTS actress;
DROP TABLE IF EXISTS actor;
DROP TABLE IF EXISTS writer;
DROP TABLE IF EXISTS director;
DROP TABLE IF EXISTS producer;
DROP TABLE IF EXISTS movie;
DROP TABLE IF EXISTS person;

CREATE TABLE person (
    person_id   INT AUTO_INCREMENT PRIMARY KEY,
    first_name  VARCHAR(100) NOT NULL,
    last_name   VARCHAR(100) NOT NULL,
    pay         DECIMAL(12,2) DEFAULT 0,  -- total pay or base pay
    CONSTRAINT uq_person_name UNIQUE (first_name, last_name)
) ENGINE=InnoDB;

CREATE TABLE movie (
    movie_id     INT AUTO_INCREMENT PRIMARY KEY,
    title        VARCHAR(255) NOT NULL,
    release_date DATE NOT NULL,
    synopsis     TEXT,
    rating       VARCHAR(10),
    length_min   INT,
    category     VARCHAR(100),
    cost         DECIMAL(15,2) NOT NULL  -- production cost (for queries 3, 4, 8, 9)
) ENGINE=InnoDB;

CREATE INDEX idx_movie_year ON movie (release_date);
CREATE INDEX idx_movie_cost ON movie (cost);

CREATE TABLE producer (
    producer_id INT AUTO_INCREMENT PRIMARY KEY,
    person_id   INT NOT NULL,
    position    VARCHAR(100),
    CONSTRAINT fk_producer_person
      FOREIGN KEY (person_id)
      REFERENCES person(person_id)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
) ENGINE=InnoDB;


CREATE TABLE director (
    director_id INT AUTO_INCREMENT PRIMARY KEY,
    person_id   INT NOT NULL,
    position    VARCHAR(100),
    CONSTRAINT fk_director_person
      FOREIGN KEY (person_id)
      REFERENCES person(person_id)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE writer (
    writer_id    INT AUTO_INCREMENT PRIMARY KEY,
    person_id    INT NOT NULL,
    contribution VARCHAR(200),
    CONSTRAINT fk_writer_person
      FOREIGN KEY (person_id)
      REFERENCES person(person_id)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE actor (
    actor_id      INT AUTO_INCREMENT PRIMARY KEY,
    person_id     INT NOT NULL,
    movie_id      INT NOT NULL,
    role          VARCHAR(150) NOT NULL,
    pay_in_movie  DECIMAL(12,2),   -- allows query 6 if you want for actors too
    CONSTRAINT fk_actor_person
      FOREIGN KEY (person_id)
      REFERENCES person(person_id)
      ON UPDATE CASCADE
      ON DELETE RESTRICT,
    CONSTRAINT fk_actor_movie
      FOREIGN KEY (movie_id)
      REFERENCES movie(movie_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE INDEX idx_actor_movie ON actor(movie_id);

CREATE TABLE actress (
    actress_id    INT AUTO_INCREMENT PRIMARY KEY,
    person_id     INT NOT NULL,
    movie_id      INT NOT NULL,
    role          VARCHAR(150) NOT NULL,
    pay_in_movie  DECIMAL(12,2),   -- used directly in Query 6
    CONSTRAINT fk_actress_person
      FOREIGN KEY (person_id)
      REFERENCES person(person_id)
      ON UPDATE CASCADE
      ON DELETE RESTRICT,
    CONSTRAINT fk_actress_movie
      FOREIGN KEY (movie_id)
      REFERENCES movie(movie_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE INDEX idx_actress_movie ON actress(movie_id);


CREATE TABLE movie_producer (
    movie_id    INT NOT NULL,
    producer_id INT NOT NULL,
    PRIMARY KEY (movie_id, producer_id),
    CONSTRAINT fk_mvprod_movie
      FOREIGN KEY (movie_id)
      REFERENCES movie(movie_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
    CONSTRAINT fk_mvprod_producer
      FOREIGN KEY (producer_id)
      REFERENCES producer(producer_id)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE movie_director (
    movie_id    INT NOT NULL,
    director_id INT NOT NULL,
    PRIMARY KEY (movie_id, director_id),
    CONSTRAINT fk_mvd_movie
      FOREIGN KEY (movie_id)
      REFERENCES movie(movie_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
    CONSTRAINT fk_mvd_director
      FOREIGN KEY (director_id)
      REFERENCES director(director_id)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE movie_writer (
    movie_id  INT NOT NULL,
    writer_id INT NOT NULL,
    PRIMARY KEY (movie_id, writer_id),
    CONSTRAINT fk_mvw_movie
      FOREIGN KEY (movie_id)
      REFERENCES movie(movie_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
    CONSTRAINT fk_mvw_writer
      FOREIGN KEY (writer_id)
      REFERENCES writer(writer_id)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE movie_watch (
    movie_id    INT PRIMARY KEY,
    view_count  INT DEFAULT 0,
    CONSTRAINT fk_mvwatch_movie
      FOREIGN KEY (movie_id)
      REFERENCES movie(movie_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
) ENGINE=InnoDB;
