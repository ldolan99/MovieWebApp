USE moviedb;

DELETE FROM movie;   -- or TRUNCATE TABLE movie; if FK constraints allow it

INSERT INTO movie (title, release_date, synopsis, rating, length_min, category, cost) VALUES
  ('Wolf Of Wall Street', '2013', 'Based on the true story of Jordan Belfort, from his rise to a wealthy stock-broker living the high life to his fall involving crime, corruption and the federal government.', 'R', 180, 'Action', 80000000.00),
  ('The Notebook',       '2004', 'An elderly man reads to a woman with dementia the story of two young lovers whose romance is threatened by the difference in their respective social classes.',   'PG-13',    121, 'Romance', 30000000.00),
  ('Interstellar',        '2014', 'When Earth becomes uninhabitable, a farmer and ex-NASA pilot, Joseph Cooper, is tasked to pilot...', 'PG-13', 169, 'Sci-Fi', 165000000.00);
