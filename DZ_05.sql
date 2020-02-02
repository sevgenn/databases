/* 1) ����� � ������� users ���� created_at � updated_at ��������� ��������������.
      ��������� �� �������� ����� � ��������. */

use shop;
INSERT INTO users(name, birthday_at) VALUES
('John', '1980-12-31'),
('Mary', '1991-10-25'),
('Bill', '1975-09-15');

-- �������� ��������� ������� �� �������:
UPDATE users SET created_at = NULL, updated_at = NULL;
-- ��������� ������� �����:
UPDATE users SET created_at = NOW(), updated_at = NOW();	
SELECT * FROM users;

/* 2) ������� users ���� �������� ��������������.
      ������ created_at � updated_at ���� ������ ����� VARCHAR � � ��� ������ �����
      ���������� �������� � ������� "20.10.2017 8:10".
      ���������� ������������� ���� � ���� DATETIME, �������� �������� ����� ��������. */

-- ���������� ������� ��� ������� ������: �������, �����������, ����������:
TRUNCATE users;
ALTER TABLE users MODIFY created_at VARCHAR(50) NULL, MODIFY updated_at VARCHAR(50) NULL;
describe users;
INSERT INTO users(name, birthday_at, created_at, updated_at) VALUES
('John', '1980-12-31', '20.10.2017 8:10', '20.10.2017 8:10'),
('Mary', '1991-10-25', '21.10.2017 8:10', '21.10.2017 8:10'),
('Bill', '1975-09-15', '22.10.2017 8:10', '22.10.2017 8:10');

-- �������� ������ � ������� DATETIME:
UPDATE users SET																	
created_at = STR_TO_DATE(created_at, '%d.%m.%Y %H:%i'),
updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i');
-- ������������� � ������� DATETIME:
ALTER TABLE users																	
MODIFY created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
MODIFY updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
describe users;
SELECT * FROM users;

/* 3) � ������� ��������� ������� storehouses_products � ���� value ����� ����������� ����� ������ �����:
      0, ���� ����� ���������� � ���� ����, ���� �� ������ ������� ������.
      ���������� ������������� ������ ����� �������, ����� ��� ���������� � ������� ���������� �������� value.
      ������, ������� ������ ������ ���������� � �����, ����� ���� �������. */

-- ��������������� ���������� ������:
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

/* 4) �� ������� users ���������� ������� �������������, ���������� � ������� � ���.
      ������ ������ � ���� ������ ���������� �������� ('may', 'august') */

SELECT * FROM users
WHERE MONTHNAME(birthday_at) = 'september' OR MONTHNAME(birthday_at) = 'october';

/* 5) �� ������� catalogs ����������� ������ ��� ������ �������. SELECT * FROM catalogs WHERE id IN (5, 1, 2);
      ������������ ������ � �������, �������� � ������ IN. */

-- ��������� ������� �� 5 �������:
INSERT INTO catalogs(name) VALUES
('RAM'),
('HDD');

SELECT * FROM catalogs
WHERE id IN (5, 1, 2)
ORDER BY FIND_IN_SET(id, '5,1,2');

/* 1) ����������� ������� ������� ������������� � ������� users */

SELECT AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) FROM users;

/* 2) ����������� ���������� ���� ��������, ������� ���������� �� ������ �� ���� ������.
      ������� ������, ��� ���������� ��� ������ �������� ����, � �� ���� ��������. */

SELECT COUNT(*), DAYNAME(DATE_FORMAT(birthday_at, '2020-%m-%d')) AS days FROM users
GROUP BY days;

/* 3) ����������� ������������ ����� � ������� ������� */

-- ������� � ��������� �������:
CREATE TABLE IF NOT EXISTS `test`(val INT(10));
INSERT INTO test VALUES
(1),
(2),
(3),
(4),
(5);

-- 1*2*3*4*5 = exp(ln(1*2*3*4*5)) = exp(ln(1)+ln(2)+ln(3)+ln(4)+ln(5))
select EXP(SUM(LN(val))) FROM test;











