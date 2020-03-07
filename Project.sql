/* ����� �� ���������� ���� �� ������ ���� �� ������ ��, � ��� ������ ������ �� ������� �����.
��������� ��� �����-�� ��������� ��������� �������������, ������� ����� �������� ���� ������
��� ����������, ������� ��������� ����������������� � ���������������� �������� �����������:
������������ �������, ������������ �������, ��������, ��������, ���������� � ������ �������, ������ � �.�.
���� �������� ��� ��� �������� �����, �� ������� ����� ���������������� ���������, ��� � ���
����������������� ����������� (� ���� ������ ������� "vendors" - "����������" ����� ���������������
� ����������� �����).

� ������ �������� ���������� ������� "���������" ���� ������� �� ��� ������ (������, �������, ���������)
� ����� �� ���������� ������, �.�. ������ ����� ���������������� �� ����� ����� (������ �� ��������� � �����������
�� ������ ������, ������ ��������������). ��� ������ "furniture" - "���������" ����� �� ����� ������ ������ � �������
"facade" - "������", � ����� ���� ���������. ����� ���� ������ ������ ����� ������ �������
����������: ������ "bodies" - "�������" ����� ������ �� �����������, � ��������� ������
����������� � ����������� �� ����������� � ����������. ����� ������� ��� ������� ������
������ ����������� ������ �� ����������� ����������, �� ����������� ���� � ������.
������������� ������� "order_item" (��� ���������� ����� ������-��-������) ���� ������� �� ����,
����� ��������� ��������������� � "item_id" ��-�� ��������� ������ �� ��� ������.

� �������� �������� (2 �������) ������ ���� ������� � ���� �������, ����� �� ��������� ��������.
��������� ��������� ������ �������������� ����� �������������� ������� "classes" ��� �������������
��������� ������ (�������, ������, ���������).

�����:
���� �� ��������� �������� �� 'Project'.

���� �� ��������� ���������� �� 'Project-insert'.

���� ������� 'date_delivery' � ����� 'Project' ��������� ��������������� ������� ���������� ������
� ��������� 1 ����� � ���� ���������� ������.

��� ������������� � ����� 'Project-preview'.

��� ��������� (� �������� ����������� � ���) � ����� 'Project-procedures'.
*/

DROP DATABASE IF EXISTS furniture_company;
CREATE DATABASE furniture_company;

USE furniture_company;										-- ';' - ��� ������������

DROP TABLE IF EXISTS adresses;
CREATE TABLE adresses (										-- ������� � ����� ������� (����� ��� ����������� �����������, �����������)
id SERIAL PRIMARY KEY,
city VARCHAR(20) NOT NULL,
adress VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS media;
CREATE TABLE media (										-- ������� ���� � ��������
id SERIAL PRIMARY KEY,
filename VARCHAR(255),
filesize INT,
metadata JSON
);

DROP TABLE IF EXISTS persons;
CREATE TABLE persons (										-- ������� ������� � ����������� � �����������, �����������
id SERIAL PRIMARY KEY,
last_name VARCHAR(20) NOT NULL,
first_name VARCHAR(20) NOT NULL,
patronimic VARCHAR(20) NULL,
adress_id BIGINT UNSIGNED NOT NULL,
phone_1 BIGINT(11) NOT NULL,
phone_2 BIGINT(11) NULL,
email VARCHAR(100) NULL,

FOREIGN KEY (adress_id) REFERENCES adresses(id)
);

DROP TABLE IF EXISTS customers;
CREATE TABLE customers (									-- ����������
id SERIAL PRIMARY KEY,
contact_name VARCHAR(50) NOT NULL,
person_id BIGINT UNSIGNED NOT NULL,

FOREIGN KEY (person_id) REFERENCES persons(id)
);

DROP TABLE IF EXISTS shops;
CREATE TABLE shops (										-- ��������
id SERIAL PRIMARY KEY,
name VARCHAR(50) NOT NULL,
adress_id BIGINT UNSIGNED NOT NULL,

FOREIGN KEY (adress_id) REFERENCES adresses(id)
);

DROP TABLE IF EXISTS managers;
CREATE TABLE managers (										-- ���������, ����������� �����
id SERIAL PRIMARY KEY,
person_id BIGINT UNSIGNED NOT NULL,
shop_id BIGINT UNSIGNED NOT NULL,

FOREIGN KEY (person_id) REFERENCES persons(id),
FOREIGN KEY (shop_id) REFERENCES shops(id)
);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
id SERIAL PRIMARY KEY,
customer_id BIGINT UNSIGNED NOT NULL,
manager_id BIGINT UNSIGNED NOT NULL,
order_date DATETIME NOT NULL DEFAULT current_timestamp,					-- ���� ���������� ������
date_delivery DATETIME,													-- ���� ���������� ������� �� �������������� +30 ����
status_order ENUM('placed', 'agreed', 'completed', 'canceled'),			-- ��������� ������ (��������, ����������-� ������, ��������)
status_payment ENUM('no', 'prepay', 'full'),							-- ��������� ������ (���, ����������, �������)
media_id BIGINT UNSIGNED NOT NULL,										-- ������ �� ������
totaldue DECIMAL(9,2),													-- ����� ��������� - ���������� ���������� (�� ��������� ������ ��������� ��� ������� ��������)

FOREIGN KEY (media_id) REFERENCES media(id),
FOREIGN KEY (customer_id) REFERENCES customers(id),
FOREIGN KEY (manager_id) REFERENCES managers(id)
);

