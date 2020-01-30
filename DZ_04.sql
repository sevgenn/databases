-- ii. Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений в алфавитном порядке

SELECT DISTINCT vk.firstname from users
ORDER BY firstname ASC;

-- iii. Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных (поле is_active = false).
--      Предварительно добавить такое поле в таблицу profiles со значением по умолчанию = true (или 1)

ALTER TABLE vk.profiles ADD is_active BIT DEFAULT 1 NULL;	-- создание нового столбца	
UPDATE vk.profiles
SET is_active = 0
WHERE TIMESTAMPDIFF(YEAR,birthday,CURDATE()) < 18;			-- списал из документации

-- iv. Написать скрипт, удаляющий сообщения «из будущего» (дата позже сегодняшней)

DELETE FROM vk.messages
WHERE created_at > CURDATE();




