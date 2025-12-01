SELECT m.movie_id, m.title, m.cost
FROM movie m
JOIN movie_director md ON m.movie_id = md.movie_id
WHERE md.director_id = ?
  AND m.cost < ?;
