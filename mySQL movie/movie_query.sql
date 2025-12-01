-- All movies
SELECT * FROM movie;

-- Movies released in 2023
SELECT * FROM movie
WHERE YEAR(release_date) = 2023;
