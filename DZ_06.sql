-- 1) Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека,
--    который больше всех общался с нашим пользователем.

SELECT u.id, u.firstname, u.lastname, COUNT(m.id) from users u
INNER JOIN friend_requests fr
ON (fr.target_user_id = u.id OR fr.initiator_user_id = u.id) AND (fr.target_user_id = 1 OR fr.initiator_user_id = 1)
AND fr.status = 'approved' AND u.id <> 1
INNER JOIN messages m
ON (m.from_user_id = u.id OR m.to_user_id = u.id) AND (m.from_user_id = 1 OR m.to_user_id = 1)
GROUP BY u.id
ORDER BY COUNT(m.id) DESC
LIMIT 1;


-- 2) одсчитать общее количество лайков, которые получили пользователи младше 10 лет:

SELECT COUNT(*) FROM likes l
INNER JOIN profiles p
ON p.user_id = l.user_id
AND YEAR(NOW())- YEAR(p.birthday) < 10
GROUP BY l.user_id;


-- 3) Определить кто больше поставил лайков (всего) - мужчины или женщины?

SELECT p.gender, COUNT(*) c FROM likes l
INNER JOIN profiles p
ON l.user_id = p.user_id AND p.gender = 'm'
UNION 
SELECT p.gender, COUNT(*) c FROM likes l
INNER JOIN profiles p
ON l.user_id = p.user_id AND p.gender = 'w'
GROUP BY p.gender
ORDER BY c DESC;
-- LIMIT 1;










