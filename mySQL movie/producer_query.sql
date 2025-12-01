-- All producers with their names
SELECT p.producer_id, per.first_name, per.last_name, p.position
FROM producer p
JOIN person per ON p.person_id = per.person_id;

-- Producers earning more than a base pay
SELECT p.producer_id, per.first_name, per.last_name, per.base_pay
FROM producer p
JOIN person per ON p.person_id = per.person_id
WHERE per.base_pay > 160000;
