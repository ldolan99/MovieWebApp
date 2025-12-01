USE moviedb;

SELECT COUNT(*) AS rows_in_movie FROM movie;
SELECT movie_id, title, release_date, rating, length_min, category, cost, synopsis
FROM movie;