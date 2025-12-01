-- remove any broken version of the user
DROP USER IF EXISTS 'movieuser'@'localhost';
FLUSH PRIVILEGES;

-- create a fresh user with a known password
CREATE USER 'movieuser'@'localhost'
  IDENTIFIED BY 'moviepass';

-- give that user full rights on moviedb
GRANT ALL PRIVILEGES ON moviedb.* TO 'movieuser'@'localhost';

FLUSH PRIVILEGES;
