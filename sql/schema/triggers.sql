-- При изменении документа, поле last_change_time обновляется
CREATE OR REPLACE FUNCTION document_update_trigger()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_change_time := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_document_update
BEFORE UPDATE ON document
FOR EACH ROW
EXECUTE FUNCTION document_update_trigger();


-- При регистрации нового пользователя, об этом будет создана запись
CREATE OR REPLACE FUNCTION user_insert_trigger()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO action (id, action_time, user_id, action_type_id)
    VALUES (DEFAULT, CURRENT_TIMESTAMP, NEW.id, 1);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_user_insert
AFTER INSERT ON users
FOR EACH ROW
EXECUTE FUNCTION user_insert_trigger();


-- Запись о действиях в таблице document
CREATE OR REPLACE FUNCTION log_document_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO action (id, action_time, user_id, action_type_id)
        VALUES (DEFAULT, CURRENT_TIMESTAMP, NEW.author_id, 4);
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO action (id, action_time, user_id, action_type_id)
        VALUES (DEFAULT, CURRENT_TIMESTAMP, NEW.author_id, 5);
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO action (id, action_time, user_id, action_type_id)
        VALUES (DEFAULT, CURRENT_TIMESTAMP, OLD.author_id, 6);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER log_document_changes_trigger
AFTER INSERT OR UPDATE OR DELETE ON document
FOR EACH ROW
EXECUTE FUNCTION log_document_changes();


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

CREATE TRIGGER block_admin_role
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION block_admin_role();


-- Проверка прав доступа
CREATE OR REPLACE FUNCTION process_document()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') AND NEW.role_id NOT IN (1, 2) THEN
        RAISE EXCEPTION 'You do not have enough rights.';
    ELSIF TG_OP = 'DELETE' AND OLD.role_id NOT IN (1, 2) THEN
        RAISE EXCEPTION 'You do not have enough rights.';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER process_document
BEFORE INSERT OR UPDATE OR DELETE ON document
FOR EACH ROW
EXECUTE FUNCTION process_document();