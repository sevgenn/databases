/* � �� ��������� � ��� ����� � ������� �������������,
   ������� ������ ��������� ��������� ������� */

USE vk;
DROP TABLE IF EXISTS music;
CREATE TABLE music (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	media_id BIGINT UNSIGNED NOT NULL,
	
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (media_id) REFERENCES media(id)
);

DROP TABLE IF EXISTS tags;
CREATE TABLE tags (
	id SERIAL PRIMARY KEY,
	tag VARCHAR(255),
	
	INDEX tags_tag_idx(tag)		-- индекс, по-моему, не нужен, присутствует только для того, чтоб был (по заданию)
);

DROP TABLE IF EXISTS tags_photos;	-- тэги к фотографиям
CREATE TABLE tags_photos (
	id SERIAL PRIMARY KEY,
	photo_id BIGINT UNSIGNED NOT NULL,
	tag_id BIGINT UNSIGNED NOT NULL,
	
	FOREIGN KEY (photo_id) REFERENCES photos(id),
	FOREIGN KEY (tag_id) REFERENCES tags(id)
);

DROP TABLE IF EXISTS games;
CREATE TABLE games (
	id SERIAL PRIMARY KEY,
	filename VARCHAR(255),
    size INT,
	metadata JSON
);

DROP TABLE IF EXISTS user_games;
CREATE TABLE user_games (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	game_id BIGINT UNSIGNED NOT NULL,
	
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (game_id) REFERENCES games(id)
);