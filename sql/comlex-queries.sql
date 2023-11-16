-- Пользователи, подписанные на коллекцию История Японии
SELECT
    ucl.*,
    u.login,
    c.name AS collection_name
FROM
    user_collection_link ucl
JOIN users u ON ucl.user_id = u.id
JOIN collection c ON ucl.collection_id = c.id
WHERE
    ucl.is_subscribe = true AND c.name = 'History of Japan';


-- Документы из коллекции Важнейшие документы в истории
SELECT
    d.* FROM document d
JOIN collection_doc_link cdl ON d.id = cdl.document_id
JOIN collection c ON cdl.collection_id = c.id
WHERE
    c.name = 'Essential Documents in History';


-- Количество пользователей, подписанных на коллекции
SELECT 
    c.name AS collection_name,
    COUNT(ucl.user_id) AS subscription_count
FROM
    collection c
LEFT JOIN user_collection_link ucl ON c.id = ucl.collection_id
AND ucl.is_subscribe = true
GROUP BY
    c.name;


-- Коллекции, на которые подписан 2-ой пользователь
SELECT
    c.name AS collection_name
FROM
    collection c
JOIN user_collection_link ucl ON c.id = ucl.collection_id
WHERE
    ucl.user_id = 2 AND ucl.is_subscribe = true;


-- Список пользователей с кол-вом коллекций и документов на которые они подписаны
SELECT 
    u.login,
    COUNT(DISTINCT ucl.collection_id) AS subscribed_collections,
    COUNT(DISTINCT cdl.document_id) AS total_documents
FROM
    users u
LEFT JOIN user_collection_link ucl ON u.id = ucl.user_id
LEFT JOIN collection_doc_link cdl ON ucl.collection_id = cdl.collection_id
GROUP BY
    u.login;


-- Кол-во действий, выполненных каждым пользователем
SELECT 
    u.id as user_id,
    u.login,
    COUNT(DISTINCT a.id) AS total_actions
FROM
    users u
LEFT JOIN action a ON u.id = a.user_id
GROUP BY
    u.id;


-- Среднее кол-ва подписчиков на коллекцию
SELECT 
    AVG(subscribed_users) AS avg_subscribers_per_collection
FROM (
    SELECT 
        c.id as collection_id,
        COUNT(DISTINCT ucl.user_id) AS subscribed_users
    FROM collection c
    LEFT JOIN user_collection_link ucl ON c.id = ucl.collection_id
    GROUP BY c.id
) AS collection_subscribers;


-- Кол-во документов в каждой коллекции
SELECT 
    c.name AS collection_name,
    COUNT(cdl.document_id) OVER (PARTITION BY c.id) AS document_count
FROM
    collection c
LEFT JOIN collection_doc_link cdl ON c.id = cdl.collection_id;


-- Кол-во статей авторов
SELECT 
	p.first_name,
	p.last_name,
	COUNT(author_id) AS quantity_of_document
FROM
	users u
LEFT JOIN profile p ON u.id = p.user_id
LEFT JOIN document d ON u.id = d.author_id
WHERE
	u.role_id IN (1, 2)
GROUP BY
	p.first_name, p.last_name
HAVING
	COUNT(author_id) > 0
ORDER BY
	quantity_of_document DESC


-- Кол-во действий каждого типа которые выполнены пользователями
SELECT
	at.id, at.name AS action_name,
	COUNT(a.action_type_id) AS type_count
FROM
	action_type at
JOIN action a ON a.action_type_id = at.id
GROUP BY
	action_name,
	at.id
ORDER BY
	at.id DESC
