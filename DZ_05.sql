/* 1) ѕусть в таблице users пол€ created_at и updated_at оказались незаполненными.
      «аполните их текущими датой и временем. */

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

/* 2) “аблица users была неудачно спроектирована.
      «аписи created_at и updated_at были заданы типом VARCHAR и в них долгое врем€
      помещались значени€ в формате "20.10.2017 8:10".
      Ќеобходимо преобразовать пол€ к типу DATETIME, сохранив введеные ранее значени€. */

-- ѕодготовка таблицы под условие задачи: очистка, модификаци€, заполнение:
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

/* 3) ¬ таблице складских запасов storehouses_products в поле value могут встречатьс€ самые разные цифры:
      0, если товар закончилс€ и выше нул€, если на складе имеютс€ запасы.
      Ќеобходимо отсортировать записи таким образом, чтобы они выводились в пор€дке увеличени€ значени€ value.
      ќднако, нулевые запасы должны выводитьс€ в конце, после всех записей. */

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

/* 4) »з таблицы users необходимо извлечь пользователей, родившихс€ в августе и мае.
      ћес€цы заданы в виде списка английских названий ('may', 'august') */

SELECT * FROM users
WHERE MONTHNAME(birthday_at) = 'september' OR MONTHNAME(birthday_at) = 'october';

/* 5) »з таблицы catalogs извлекаютс€ записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2);
      ќтсортируйте записи в пор€дке, заданном в списке IN. */

-- дополнить таблицу до 5 записей:
INSERT INTO catalogs(name) VALUES
('RAM'),
('HDD');

SELECT * FROM catalogs
WHERE id IN (5, 1, 2)
ORDER BY FIND_IN_SET(id, '5,1,2');

/* 1) ѕодсчитайте средний возраст пользователей в таблице users */

SELECT AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) FROM users;

/* 2) ѕодсчитайте количество дней рождени€, которые приход€тс€ на каждый из дней недели.
      —ледует учесть, что необходимы дни недели текущего года, а не года рождени€. */

SELECT COUNT(*), DAYNAME(DATE_FORMAT(birthday_at, '2020-%m-%d')) AS days FROM users
GROUP BY days;

/* 3) ѕодсчитайте произведение чисел в столбце таблицы */

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











