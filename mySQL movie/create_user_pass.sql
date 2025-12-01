DROP USER IF EXISTS 'movieuser'@'localhost';
FLUSH PRIVILEGES;

CREATE USER 'movieuser'@'localhost' IDENTIFIED BY 'moviepass';
GRANT ALL PRIVILEGES ON moviedb.* TO 'movieuser'@'localhost';
FLUSH PRIVILEGES;