DROP TRIGGER IF EXISTS log_users;
DELIMITER //

CREATE TRIGGER date_delivery BEFORE INSERT ON orders					-- ������� ��� orders.date_delivery �� ��������� +30 ����
FOR EACH ROW															-- ��������� ��������������� ���� ��������
BEGIN
	IF (NEW.date_delivery IS NULL) THEN
		SET NEW.date_delivery = DATE_ADD(NEW.order_date, INTERVAL 30 DAY);
	END IF;
END//

DELIMITER ;

/*
###########  1 ������� ���������� � ����������� ������ ������ �� ���� ��������� �������:  ###########

DROP TABLE IF EXISTS order_furniture;
CREATE TABLE order_furniture (								-- ������� ��� �������������� "������-��-������" ����� �������� � �������-����������
order_id BIGINT NOT NULL,
furniture_id BIGINT NOT NULL,
quantity INT(3),

PRIMARY KEY (order_id, furniture_id),						-- ��������� ��������� ����
FOREIGN KEY (order_id) REFERENCES orders(id),
FOREIGN KEY (furniture_id) REFERENCES furnitures(id)
);


DROP TABLE IF EXISTS order_facade;
CREATE TABLE order_facade (									-- ������� ��� �������������� "������-��-������" ����� �������� � �������-��������
order_id BIGINT NOT NULL,
facade_id BIGINT NOT NULL,
quantity INT(3),

PRIMARY KEY (order_id, facade_id),
FOREIGN KEY (order_id) REFERENCES orders(id),
FOREIGN KEY (facade_id) REFERENCES facades(id)
);

DROP TABLE IF EXISTS order_body;
CREATE TABLE order_body (									-- ������� ��� �������������� "������-��-������" ����� �������� � �������-���������
order_id BIGINT NOT NULL,
body_id BIGINT NOT NULL,
quantity INT(3),

PRIMARY KEY (order_id, body_id),
FOREIGN KEY (order_id) REFERENCES orders(id),
FOREIGN KEY (body_id) REFERENCES bodies(id)
);

DROP TABLE IF EXISTS furnitures;
CREATE TABLE furnitures (									-- ������� ��� ���������
id SERIAL PRIMARY KEY,									
item VARCHAR(50) NOT NULL,									-- ������������ ������										
description TEXT,
price DECIMAL(9,2),
media_id BIGINT NOT NULL,									-- ������ �� ����������� (����, ������)
cat_furniture_id BIGINT NOT NULL,

FOREIGN KEY (media_id) REFERENCES media(id),
FOREIGN KEY (cat_furniture_id) REFERENCES category_furniture(id)
);


DROP TABLE IF EXISTS category_furniture;
CREATE TABLE category_furniture (							-- ������� ��� ��������� ���������
id SERIAL PRIMARY KEY,									
name VARCHAR(50) NOT NULL,									-- ������������ ���������										
description TEXT,
media_id BIGINT NOT NULL									-- ������ �� �����������
);


DROP TABLE IF EXISTS facades;
CREATE TABLE facades (										-- ������� ��� �������
id SERIAL PRIMARY KEY,									
item VARCHAR(50) NOT NULL,									-- ������������ ������										
description TEXT,
price DECIMAL(9,2),
media_id BIGINT NOT NULL,									-- ������ �� ����������� (����, ������)
cat_facade_id BIGINT NOT NULL,
discount_id BIGINT NOT NULL,								-- ������ �� ��������� ������

FOREIGN KEY (media_id) REFERENCES media(id),
FOREIGN KEY (cat_facade_id) REFERENCES category_facade(id),
FOREIGN KEY (discount_id) REFERENCES discounts(id)
);


DROP TABLE IF EXISTS category_facade;
CREATE TABLE category_facade (								-- ������� ��� ������ �������
id SERIAL PRIMARY KEY,									
name VARCHAR(50) NOT NULL,									-- ������������ �����										
description TEXT,
media_id BIGINT NOT NULL,									-- ������ �� �����������

UNIQUE unique_name(name(5)									-- ���������� ���������� ��������
);

DROP TABLE IF EXISTS bodies;
CREATE TABLE bodies (										-- ������� ��� ��������� �������
id SERIAL PRIMARY KEY,									
item VARCHAR(50) NOT NULL,									-- ������������ ��������										
description TEXT,
price DECIMAL(9,2),
media_id BIGINT NOT NULL,									-- ������ �� ����������� (����, ������)

FOREIGN KEY (media_id) REFERENCES media(id)
);
*/

###########  2 ������� ���������� � ������������ ���� ������� � ���� ������� � ��������� ���� ������: ��������� � ������������:   ###########

