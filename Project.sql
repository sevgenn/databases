/* Чтобы не высасывать тему из пальца взял за основу то, с чем хорошо знаком из личного опыта.
Несколько лет когда-то занимался мебельным производством, поэтому решил написать базу данных
для приложения, которое позволяет систематизировать и администрировать процессы предприятия:
формирование заказов, отслеживание закупок, остатков, движений, статистика и анализ заказов, продаж и т.д.
Идея подойдет как для торговой фирмы, не имеющей своих производственных мощностей, так и для
производственного предприятия (в этом случае таблица "vendors" - "поставщики" будет ассоциироваться
с собственным цехом).

В первом варианте изначально таблица "продукция" была разбита на три группы (фасады, корпуса, фурнитура)
в связи со спецификой товара, т.к. разный товар каталогизируется по своей схеме (иногда не связанной с категориями
из другой группы, иногда пересекающейся). Так группа "furniture" - "фурнитура" может не иметь ничего общего с группой
"facade" - "фасады", а может быть зависимой. Кроме того разные группы имеют разную частоту
обновления: группа "bodies" - "корпуса" может вообще не обновляться, а остальные группы
обновляются в зависимости от конъюнктуры и поставщика. Таким образом три крупные группы
товара разбивались внутри по собственным категориям, не пересекаясь друг с другом.
Промежуточная таблица "order_item" (для исключения связи многие-ко-многим) была раздута до трех,
чтобы исключить неоднозначность в "item_id" из-за разбиения товара на три группы.

В конечном варианте (2 вариант) товары были сведены в одну таблицу, чтобы не осложнять проверку.
Разбиение категорий товара осуществляется через дополнительную таблицу "classes" для идентификации
категорий товара (корпуса, фасады, фурнитура).

Итого:
Файл со скриптами создания БД 'Project'.

Файл со скриптами наполнения БД 'Project-insert'.

Один триггер 'date_delivery' в файле 'Project' формирует предварительное времени исполнения заказа
с отсрочкой 1 месяц с даты оформления заказа.

Три представления в листе 'Project-preview'.

Три процедуры (с входными парамеирами и без) в листе 'Project-procedures'.
*/

DROP DATABASE IF EXISTS furniture_company;
CREATE DATABASE furniture_company;

USE furniture_company;					-- ';' - для единообразия

