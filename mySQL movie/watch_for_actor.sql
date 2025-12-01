SELECT m.movie_id,
       m.title,
       COUNT(DISTINCT ma.actor_id) + COUNT(DISTINCT mf.actress_id) AS cast_count
FROM movie m
LEFT JOIN movie_actor ma   ON m.movie_id = ma.movie_id
LEFT JOIN movie_actress mf ON m.movie_id = mf.movie_id
GROUP BY m.movie_id, m.title
ORDER BY cast_count DESC;
