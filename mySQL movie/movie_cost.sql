SELECT m.movie_id, m.title, m.cost
FROM movie m
JOIN movie_producer mp ON m.movie_id = mp.movie_id
WHERE mp.producer_id = ?
ORDER BY m.cost DESC
LIMIT 1;
