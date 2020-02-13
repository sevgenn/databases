-- Заполнение таблиц iorders и orders_products:
INSERT INTO orders(user_id) VALUES
(1),
(2),
(4),
(1);

INSERT INTO orders_products(order_id, product_id, total) VALUES
(1, (SELECT products.id FROM products WHERE name LIKE 'intel core i5%'), 1),
(2, 3, 2),
(2, 5, 1),
(3, 1, 3),
(4, (SELECT products.id FROM products WHERE name LIKE 'gigabyte%'), 1);

-- #########################################################################
-- 1) список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине:

SELECT name FROM users
INNER JOIN orders
ON orders.user_id = users.id
GROUP BY name;

-- или:
SELECT name FROM users
WHERE users.id IN (SELECT user_id FROM orders);

-- #########################################################################
-- 2) Выведите список товаров products и разделов catalogs, который соответствует товару:
SELECT p.name as 'product', c.name as 'category' FROM products as p
INNER JOIN catalogs as c
ON p.catalog_id = c.id;

-- то же с выводом всех категорий товара:
SELECT p.name as 'product', c.name as 'category' FROM products as p
RIGHT JOIN catalogs as c
ON p.catalog_id = c.id;

-- #########################################################################
-- 3) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name).
--    Поля from, to и label содержат английские названия городов, поле name — русское.
--    Выведите список рейсов flights с русскими названиями городов.

-- Создание базы данных test_flight:

DROP DATABASE IF EXISTS test_flight;
CREATE DATABASE test_flight;

use test_flight;

DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
	`id` SERIAL PRIMARY KEY,
	`from` VARCHAR(128),
	`to` VARCHAR(128)
);

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
	`label` VARCHAR(128),
	`name` VARCHAR(128)
);

-- Заполнение таблиц:

INSERT INTO flights(`from`, `to`) VALUES
('moscow', 'omsk'),
('novgorod', 'kazan'),
('irkutsk', 'moscow'),
('omsk', 'irkutsk'),
('moscow', 'kazan');

INSERT INTO cities VALUES
('moscow', 'Москва'),
('irkutsk', 'Иркутск'),
('novgorod', 'Новгород'),
('kazan', 'Казань'),
('omsk', 'Омск');

-- Выборка:

SELECT f.`id`, c1.`name` AS `from`, c2.`name` AS `to` FROM flights AS f
INNER JOIN cities AS c1
on f.`from` = c1.`label`
INNER JOIN cities AS c2
on f.`to` = c2.`label`
order by id;








