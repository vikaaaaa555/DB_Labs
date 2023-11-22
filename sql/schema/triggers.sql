-- При изменении документа, поле last_change_time обновляется
CREATE OR REPLACE FUNCTION document_update_trigger()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_change_time := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER before_document_update
BEFORE UPDATE ON document
FOR EACH ROW
EXECUTE FUNCTION document_update_trigger();


-- Ошибка при попытке назначить нового админа
CREATE OR REPLACE FUNCTION block_admin_role()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.role_id = 1 THEN
        RAISE EXCEPTION 'Cannot update user role to admin.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER block_admin_role
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION block_admin_role();


-- При регистрации создается профиль
CREATE OR REPLACE FUNCTION create_user_profile()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO profile (user_id) VALUES (NEW.id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER create_profile_trigger
AFTER INSERT ON users
FOR EACH ROW
EXECUTE FUNCTION create_user_profile();


------------
----Логи----
------------

-- Мониторинг действий над пользователем
CREATE OR REPLACE FUNCTION user_change_trigger()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- Вставка
        INSERT INTO action (id, action_time, user_id, action_type_id)
        VALUES (DEFAULT, CURRENT_TIMESTAMP, NEW.id, 1);
    ELSIF TG_OP = 'UPDATE' THEN
        -- Обновление
        INSERT INTO action (id, action_time, user_id, action_type_id)
        VALUES (DEFAULT, CURRENT_TIMESTAMP, NEW.id, 7);
    ELSIF TG_OP = 'DELETE' THEN
        -- Удаление
        INSERT INTO action (id, action_time, user_id, action_type_id)
        VALUES (DEFAULT, CURRENT_TIMESTAMP, OLD.id, 8);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER user_change_trigger
AFTER INSERT OR UPDATE OR DELETE ON users
FOR EACH ROW
EXECUTE FUNCTION user_change_trigger();


-- Запись о действиях в таблице document
CREATE OR REPLACE FUNCTION log_document_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO action (action_time, user_id, action_type_id)
        VALUES (CURRENT_TIMESTAMP, NEW.author_id, 4);
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO action (action_time, user_id, action_type_id)
        VALUES (CURRENT_TIMESTAMP, NEW.author_id, 5);
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO action (action_time, user_id, action_type_id)
        VALUES (CURRENT_TIMESTAMP, OLD.author_id, 6);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER log_document_changes_trigger
AFTER INSERT OR UPDATE OR DELETE ON document
FOR EACH ROW
EXECUTE FUNCTION log_document_changes();


-- Мониторинг действий с коллекциями
CREATE OR REPLACE FUNCTION log_collection_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO action (action_time, user_id, action_type_id)
        VALUES (CURRENT_TIMESTAMP, NEW.author_id, 9);
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO action (action_time, user_id, action_type_id)
        VALUES (CURRENT_TIMESTAMP, NEW.author_id, 10);
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO action (action_time, user_id, action_type_id)
        VALUES (CURRENT_TIMESTAMP, OLD.author_id, 11);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER log_collection_changes_trigger
AFTER INSERT OR UPDATE OR DELETE ON collection
FOR EACH ROW
EXECUTE FUNCTION log_collection_changes();


-- Мониторинг действий со странами
CREATE OR REPLACE FUNCTION log_country_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO action (action_time, user_id, action_type_id)
        VALUES (CURRENT_TIMESTAMP, NEW.author_id, 15);
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO action (action_time, user_id, action_type_id)
        VALUES (CURRENT_TIMESTAMP, NEW.author_id, 16);
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO action (action_time, user_id, action_type_id)
        VALUES (CURRENT_TIMESTAMP, OLD.author_id, 17);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER log_country_changes_trigger
AFTER INSERT OR UPDATE OR DELETE ON country
FOR EACH ROW
EXECUTE FUNCTION log_country_changes();


-- Мониторинг действий с историческими личностями
CREATE OR REPLACE FUNCTION log_historical_figure_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO action (action_time, user_id, action_type_id)
        VALUES (CURRENT_TIMESTAMP, NEW.author_id, 12);
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO action (action_time, user_id, action_type_id)
        VALUES (CURRENT_TIMESTAMP, NEW.author_id, 13);
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO action (action_time, user_id, action_type_id)
        VALUES (CURRENT_TIMESTAMP, OLD.author_id, 14);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER log_historical_figure_changes_trigger
AFTER INSERT OR UPDATE OR DELETE ON historical_figure
FOR EACH ROW
EXECUTE FUNCTION log_historical_figure_changes();
