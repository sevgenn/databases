-- 1) В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных.
--    Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

-- Создание базы sample и таблицы users:
drop database if exists sample;
create database sample;

drop table if exists sample.users;
create table sample.users(
id serial primary key,
name varchar(255),
birthday_at date,
created_at datetime default CURRENT_TIMESTAMP,
updated_at datetime default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP
);

-- Транзакция по перемещению записи:
START TRANSACTION;
INSERT INTO sample.users
select * FROM shop.users WHERE id = 1;
COMMIT;


-- 2) Создайте представление, которое выводит название name товарной позиции из таблицы products
--    и соответствующее название каталога name из таблицы catalogs.

USE shop;
CREATE VIEW prod_cat AS
	SELECT p.name AS prod_name, c.name AS cat_name FROM products p
	INNER JOIN catalogs c
	ON p.catalog_id = c.id;
SELECT * FROM prod_cat;


-- 3) Пусть имеется таблица с календарным полем created_at.
--    В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17.
--    Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1,
--    если дата присутствует в исходном таблице и 0, если она отсутствует.


-- 4) Пусть имеется любая таблица с календарным полем created_at. Создайте запрос,
--    который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.

-- Нерабочий вариант - не срабатывает LIMIT:
DELETE FROM users
WHERE id NOT IN
(SELECT id FROM users
ORDER BY created_at DESC LIMIT 5);

-- Рабочий вариант через запрос:
PREPARE del FROM 'DELETE FROM users
ORDER BY created_at LIMIT ?';					-- запрос с сортировкой по возрастанию даты
SET @cnt := (SELECT COUNT(*) - 5 FROM users);	-- переменная определяет количество старых записей за минусом последних 5

EXECUTE del USING @cnt;							-- исполнение запроса с заданной переменной

-- ##########################################################################
-- 1) Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток.
--    С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу
--    "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

-- В консоли использовал delimiter, здесь прошло без него при поэтапном запуске
-- #############-1 вариант-###################
drop function if exists hello;

CREATE function hello()
returns text deterministic
begin
	declare hour int;
	set hour = hour(now());
	case 
		when hour between 6 and 11 then
		return 'Доброе утро';
		when hour between 12 and 17 then
		return 'Добрый день';
		when hour between 18 and 23 then
		return 'Добрый вечер';
		when hour between 0 and 5 then
		return 'Доброй ночи';
	end case;
end;

select hello();

-- #############-2 вариант-###################
drop function if exists hello;

CREATE function hello()
returns text deterministic
begin
	declare hour int;
	set hour = hour(now());
	if hour between 6 and 11 then
		return 'Доброе утро';
	elseif hour between 12 and 17 then
		return 'Добрый день';
	elseif hour between 18 and 23 then
		return 'Добрый вечер';
	else
		return 'Доброй ночи';
	end if;
end;

select hello();

-- 2) В таблице products есть два текстовых поля: name с названием товара и description с его описанием.
--    Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение
--    NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены.
--    При попытке присвоить полям NULL-значение необходимо отменить операцию.

create trigger stop_null before insert on products
for each row
begin
	if new.name is null and new.description is null then
		signal sqlstate '45000'
		set message_text = 'It is impossible to insert 2 NULL';
	end if;	
end;

insert into shop.products(name, description, price) values
(null, null, 9000);




