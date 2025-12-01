USE moviedb;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE movie_watch;
TRUNCATE TABLE movie_producer;
TRUNCATE TABLE movie_director;
TRUNCATE TABLE movie_writer;
TRUNCATE TABLE actress;
TRUNCATE TABLE actor;
TRUNCATE TABLE writer;
TRUNCATE TABLE director;
TRUNCATE TABLE producer;
TRUNCATE TABLE movie;
TRUNCATE TABLE person;
SET FOREIGN_KEY_CHECKS = 1;


INSERT INTO person (first_name, last_name, pay) VALUES
  -- Wolf of Wall Street
  ('Leonardo',  'DiCaprio',      12000000.00),  -- 1 actor
  ('Jonah',     'Hill',           6000000.00),  -- 2 actor
  ('Margot',    'Robbie',         5000000.00),  -- 3 actress
  ('Matthew',   'McConaughey',    8000000.00),  -- 4 actor
  ('Martin',    'Scorsese',      20000000.00),  -- 5 director
  ('Emma',      'Tillinger Koskoff', 7000000.00), -- 6 producer
  ('Terence',   'Winter',         4000000.00),  -- 7 writer

  -- Nolan / Interstellar / Inception
  ('Christopher','Nolan',        22000000.00),  -- 8 director/writer
  ('Anne',      'Hathaway',       9000000.00),  -- 9 actress
  ('Jessica',   'Chastain',       7000000.00),  -- 10 actress
  ('Lynda',     'Obst',           5000000.00),  -- 11 producer
  ('Jonathan',  'Nolan',          5000000.00),  -- 12 writer
  ('Emma',      'Thomas',         9000000.00),  -- 13 producer

  -- Forrest Gump
  ('Robert',    'Zemeckis',      15000000.00),  -- 14 director
  ('Tom',       'Hanks',         15000000.00),  -- 15 actor
  ('Robin',     'Wright',         7000000.00),  -- 16 actress
  ('Eric',      'Roth',           4000000.00),  -- 17 writer
  ('Wendy',     'Finerman',       5000000.00),  -- 18 producer

  -- Pulp Fiction
  ('Quentin',   'Tarantino',     18000000.00),  -- 19 director/writer
  ('John',      'Travolta',       9000000.00),  -- 20 actor
  ('Samuel',    'Jackson',        8000000.00),  -- 21 actor
  ('Uma',       'Thurman',        7000000.00),  -- 22 actress
  ('Lawrence',  'Bender',         6000000.00),  -- 23 producer
  ('Roger',     'Avary',          3000000.00);  -- 24 writer


-- Directors
INSERT INTO director (person_id) VALUES
  (5),   -- 1: Martin Scorsese
  (8),   -- 2: Christopher Nolan
  (14),  -- 3: Robert Zemeckis
  (19);  -- 4: Quentin Tarantino

-- Producers
INSERT INTO producer (person_id) VALUES
  (6),   -- 1: Emma Tillinger Koskoff
  (11),  -- 2: Lynda Obst
  (13),  -- 3: Emma Thomas
  (18),  -- 4: Wendy Finerman
  (23);  -- 5: Lawrence Bender

-- Writers
INSERT INTO writer (person_id) VALUES
  (7),   -- 1: Terence Winter
  (12),  -- 2: Jonathan Nolan
  (8),   -- 3: Christopher Nolan
  (17),  -- 4: Eric Roth
  (19),  -- 5: Quentin Tarantino
  (24);  -- 6: Roger Avary


INSERT INTO movie
  (title, release_date, synopsis, rating, length_min, category, cost)