DROP TABLE IF EXISTS classes;
CREATE TABLE classes (										-- ������� ������� ������: ���������, ������, �������
id SERIAL PRIMARY KEY,
name VARCHAR(20) NOT NULL
);

DROP TABLE IF EXISTS categories;
CREATE TABLE categories (									-- ������� ��������� ������ ������ ������� ������ (��������� - �����, ������ � �.�., ������ - �����)
id SERIAL PRIMARY KEY,
name VARCHAR(50) NOT NULL,
description TEXT,
media_id BIGINT UNSIGNED NOT NULL,
class_id BIGINT UNSIGNED NOT NULL,

FOREIGN KEY (media_id) REFERENCES media(id),
FOREIGN KEY (class_id) REFERENCES classes(id)
);

DROP TABLE IF EXISTS products;
CREATE TABLE products (										-- ������� ��� �������
id SERIAL PRIMARY KEY,									
item VARCHAR(50) NOT NULL,									-- ������������ ������										
description TEXT,
media_id BIGINT UNSIGNED NOT NULL,							-- ������ �� ����������� (����, ������)
category_id BIGINT UNSIGNED NOT NULL,

FOREIGN KEY (media_id) REFERENCES media(id),
FOREIGN KEY (category_id) REFERENCES categories(id)
);

DROP TABLE IF EXISTS order_product;
CREATE TABLE order_product (								-- ������� ��� �������������� "������-��-������" ����� �������� � �������
order_id BIGINT UNSIGNED NOT NULL,
item_id BIGINT UNSIGNED NOT NULL,
quantity INT(3),

PRIMARY KEY (order_id, item_id),							-- ��������� ��������� ����
FOREIGN KEY (order_id) REFERENCES orders(id),
FOREIGN KEY (item_id) REFERENCES products(id),

KEY index_of_order_id (order_id, item_id),					-- �������� �������� (����������)
KEY index_of_item_id (item_id, order_id)
);

DROP TABLE IF EXISTS prices;
CREATE TABLE prices (
item_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
`date` DATETIME NOT NULL DEFAULT current_timestamp,
price DECIMAL(9,2),

PRIMARY KEY (item_id, `date`),								-- ��������� ��������� ����
FOREIGN KEY (item_id) REFERENCES products(id)
);

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
id SERIAL PRIMARY KEY,
discount FLOAT DEFAULT 1,									-- ������ �� ������������ ��������� �������
category_id BIGINT UNSIGNED NOT NULL,
date_start DATE,
date_finish DATE,

FOREIGN KEY (category_id) REFERENCES categories(id)
);

DROP TABLE IF EXISTS vendors;
CREATE TABLE vendors (										-- ���������� �������������
id SERIAL PRIMARY KEY,
name VARCHAR(50) NOT NULL,
adress_id BIGINT UNSIGNED NOT NULL,

FOREIGN KEY (adress_id) REFERENCES adresses(id)
);

DROP TABLE IF EXISTS supplies;
CREATE TABLE supplies (										-- ��������
id SERIAL PRIMARY KEY,
vendor_id BIGINT UNSIGNED NOT NULL,
date_supply DATETIME DEFAULT current_timestamp,

FOREIGN KEY (vendor_id) REFERENCES vendors(id)
);

DROP TABLE IF EXISTS supply_product;
CREATE TABLE supply_product (								-- ������� ��� ���������� "������-��-������"
supply_id BIGINT UNSIGNED NOT NULL,
item_id BIGINT UNSIGNED NOT NULL,
quantity INT(3),

PRIMARY KEY (supply_id, item_id),							-- ��������� ��������� ����
FOREIGN KEY (supply_id) REFERENCES supplies(id),
FOREIGN KEY (item_id) REFERENCES products(id)
);

DROP TABLE IF EXISTS storehouse;
CREATE TABLE storehouse (									-- ����� �� ������
id SERIAL PRIMARY KEY,
item_id BIGINT UNSIGNED NOT NULL,
quantity INT(3) NOT NULL,

FOREIGN KEY (item_id) REFERENCES products(id)
);

DROP TABLE IF EXISTS deliveries;
CREATE TABLE deliveries (									-- ��������
id SERIAL PRIMARY KEY,
status ENUM('accepted', 'completed', 'canceled'),			-- ��������� ������ �� ��������
price DECIMAL(9,2),
adress_id BIGINT UNSIGNED NOT NULL,
order_id BIGINT UNSIGNED NOT NULL,

FOREIGN KEY (adress_id) REFERENCES adresses(id),
FOREIGN KEY (order_id) REFERENCES orders(id)
);

DROP TABLE IF EXISTS assemblies;
CREATE TABLE assemblies (									-- ������
id SERIAL PRIMARY KEY,
status ENUM('accepted', 'completed', 'canceled'),			-- ��������� ������ �� ������
price DECIMAL(9,2),
adress_id BIGINT UNSIGNED NOT NULL,
order_id BIGINT UNSIGNED NOT NULL,

FOREIGN KEY (adress_id) REFERENCES adresses(id),
FOREIGN KEY (order_id) REFERENCES orders(id)
);







