SELECT a.actress_id, per.first_name, per.last_name
FROM actress a
JOIN person per ON a.person_id = per.person_id
WHERE NOT EXISTS (
    SELECT 1
    FROM movie_actress ma
    JOIN movie_producer mp ON ma.movie_id = mp.movie_id
    WHERE ma.actress_id = a.actress_id
      AND mp.producer_id = ?
);
