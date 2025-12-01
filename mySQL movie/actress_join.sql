-- Actors in a movie
SELECT 'Actor' AS role_type, per.first_name, per.last_name
FROM movie_actor ma
JOIN actor a  ON ma.actor_id = a.actor_id
JOIN person per ON a.person_id = per.person_id
WHERE ma.movie_id = 1 
UNION ALL
-- Actresses in the same movie
SELECT 'Actress' AS role_type, per.first_name, per.last_name
FROM movie_actress mf
JOIN actress a  ON mf.actress_id = a.actress_id
JOIN person per ON a.person_id = per.person_id
WHERE mf.movie_id = 1;