DROP TABLE IF EXISTS adresses;
CREATE TABLE adresses (					-- таблица с базой адресов (город для иногородних поставщиков, покупателей)
id SERIAL PRIMARY KEY,
city VARCHAR(20) NOT NULL,
adress VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS media;
CREATE TABLE media (					-- таблица фото и чертежей
id SERIAL PRIMARY KEY,
filename VARCHAR(255),
filesize INT,
metadata JSON
);

DROP TABLE IF EXISTS persons;
CREATE TABLE persons (					-- сводная таблица с информацией о покупателях, сотрудниках
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
CREATE TABLE customers (				-- покупатели
id SERIAL PRIMARY KEY,
contact_name VARCHAR(50) NOT NULL,
person_id BIGINT UNSIGNED NOT NULL,

FOREIGN KEY (person_id) REFERENCES persons(id)
);

DROP TABLE IF EXISTS shops;
CREATE TABLE shops (					-- магазины
id SERIAL PRIMARY KEY,
name VARCHAR(50) NOT NULL,
adress_id BIGINT UNSIGNED NOT NULL,

FOREIGN KEY (adress_id) REFERENCES adresses(id)
);

DROP TABLE IF EXISTS managers;
CREATE TABLE managers (					-- менеджеры, оформляющие заказ
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
order_date DATETIME NOT NULL DEFAULT current_timestamp,				-- дата размещения заказа
date_delivery DATETIME,								-- срок готовности ТРИГГЕР НА АВТОЗАПОЛНЕНИЕ +30 ДНЕЙ
status_order ENUM('placed', 'agreed', 'completed', 'canceled'),			-- состояние заказа (размещен, согласован-в работе, выполнен)
status_payment ENUM('no', 'prepay', 'full'),					-- состояние оплаты (нет, предоплата, оплачен)
media_id BIGINT UNSIGNED NOT NULL,						-- ссылка на чертеж
totaldue DECIMAL(9,2),								-- общая стоимость - ИЗБЫТОЧНАЯ ИНФОРМАЦИЯ (но облегчает частое обращение без сложных запросов)

FOREIGN KEY (media_id) REFERENCES media(id),
FOREIGN KEY (customer_id) REFERENCES customers(id),
FOREIGN KEY (manager_id) REFERENCES managers(id)
);

DROP TRIGGER IF EXISTS log_users;
DELIMITER //

CREATE TRIGGER date_delivery BEFORE INSERT ON orders				-- триггер для orders.date_delivery по умолчанию +30 дней
FOR EACH ROW									-- формирует предварительную дату доставки
BEGIN
	IF (NEW.date_delivery IS NULL) THEN
		SET NEW.date_delivery = DATE_ADD(NEW.order_date, INTERVAL 30 DAY);
	END IF;
END//

DELIMITER ;

/*
###########  1 вариант реализации с разделением таблиц товара по трем отдельным группам:  ###########

DROP TABLE IF EXISTS order_furniture;
CREATE TABLE order_furniture (							-- таблица для преобразования "многие-ко-многим" между заказами и товаром-фурнитурой
order_id BIGINT NOT NULL,
furniture_id BIGINT NOT NULL,
quantity INT(3),

PRIMARY KEY (order_id, furniture_id),						-- составной первичный ключ
FOREIGN KEY (order_id) REFERENCES orders(id),
FOREIGN KEY (furniture_id) REFERENCES furnitures(id)
);


DROP TABLE IF EXISTS order_facade;
CREATE TABLE order_facade (							-- таблица для преобразования "многие-ко-многим" между заказами и товаром-фасадами
order_id BIGINT NOT NULL,
facade_id BIGINT NOT NULL,
quantity INT(3),

PRIMARY KEY (order_id, facade_id),
FOREIGN KEY (order_id) REFERENCES orders(id),
FOREIGN KEY (facade_id) REFERENCES facades(id)
);

DROP TABLE IF EXISTS order_body;
CREATE TABLE order_body (							-- таблица для преобразования "многие-ко-многим" между заказами и товаром-корпусами
order_id BIGINT NOT NULL,
body_id BIGINT NOT NULL,
quantity INT(3),

PRIMARY KEY (order_id, body_id),
FOREIGN KEY (order_id) REFERENCES orders(id),
FOREIGN KEY (body_id) REFERENCES bodies(id)
);

DROP TABLE IF EXISTS furnitures;
CREATE TABLE furnitures (							-- таблица для фурнитуры
id SERIAL PRIMARY KEY,									
item VARCHAR(50) NOT NULL,							-- наименование товара										
description TEXT,
price DECIMAL(9,2),
media_id BIGINT NOT NULL,							-- ссылка на изображение (фото, чертеж)
cat_furniture_id BIGINT NOT NULL,

FOREIGN KEY (media_id) REFERENCES media(id),
FOREIGN KEY (cat_furniture_id) REFERENCES category_furniture(id)
);


DROP TABLE IF EXISTS category_furniture;
CREATE TABLE category_furniture (						-- таблица для категорий фурнитуры
id SERIAL PRIMARY KEY,									
name VARCHAR(50) NOT NULL,							-- наименование категории										
description TEXT,
media_id BIGINT NOT NULL							-- ссылка на изображение
);


DROP TABLE IF EXISTS facades;
CREATE TABLE facades (								-- таблица для фасадов
id SERIAL PRIMARY KEY,									
item VARCHAR(50) NOT NULL,							-- наименование товара										
description TEXT,
price DECIMAL(9,2),
media_id BIGINT NOT NULL,							-- ссылка на изображение (фото, чертеж)
cat_facade_id BIGINT NOT NULL,
discount_id BIGINT NOT NULL,							-- ссылка на возможную скидку

FOREIGN KEY (media_id) REFERENCES media(id),
FOREIGN KEY (cat_facade_id) REFERENCES category_facade(id),
FOREIGN KEY (discount_id) REFERENCES discounts(id)
);


DROP TABLE IF EXISTS category_facade;
CREATE TABLE category_facade (							-- таблица для стилей фасадов
id SERIAL PRIMARY KEY,									
name VARCHAR(50) NOT NULL,							-- наименование стиля										
description TEXT,
media_id BIGINT NOT NULL,							-- ссылка на изображение

UNIQUE unique_name(name(5)							-- исключение повторения названий
);

DROP TABLE IF EXISTS bodies;
CREATE TABLE bodies (								-- таблица для элементов корпуса
id SERIAL PRIMARY KEY,									
item VARCHAR(50) NOT NULL,							-- наименование элемента										
description TEXT,
price DECIMAL(9,2),
media_id BIGINT NOT NULL,							-- ссылка на изображение (фото, чертеж)

FOREIGN KEY (media_id) REFERENCES media(id)
);
*/

###########  2 вариант реализации с объединением всех товаров в одну таблицу и созданием двух таблиц: категории и подкатегории:   ###########

DROP TABLE IF EXISTS classes;
CREATE TABLE classes (						-- таблица классов товара: фурнитура, фасады, корпуса
id SERIAL PRIMARY KEY,
name VARCHAR(20) NOT NULL
);

DROP TABLE IF EXISTS categories;
CREATE TABLE categories (					-- таблица категорий товара внутри каждого класса (фурнитура - ручки, крепеж и т.д., фасады - стили)
id SERIAL PRIMARY KEY,
name VARCHAR(50) NOT NULL,
description TEXT,
media_id BIGINT UNSIGNED NOT NULL,
class_id BIGINT UNSIGNED NOT NULL,

FOREIGN KEY (media_id) REFERENCES media(id),
FOREIGN KEY (class_id) REFERENCES classes(id)
);

DROP TABLE IF EXISTS products;
CREATE TABLE products (						-- таблица для товаров
id SERIAL PRIMARY KEY,									
item VARCHAR(50) NOT NULL,					-- наименование товара										
description TEXT,
media_id BIGINT UNSIGNED NOT NULL,				-- ссылка на изображение (фото, чертеж)
category_id BIGINT UNSIGNED NOT NULL,

FOREIGN KEY (media_id) REFERENCES media(id),
FOREIGN KEY (category_id) REFERENCES categories(id)
);

DROP TABLE IF EXISTS order_product;
CREATE TABLE order_product (					-- таблица для преобразования "многие-ко-многим" между заказами и товаром
order_id BIGINT UNSIGNED NOT NULL,
item_id BIGINT UNSIGNED NOT NULL,
quantity INT(3),

PRIMARY KEY (order_id, item_id),				-- составной первичный ключ
FOREIGN KEY (order_id) REFERENCES orders(id),
FOREIGN KEY (item_id) REFERENCES products(id),

KEY index_of_order_id (order_id, item_id),			-- создание индексов (формальное)
KEY index_of_item_id (item_id, order_id)
);

DROP TABLE IF EXISTS prices;
CREATE TABLE prices (
item_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
`date` DATETIME NOT NULL DEFAULT current_timestamp,
price DECIMAL(9,2),

PRIMARY KEY (item_id, `date`),					-- составной первичный ключ
FOREIGN KEY (item_id) REFERENCES products(id)
);

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
id SERIAL PRIMARY KEY,
discount FLOAT DEFAULT 1,					-- скидка на определенную категорию фасадов
category_id BIGINT UNSIGNED NOT NULL,
date_start DATE,
date_finish DATE,

FOREIGN KEY (category_id) REFERENCES categories(id)
);

DROP TABLE IF EXISTS vendors;
CREATE TABLE vendors (						-- поставщики комплектующих
id SERIAL PRIMARY KEY,
name VARCHAR(50) NOT NULL,
adress_id BIGINT UNSIGNED NOT NULL,

FOREIGN KEY (adress_id) REFERENCES adresses(id)
);

DROP TABLE IF EXISTS supplies;
CREATE TABLE supplies (						-- поставки
id SERIAL PRIMARY KEY,
vendor_id BIGINT UNSIGNED NOT NULL,
date_supply DATETIME DEFAULT current_timestamp,

FOREIGN KEY (vendor_id) REFERENCES vendors(id)
);

DROP TABLE IF EXISTS supply_product;
CREATE TABLE supply_product (					-- таблица для исключения "многие-ко-многим"
supply_id BIGINT UNSIGNED NOT NULL,
item_id BIGINT UNSIGNED NOT NULL,
quantity INT(3),

PRIMARY KEY (supply_id, item_id),				-- составной первичный ключ
FOREIGN KEY (supply_id) REFERENCES supplies(id),
FOREIGN KEY (item_id) REFERENCES products(id)
);

DROP TABLE IF EXISTS storehouse;
CREATE TABLE storehouse (					-- товар на складе
id SERIAL PRIMARY KEY,
item_id BIGINT UNSIGNED NOT NULL,
quantity INT(3) NOT NULL,

FOREIGN KEY (item_id) REFERENCES products(id)
);

DROP TABLE IF EXISTS deliveries;
CREATE TABLE deliveries (					-- доставка
id SERIAL PRIMARY KEY,
status ENUM('accepted', 'completed', 'canceled'),		-- состояние заказа на доставку
price DECIMAL(9,2),
adress_id BIGINT UNSIGNED NOT NULL,
order_id BIGINT UNSIGNED NOT NULL,

FOREIGN KEY (adress_id) REFERENCES adresses(id),
FOREIGN KEY (order_id) REFERENCES orders(id)
);

DROP TABLE IF EXISTS assemblies;
CREATE TABLE assemblies (					-- сборка
id SERIAL PRIMARY KEY,
status ENUM('accepted', 'completed', 'canceled'),		-- состояние заказа на сборку
price DECIMAL(9,2),
adress_id BIGINT UNSIGNED NOT NULL,
order_id BIGINT UNSIGNED NOT NULL,

FOREIGN KEY (adress_id) REFERENCES adresses(id),
FOREIGN KEY (order_id) REFERENCES orders(id)
);







