-- 1) � ���� ������ shop � sample ������������ ���� � �� �� �������, ������� ���� ������.
--    ����������� ������ id = 1 �� ������� shop.users � ������� sample.users. ����������� ����������.

-- �������� ���� sample � ������� users:
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

-- ���������� �� ����������� ������:
START TRANSACTION;
INSERT INTO sample.users
select * FROM shop.users WHERE id = 1;
COMMIT;


-- 2) �������� �������������, ������� ������� �������� name �������� ������� �� ������� products
--    � ��������������� �������� �������� name �� ������� catalogs.

USE shop;
CREATE VIEW prod_cat AS
	SELECT p.name AS prod_name, c.name AS cat_name FROM products p
	INNER JOIN catalogs c
	ON p.catalog_id = c.id;
SELECT * FROM prod_cat;


-- 3) ����� ������� ������� � ����������� ����� created_at.
--    � ��� ��������� ���������� ����������� ������ �� ������ 2018 ���� '2018-08-01', '2016-08-04', '2018-08-16' � 2018-08-17.
--    ��������� ������, ������� ������� ������ ������ ��� �� ������, ��������� � �������� ���� �������� 1,
--    ���� ���� ������������ � �������� ������� � 0, ���� ��� �����������.


-- 4) ����� ������� ����� ������� � ����������� ����� created_at. �������� ������,
--    ������� ������� ���������� ������ �� �������, �������� ������ 5 ����� ������ �������.

-- ��������� ������� - �� ����������� LIMIT:
DELETE FROM users
WHERE id NOT IN
(SELECT id FROM users
ORDER BY created_at DESC LIMIT 5);

-- ������� ������� ����� ������:
PREPARE del FROM 'DELETE FROM users
ORDER BY created_at LIMIT ?';					-- ������ � ����������� �� ����������� ����
SET @cnt := (SELECT COUNT(*) - 5 FROM users);	-- ���������� ���������� ���������� ������ ������� �� ������� ��������� 5

EXECUTE del USING @cnt;							-- ���������� ������� � �������� ����������

-- ##########################################################################
-- 1) �������� �������� ������� hello(), ������� ����� ���������� �����������, � ����������� �� �������� ������� �����.
--    � 6:00 �� 12:00 ������� ������ ���������� ����� "������ ����", � 12:00 �� 18:00 ������� ������ ���������� �����
--    "������ ����", � 18:00 �� 00:00 � "������ �����", � 00:00 �� 6:00 � "������ ����".

-- � ������� ����������� delimiter, ����� ������ ��� ���� ��� ��������� �������
-- #############-1 �������-###################
drop function if exists hello;

CREATE function hello()
returns text deterministic
begin
	declare hour int;
	set hour = hour(now());
	case 
		when hour between 6 and 11 then
		return '������ ����';
		when hour between 12 and 17 then
		return '������ ����';
		when hour between 18 and 23 then
		return '������ �����';
		when hour between 0 and 5 then
		return '������ ����';
	end case;
end;

select hello();

-- #############-2 �������-###################
drop function if exists hello;

CREATE function hello()
returns text deterministic
begin
	declare hour int;
	set hour = hour(now());
	if hour between 6 and 11 then
		return '������ ����';
	elseif hour between 12 and 17 then
		return '������ ����';
	elseif hour between 18 and 23 then
		return '������ �����';
	else
		return '������ ����';
	end if;
end;

select hello();

-- 2) � ������� products ���� ��� ��������� ����: name � ��������� ������ � description � ��� ���������.
--    ��������� ����������� ����� ����� ��� ���� �� ���. ��������, ����� ��� ���� ��������� �������������� ��������
--    NULL �����������. ��������� ��������, ��������� ����, ����� ���� �� ���� ����� ��� ��� ���� ���� ���������.
--    ��� ������� ��������� ����� NULL-�������� ���������� �������� ��������.

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




