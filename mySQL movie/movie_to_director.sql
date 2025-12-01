SELECT m.movie_id, m.title, m.release_date
FROM movie m
JOIN movie_director md ON m.movie_id = md.movie_id
WHERE md.director_id = 2;
