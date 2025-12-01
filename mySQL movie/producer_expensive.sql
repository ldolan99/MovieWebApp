-- First find the max cost for that year (say 2023)
WITH max_cost AS (
    SELECT MAX(cost) AS max_cost
    FROM movie
    WHERE YEAR(release_date) = 2023
),
expensive_movies AS (
    SELECT movie_id
    FROM movie, max_cost
    WHERE YEAR(release_date) = 2023
      AND cost = max_cost
),
producer_movie_count AS (
    SELECT mp.producer_id, COUNT(DISTINCT em.movie_id) AS cnt
    FROM movie_producer mp
    JOIN expensive_movies em ON mp.movie_id = em.movie_id
    GROUP BY mp.producer_id
),
total_expensive AS (
    SELECT COUNT(*) AS total_cnt FROM expensive_movies
)
SELECT p.producer_id, per.first_name, per.last_name
FROM producer_movie_count pmc
JOIN total_expensive te
    ON pmc.cnt = te.total_cnt
JOIN producer p      ON pmc.producer_id = p.producer_id
JOIN person per      ON p.person_id = per.person_id;
