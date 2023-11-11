-- Пользователи, родившиеся до 01.01.1980
SELECT * FROM profile
WHERE birth_date < '1980-01-01';

-- Документы, относящиеся к типу История культуры
SELECT * FROM document
WHERE doc_type_id = (SELECT id FROM doc_type WHERE name = 'Cultural history');

-- Пользователи, подписанные на коллекцию История Японии
SELECT ucl.*, u.login, c.name AS collection_name FROM user_collection_link ucl
JOIN users u ON ucl.user_id = u.id
JOIN collection c ON ucl.collection_id = c.id
WHERE ucl.is_subscribe = true AND c.name = 'History of Japan';

-- Пользователи, зарегестрировавшиеся в промежутке времени
SELECT * FROM action
WHERE action_type_id = (SELECT id FROM action_type WHERE name = 'Registration')
AND action_time BETWEEN '2023-10-24 12:00:00' AND '2023-10-24 13:00:00';

-- Документы из коллекции Важнейшие документы в истории
SELECT d.* FROM document d
JOIN collection_doc_link cdl ON d.id = cdl.document_id
JOIN collection c ON cdl.collection_id = c.id
WHERE c.name = 'Essential Documents in History';

-- Количество пользователей, подписанных на коллекции
SELECT c.name AS collection_name, COUNT(ucl.user_id) AS subscription_count
FROM collection c
LEFT JOIN user_collection_link ucl ON c.id = ucl.collection_id AND ucl.is_subscribe = true
GROUP BY c.name;

-- Документы, содержащие слово 'born'
SELECT * FROM document
WHERE LOWER(description) LIKE '%born%';

-- Фамилии, заканчивающиеся на n
SELECT * FROM profile
WHERE last_name ILIKE '%n';

-- Коллекции, на которые подписан 2-ой пользователь
SELECT c.name AS collection_name FROM collection c
JOIN user_collection_link ucl ON c.id = ucl.collection_id
WHERE ucl.user_id = 2 AND ucl.is_subscribe = true;