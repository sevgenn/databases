/* 1) Пусть в таблице users поля created_at и updated_at оказались незаполненными.
      Заполните их текущими датой и временем. */

use shop;
INSERT INTO users(name, birthday_at) VALUES
('John', '1980-12-31'),
('Mary', '1991-10-25'),
('Bill', '1975-09-15');

-- очистить указанные столбцы по условию:
UPDATE users SET created_at = NULL, updated_at = NULL;
-- заполнить текущей датой:
UPDATE users SET created_at = NOW(), updated_at = NOW();	
SELECT * FROM users;

/* 2) Таблица users была неудачно спроектирована.
      Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время
      помещались значения в формате "20.10.2017 8:10".
      Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения. */

-- Подготовка таблицы под условие задачи: очистка, модификация, заполнение:
TRUNCATE users;
ALTER TABLE users MODIFY created_at VARCHAR(50) NULL, MODIFY updated_at VARCHAR(50) NULL;
describe users;
INSERT INTO users(name, birthday_at, created_at, updated_at) VALUES
('John', '1980-12-31', '20.10.2017 8:10', '20.10.2017 8:10'),
('Mary', '1991-10-25', '21.10.2017 8:10', '21.10.2017 8:10'),
('Bill', '1975-09-15', '22.10.2017 8:10', '22.10.2017 8:10');

-- привести строку к формату DATETIME:
UPDATE users SET																	
created_at = STR_TO_DATE(created_at, '%d.%m.%Y %H:%i'),
updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i');
-- преобразовать к формату DATETIME:
ALTER TABLE users																	
MODIFY created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
MODIFY updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
describe users;
SELECT * FROM users;

/* 3) В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры:
      0, если товар закончился и выше нуля, если на складе имеются запасы.
      Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value.
      Однако, нулевые запасы должны выводиться в конце, после всех записей. */

-- предварительное заполнение таблиц:
INSERT INTO products(name) VALUES
('proc_1'),
('proc_2'),
('motherboard_1'),
('motherboard_2'),
('motherboard_3'),
('videocard_1'),
('videocard_1');
INSERT INTO storehouses_products(product_id, value) VALUES
(1, 10),
(2, 0),
(3, 50),
(4, 0),
(5, 30),
(6, 20),
(7, 0);

SELECT * from storehouses_products
ORDER BY value=0, value;

/* 4) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае.
      Месяцы заданы в виде списка английских названий ('may', 'august') */

SELECT * FROM users
WHERE MONTHNAME(birthday_at) = 'september' OR MONTHNAME(birthday_at) = 'october';

/* 5) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2);
      Отсортируйте записи в порядке, заданном в списке IN. */

-- дополнить таблицу до 5 записей:
INSERT INTO catalogs(name) VALUES
('RAM'),
('HDD');

SELECT * FROM catalogs
WHERE id IN (5, 1, 2)
ORDER BY FIND_IN_SET(id, '5,1,2');

/* 1) Подсчитайте средний возраст пользователей в таблице users */

SELECT AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) FROM users;

/* 2) Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
      Следует учесть, что необходимы дни недели текущего года, а не года рождения. */

SELECT COUNT(*), DAYNAME(DATE_FORMAT(birthday_at, '2020-%m-%d')) AS days FROM users
GROUP BY days;

/* 3) Подсчитайте произведение чисел в столбце таблицы */

-- создать и заполнить таблицу:
CREATE TABLE IF NOT EXISTS `test`(val INT(10));
INSERT INTO test VALUES
(1),
(2),
(3),
(4),
(5);

-- 1*2*3*4*5 = exp(ln(1*2*3*4*5)) = exp(ln(1)+ln(2)+ln(3)+ln(4)+ln(5))
select EXP(SUM(LN(val))) FROM test;











