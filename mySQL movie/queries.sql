USE moviedb;

-- 1) List all the movies produced by a given producer (by name)
SELECT m.*
FROM movie m
JOIN movie_producer mp  ON m.movie_id = mp.movie_id
JOIN producer p         ON mp.producer_id = p.producer_id
JOIN person per         ON p.person_id = per.person_id
WHERE per.first_name = 'Emma' AND per.last_name = 'Thomas';

-- 2) List all the movies that were directed by a given director
SELECT m.*
FROM movie m
JOIN movie_director md  ON m.movie_id = md.movie_id
JOIN director d         ON md.director_id = d.director_id
JOIN person per         ON d.person_id = per.person_id
WHERE per.first_name = 'Christopher' AND per.last_name = 'Nolan';

-- 3) Find the most expensive movie a producer ever produced
SELECT per.first_name, per.last_name, m.title, m.cost
FROM movie m
JOIN movie_producer mp  ON m.movie_id = mp.movie_id
JOIN producer p         ON mp.producer_id = p.producer_id
JOIN person per         ON p.person_id = per.person_id
WHERE p.producer_id = 1
ORDER BY m.cost DESC
LIMIT 1;

-- 4) Find all the movies that were produced in the same year (grouped by year)
SELECT YEAR(m.release_date) AS release_year,
       GROUP_CONCAT(m.title ORDER BY m.title SEPARATOR ', ') AS movies_in_year
FROM movie m
GROUP BY YEAR(m.release_date)
HAVING COUNT(*) > 1;

-- 5) Find actresses who do NOT join a movie produced by a given producer
SELECT DISTINCT per.first_name, per.last_name
FROM actress a
JOIN person per ON a.person_id = per.person_id
WHERE NOT EXISTS (
    SELECT 1
    FROM movie_producer mp
    WHERE mp.movie_id = a.movie_id
      AND mp.producer_id = 1
);

-- 6) Find the highest amount of money earned by an actress in a movie
SELECT per.first_name, per.last_name, m.title, a.pay_in_movie
FROM actress a
JOIN person per ON a.person_id = per.person_id
JOIN movie m    ON a.movie_id = m.movie_id
ORDER BY a.pay_in_movie DESC
LIMIT 1;

-- 7) Find actors and actresses who joined a movie (by movie title)
SELECT m.title,
       'Actor' AS type,
       CONCAT(per.first_name, ' ', per.last_name) AS performer,
       a.role
FROM movie m
JOIN actor a   ON m.movie_id = a.movie_id
JOIN person per ON a.person_id = per.person_id
WHERE m.title = 'Interstellar'

UNION ALL

SELECT m.title,
       'Actress' AS type,
       CONCAT(per.first_name, ' ', per.last_name) AS performer,
       ac.role
FROM movie m
JOIN actress ac ON m.movie_id = ac.movie_id
JOIN person per ON ac.person_id = per.person_id
WHERE m.title = 'Interstellar';

-- 8) List all the movies below a price directed by a director
SELECT m.*
FROM movie m
JOIN movie_director md ON m.movie_id = md.movie_id
JOIN director d        ON md.director_id = d.director_id
JOIN person per        ON d.person_id = per.person_id
WHERE per.first_name = 'Christopher'
  AND per.last_name  = 'Nolan'
  AND m.cost < 200000000.00;

-- 9) List producers who produced all the most expensive movies in a given year
WITH max_cost_per_year AS (
    SELECT YEAR(release_date) AS yr,
           MAX(cost) AS max_cost
    FROM movie
    WHERE YEAR(release_date) = 2014
    GROUP BY YEAR(release_date)
),
most_expensive_movies AS (
    SELECT m.movie_id
    FROM movie m
    JOIN max_cost_per_year mc
      ON YEAR(m.release_date) = mc.yr
     AND m.cost = mc.max_cost
)
SELECT DISTINCT per.first_name, per.last_name
FROM producer p
JOIN person per        ON p.person_id = per.person_id
JOIN movie_producer mp ON p.producer_id = mp.producer_id
WHERE mp.movie_id IN (SELECT movie_id FROM most_expensive_movies);

-- 10) Find movies that people are "more watching" for an actor or actress
SELECT m.title, mw.view_count
FROM movie m
JOIN movie_watch mw ON m.movie_id = mw.movie_id
JOIN actor a        ON m.movie_id = a.movie_id
WHERE a.person_id = 3
ORDER BY mw.view_count DESC;

-- Same idea for an actress (person_id = 5)
SELECT m.title, mw.view_count
FROM movie m
JOIN movie_watch mw ON m.movie_id = mw.movie_id
JOIN actress a      ON m.movie_id = a.movie_id
WHERE a.person_id = 5
ORDER BY mw.view_count DESC;
