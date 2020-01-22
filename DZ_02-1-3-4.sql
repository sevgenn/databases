/* 1) Установите СУБД MySQL. Создайте в домашней директории файл .my.cnf,
      задав в нем логин и пароль, который указывался при установке.*/

-- И под Windows, и под  Linux у меня не разрешает вход без пароля.


/* 3) Создайте дамп базы данных example из предыдущего задания,
      разверните содержимое дампа в новую базу данных sample.*/

-- Создание дампа.
mysqldump -uroot -p example > ~/mysql/example_dump.sql

-- Создание новой базы sample и выгрузка дампа.
CREATE DATABASE IF NOT EXISTS sample;

mysql -u root -p sample < ~/mysql/example_dump.sql

-- При синтаксисе mysqldump -uroot -p --databases example > ~/mysql/example_dump.sql
-- предварительно создавать новую базу при развертывании не нужно...(говорят)
-- НО У МЕНЯ НЕ СРАБОТАЛО.

/* 4) Ознакомьтесь более подробно с документацией утилиты mysqldump.
      Создайте дамп единственной таблицы help_keyword базы данных mysql.
      Причем добейтесь того, чтобы дамп содержал только первые 100 строк таблицы.*/

-- Неудачная попытка:
mysqldump -uroot -p mysql help_keyword --where='limit 100' > ~/mysql/keyword_dump.sql
mysql -uroot -p help_keyword < ~/mysql/keyword_dump.sql
ERROR 3723 (HY000) at line 25: The table 'help_keyword' may not be created in the reserved tablespace 'mysql'.