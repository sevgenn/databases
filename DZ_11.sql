/* 1) �������� ������� logs ���� Archive. ����� ��� ������ �������� ������ � �������� users, catalogs � products
      � ������� logs ���������� ����� � ���� �������� ������, �������� �������, ������������� ���������� ����� � ���������� ���� name. */

-- ����� ��������� ������� �� ����, ������� ���.
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

CREATE TRIGGER log_users AFTER INSERT ON `users`				-- ������� ��� ������ � users
FOR EACH ROW
BEGIN
	INSERT INTO logs (`table_name`, `id_pk`, `name`) VALUES(
	'users',
	NEW.id,
	NEW.name);	
END//

DROP TRIGGER IF EXISTS log_catalogs//
CREATE TRIGGER log_catalogs AFTER INSERT ON `catalogs`			-- ������� ��� ������ � catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs (`table_name`, `id_pk`, `name`) VALUES(
	'catalogs',
	NEW.id,
	NEW.name);	
END//

DROP TRIGGER IF EXISTS log_products//
CREATE TRIGGER log_products AFTER INSERT ON `products`			-- ������� ��� ������ � products
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


/* 2) (�� �������) �������� SQL-������, ������� �������� � ������� users ������� �������. */

DROP PROCEDURE IF EXISTS million;
DELIMITER //

CREATE PROCEDURE million()
BEGIN
	DECLARE n INT DEFAULT 0;
	DECLARE nick VARCHAR(255);
	WHILE n < 10 DO									-- ��� 10 �������
		SET nick = CONCAT('John', '-', n);
		INSERT INTO users(name) VALUES (nick);
		SET n = n + 1;
	END WHILE;
END//

DELIMITER ;

CALL million();
SELECT * FROM users;


/* 1) NoSQL. � ���� ������ Redis ��������� ��������� ��� �������� ��������� � ������������ IP-�������. */

-- �� ����� �������, �� ���-�� ��� (���������� ������ �� Ubuntu ����� ����������):
127.0.0.1:6379> SET visit_from_95.100.100.50 0
OK
127.0.0.1:6379> SET visit_from_95.100.100.100 0
OK
127.0.0.1:6379> INCR visit_from_95.100.100.50
(integer) 1
127.0.0.1:6379> GET visit_from_95.100.100.50
"1"


/* 2) NoSQL. ��� ������ ���� ������ Redis ������ ������ ������ ����� ������������ �� ������������ ������ � ��������, ����� ������������ ������ ������������ �� ��� �����. */

-- ������ ����� email �� �����, ������� �� ����������:
127.0.0.1:6379> HMSET contacts john john@mail.com bill bill@mail.com
OK
127.0.0.1:6379> HGET contacts bill
"bill@mail.com"



/* 3) NoSQL. ����������� �������� ��������� � �������� ������� ������� ���� ������ shop � ���� MongoDB. */

-- �� �����.

