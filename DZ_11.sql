/* 1) Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products
      в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name. */

-- Одним триггером сделать не смог, поэтому три.
USE shop;

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
`date` DATETIME NOT NULL DEFAULT current_timestamp,
`table_name` VARCHAR(50) NOT NULL,
`id_pk` BIGINT NOT NULL,
`name` VARCHAR(255) NOT NULL
) ENGINE=Archive;

DROP TRIGGER IF EXISTS log_users;
DELIMITER //

CREATE TRIGGER log_users AFTER INSERT ON `users`				-- триггер для записи в users
FOR EACH ROW
BEGIN
	INSERT INTO logs (`table_name`, `id_pk`, `name`) VALUES(
	'users',
	NEW.id,
	NEW.name);	
END//

DROP TRIGGER IF EXISTS log_catalogs//
CREATE TRIGGER log_catalogs AFTER INSERT ON `catalogs`			-- триггер для записи в catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs (`table_name`, `id_pk`, `name`) VALUES(
	'catalogs',
	NEW.id,
	NEW.name);	
END//

DROP TRIGGER IF EXISTS log_products//
CREATE TRIGGER log_products AFTER INSERT ON `products`			-- триггер для записи в products
FOR EACH ROW
BEGIN
	INSERT INTO logs (`table_name`, `id_pk`, `name`) VALUES(
	'products',
	NEW.id,
	NEW.name);	
END//

DELIMITER ;

-- Examples:
INSERT INTO users(name) VALUES ('Bill');
INSERT INTO catalogs(name) VALUES ('Routers');
INSERT INTO products(name) VALUES ('ASUS');


/* 2) (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей. */

DROP PROCEDURE IF EXISTS million;
DELIMITER //

CREATE PROCEDURE million()
BEGIN
	DECLARE n INT DEFAULT 0;
	DECLARE nick VARCHAR(255);
	WHILE n < 10 DO									-- для 10 записей
		SET nick = CONCAT('John', '-', n);
		INSERT INTO users(name) VALUES (nick);
		SET n = n + 1;
	END WHILE;
END//

DELIMITER ;

CALL million();
SELECT * FROM users;


/* 1) NoSQL. В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов. */

-- Не понял задание, но как-то так (скопировал строки из Ubuntu посде выполнения):
127.0.0.1:6379> SET visit_from_95.100.100.50 0
OK
127.0.0.1:6379> SET visit_from_95.100.100.100 0
OK
127.0.0.1:6379> INCR visit_from_95.100.100.50
(integer) 1
127.0.0.1:6379> GET visit_from_95.100.100.50
"1"


/* 2) NoSQL. При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу и наоборот, поиск электронного адреса пользователя по его имени. */

-- Только поиск email по имени, обратно не получилось:
127.0.0.1:6379> HMSET contacts john john@mail.com bill bill@mail.com
OK
127.0.0.1:6379> HGET contacts bill
"bill@mail.com"



/* 3) NoSQL. Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB. */

-- Не успел.

