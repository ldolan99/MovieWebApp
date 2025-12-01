SELECT per.first_name, per.last_name, m.title, ma.pay_amount
FROM movie_actress ma
JOIN actress a      ON ma.actress_id = a.actress_id
JOIN person per     ON a.person_id = per.person_id
JOIN movie m        ON ma.movie_id = m.movie_id
ORDER BY ma.pay_amount DESC
LIMIT 1;