VALUES
  ('The Wolf of Wall Street',
   '2013-12-25',
   'A stockbroker rises and falls through fraud and excess on Wall Street.',
   'R', 180, 'Biography', 100000000.00),   -- movie_id 1

  ('Interstellar',
   '2014-11-07',
   'Explorers travel through a wormhole in space in an attempt to save humanity.',
   'PG-13', 169, 'Sci-Fi', 165000000.00),  -- movie_id 2

  ('Inception',
   '2010-07-16',
   'A thief enters people''s dreams to steal corporate secrets.',
   'PG-13', 148, 'Sci-Fi', 160000000.00),  -- movie_id 3

  ('Forrest Gump',
   '1994-07-06',
   'The life story of Forrest Gump, a slow-witted but kind-hearted man.',
   'PG-13', 142, 'Drama', 55000000.00),    -- movie_id 4

  ('Pulp Fiction',
   '1994-10-14',
   'The lives of two mob hitmen, a boxer, and others intertwine in Los Angeles.',
   'R', 154, 'Crime', 8000000.00);         -- movie_id 5


-- movie_producer (movie_id, producer_id)
INSERT INTO movie_producer (movie_id, producer_id) VALUES
  (1, 1),        -- Wolf of Wall Street  ← Emma Tillinger Koskoff
  (2, 2),        -- Interstellar         ← Lynda Obst
  (2, 3),        -- Interstellar         ← Emma Thomas
  (3, 3),        -- Inception            ← Emma Thomas
  (4, 4),        -- Forrest Gump         ← Wendy Finerman
  (5, 5);        -- Pulp Fiction         ← Lawrence Bender

-- movie_director (movie_id, director_id)
INSERT INTO movie_director (movie_id, director_id) VALUES
  (1, 1),        -- Wolf of Wall Street  ← Scorsese
  (2, 2),        -- Interstellar         ← Nolan
  (3, 2),        -- Inception            ← Nolan
  (4, 3),        -- Forrest Gump         ← Zemeckis
  (5, 4);        -- Pulp Fiction         ← Tarantino

-- movie_writer (movie_id, writer_id)
INSERT INTO movie_writer (movie_id, writer_id) VALUES
  (1, 1),        -- Wolf of Wall Street  ← Terence Winter
  (2, 2),        -- Interstellar         ← Jonathan Nolan
  (2, 3),        -- Interstellar         ← Christopher Nolan
  (3, 3),        -- Inception            ← Christopher Nolan
  (4, 4),        -- Forrest Gump         ← Eric Roth
  (5, 5),        -- Pulp Fiction         ← Quentin Tarantino
  (5, 6);        -- Pulp Fiction         ← Roger Avary


-- ACTORS
INSERT INTO actor (person_id, movie_id, role, pay_in_movie) VALUES
  -- The Wolf of Wall Street
  (1, 1, 'Jordan Belfort', 10000000.00),   -- Leonardo DiCaprio
  (2, 1, 'Donnie Azoff',   5000000.00),    -- Jonah Hill
  (4, 1, 'Mark Hanna',     1000000.00),    -- Matthew McConaughey

  -- Interstellar
  (4, 2, 'Cooper',         8000000.00),    -- Matthew McConaughey

  -- Inception
  (1, 3, 'Dom Cobb',       8000000.00),    -- Leonardo DiCaprio

  -- Forrest Gump
  (15, 4, 'Forrest Gump',  7000000.00),    -- Tom Hanks

  -- Pulp Fiction
  (20, 5, 'Vincent Vega',  4000000.00),    -- John Travolta
  (21, 5, 'Jules Winnfield',3500000.00);   -- Samuel L. Jackson

-- ACTRESSES
INSERT INTO actress (person_id, movie_id, role, pay_in_movie) VALUES
  -- The Wolf of Wall Street
  (3, 1, 'Naomi Lapaglia', 3000000.00),    -- Margot Robbie

  -- Interstellar
  (9, 2, 'Brand',          5000000.00),    -- Anne Hathaway
  (10,2, 'Murph',          3000000.00),    -- Jessica Chastain

  -- Forrest Gump
  (16,4, 'Jenny Curran',   4000000.00),    -- Robin Wright

  -- Pulp Fiction
  (22,5, 'Mia Wallace',    2500000.00);    -- Uma Thurman


INSERT INTO movie_watch (movie_id, view_count) VALUES
  (1, 1200000),   -- Wolf of Wall Street
  (2,  900000),   -- Interstellar
  (3, 1500000),   -- Inception
  (4, 1100000),   -- Forrest Gump
  (5, 1300000);   -- Pulp Fiction
