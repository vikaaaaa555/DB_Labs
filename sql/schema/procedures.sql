-- Создать нового пользователя и профиль
CREATE OR REPLACE PROCEDURE add_new_user(
    p_login VARCHAR(20),
    p_password VARCHAR(20),
    p_role_id SMALLINT,
    p_first_name VARCHAR(30),
    p_last_name VARCHAR(30),
    p_email VARCHAR(30),
    p_phone_number VARCHAR(20),
    p_birth_date DATE
)
AS $$
DECLARE
    v_user_id INT;
BEGIN
    -- Вставка нового пользователя
    INSERT INTO users (login, password, role_id)
    VALUES (p_login, p_password, p_role_id)
    RETURNING id INTO v_user_id;

    -- Вставка профиля пользователя
    INSERT INTO profile (user_id, first_name, last_name, email, phone_number, birth_date)
    VALUES (v_user_id, p_first_name, p_last_name, p_email, p_phone_number, p_birth_date);
END;
$$ LANGUAGE plpgsql;


-- Подписка на коллекцию
CREATE OR REPLACE PROCEDURE subscribe_to_collection(
    p_user_id SMALLINT,
    p_collection_id SMALLINT
)
AS $$
BEGIN
    INSERT INTO user_collection_link (user_id, collection_id, is_subscribe)
    VALUES (p_user_id, p_collection_id, true);
END;
$$ LANGUAGE plpgsql;


-- Обновить информацию о стране
CREATE OR REPLACE PROCEDURE update_country_info(
    p_country_id SMALLINT,
    p_name VARCHAR(40),
    p_capital VARCHAR(30),
    p_state_system_id SMALLINT
)
AS $$
BEGIN
    UPDATE country
    SET
	name = COALESCE(p_name, name),
	capital = COALESCE(p_capital, capital),
	state_system_id = COALESCE(p_state_system_id, state_system_id)
    WHERE id = p_country_id;
END;
$$ LANGUAGE plpgsql;


-- Обновление информации о документе
CREATE OR REPLACE PROCEDURE update_document(
    p_document_id SMALLINT,
    p_title VARCHAR(50),
    p_description TEXT,
    p_doc_type_id SMALLINT,
    p_author_id SMALLINT
)
AS $$
BEGIN
    -- Обновление информации о документе
    UPDATE document
    SET
        title = COALESCE(p_title, title),
        description = COALESCE(p_description, description),
        doc_type_id = COALESCE(p_doc_type_id, doc_type_id),
        author_id = COALESCE(p_author_id, author_id)
    WHERE id = p_document_id;
END;
$$ LANGUAGE plpgsql;