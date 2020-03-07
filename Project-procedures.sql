USE furniture_company;

-- Процедура, формирующая общую стоимость заказа исходя из количества и цены заказанных элементов:
DROP PROCEDURE IF EXISTS totaldue;
DELIMITER //

CREATE PROCEDURE totaldue()
BEGIN
	UPDATE orders o, (SELECT op.order_id AS id, sum(op.quantity * p.price) AS total FROM order_product op
	JOIN prices p ON op.item_id = p.item_id
	GROUP BY op.order_id) temp
	SET o.totaldue = temp.total
	WHERE o.id = temp.id;
END//

DELIMITER ;

CALL totaldue();


-- Процедура, обновляющая цену товара с учетом скидки в пределах категории и срока действия скидки:
DROP PROCEDURE IF EXISTS update_price;
DELIMITER //

CREATE PROCEDURE update_price()
BEGIN
	UPDATE prices p, (SELECT pr.id AS id, d.discount AS discount FROM prices p
	JOIN products pr ON p.item_id = pr.id
	JOIN discounts d ON d.category_id = pr.category_id
	WHERE d.discount < 1 AND now() BETWEEN d.date_start AND d.date_finish) AS disc
	SET p.price = p.price * disc.discount
	WHERE p.item_id = disc.id;
END//

DELIMITER ;

CALL update_price();


-- Процедура для расчета процента менеджеров от продаж за определенный период:
DROP PROCEDURE IF EXISTS bonus;
DELIMITER //

CREATE PROCEDURE bonus(datestart datetime, datefinish datetime)
BEGIN
	SELECT p.last_name, sum(totaldue), sum(totaldue) * 0.1 AS bonus FROM orders AS o
	JOIN managers AS m ON m.id = o.manager_id
	JOIN persons AS p ON p.id = m.person_id
	WHERE status_order = 'completed' AND order_date BETWEEN datestart AND datefinish
	GROUP BY manager_id;
END//

DELIMITER ;

CALL bonus('2019-12-01', '2020-03-31');


