-- Все атрибуты таблицы
SELECT * FROM users;

-- Исторические личности без фамилии
SELECT * FROM historical_figure
WHERE last_name IS NULL;

-- Пользователи, родившиеся до 01.01.1980
SELECT * FROM profile
WHERE birth_date < '1980-01-01';

-- Пользователи, зарегестрировавшиеся в промежутке времени
SELECT * FROM action
WHERE action_type_id = (SELECT id FROM action_type WHERE name = 'Registration')
AND action_time BETWEEN '2023-10-24 12:00:00' AND '2023-10-24 13:00:00';

-- Документы, относящиеся к типу История культуры
SELECT * FROM document
WHERE doc_type_id = (SELECT id FROM doc_type WHERE name = 'Cultural history');

-- Документы, содержащие слово 'born'
SELECT * FROM document
WHERE LOWER(description) LIKE '%born%';

-- Фамилии, содержащие о
SELECT * FROM profile
WHERE last_name ILIKE '%о%';

-- Уникальные значения атрибута
SELECT DISTINCT is_subscribe
FROM user_collection_link;

-- Вывести 5 строк, отсортированных по убыванию, начиная с 3
SELECT * FROM action
ORDER BY user_id DESC
LIMIT 5 OFFSET 3;

-- Выбрать действия 5 и 7 пользователя
SELECT * FROM action
WHERE user_id NOT IN (5, 7);
