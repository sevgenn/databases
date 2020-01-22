/* 2) Создайте базу данных example, разместите в ней таблицу users,
      состоящую из двух столбцов, числового id и строкового name.*/

-- Создание базы example с предварительным контрольным удалением ранее существующей одноименной базы.
-- Создание и заполнение таблицы users.
-- Вывод таблицы.

DROP DATABASE IF EXISTS example;
CREATE DATABASE example;

USE example;

CREATE TABLE IF NOT EXISTS users (
  id int(10) AUTO_INCREMENT,
  name varchar(20) NOT NULL,
  PRIMARY KEY (id)
);

INSERT INTO users (name) VALUES
  ('Zuckerberg'),
  ('Gates'),
  ('Marx'),
  ('Engels');
 
 SELECT * FROM users;
