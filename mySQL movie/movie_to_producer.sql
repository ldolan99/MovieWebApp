SELECT m.movie_id, m.title, m.release_date
FROM movie m
JOIN movie_producer mp ON m.movie_id = mp.movie_id
WHERE mp.producer_id = 1;   -- replace ? with specific producer_id
