USE furniture_company;


--Представление для просмотра дефицита товара (соотношения между заказами и наличием на складе):
DROP VIEW IF EXISTS deficit;

CREATE OR REPLACE VIEW deficit AS
SELECT o.id AS order_id, op.item_id AS item_id, pr.item AS item, sum(op.quantity) AS necessary, sum(st.quantity) AS there_is FROM orders o
JOIN order_product op ON o.id = op.order_id
JOIN products pr ON pr.id = op.item_id
LEFT JOIN storehouse st ON st.item_id = op.item_id
WHERE o.status_order = 'agreed'
GROUP BY op.item_id;

SELECT necessary, there_is FROM deficit;


-- Представление для оценки статистики продаж разных категорий фасадов (по сумме продаж и количеству заказов):
DROP VIEW IF EXISTS category_statistic;

CREATE OR REPLACE VIEW category_statistic AS
SELECT t.cat AS category, sum(t.totaldue) AS totaldue, count(t.orders) AS count FROM
(SELECT DISTINCT c.id AS cat, o.totaldue, o.id AS orders  FROM orders o
JOIN order_product op ON op.order_id = o.id
JOIN products prd ON prd.id = op.item_id
RIGHT JOIN categories c ON c.id = prd.category_id
JOIN classes cl ON cl.id = c.class_id
WHERE cl.id = 1) AS t
GROUP BY t.cat
WITH ROLLUP;

SELECT * FROM category_statistic;


-- Представление для оценки статистики продаж по магазинам:
DROP VIEW IF EXISTS shop_statistic;

CREATE OR REPLACE VIEW shop_statistic AS
SELECT sh.name, sum(totaldue) FROM orders o
JOIN managers m ON m.id = o.manager_id
JOIN shops sh ON sh.id = m.shop_id
GROUP BY sh.name;

SELECT * FROM shop_statistic;
