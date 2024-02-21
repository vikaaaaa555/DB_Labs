create or replace procedure "insert_into_table"
    (p_table_name in varchar2, p_id in number, p_val in number)
is
begin
    execute immediate 'INSERT INTO ' || p_table_name || ' (id, val) VALUES (:1, :2)'
    using p_id, p_val;
    commit;
end;
/


create or replace procedure "update_table"
    (p_table_name in varchar2, p_id in number, p_new_val in number)
is
begin
    execute immediate 'UPDATE ' || p_table_name || ' SET val = :1 WHERE id = :2'
    using p_new_val, p_id;
    commit;
end;
/


create or replace procedure "delete_from_table"
    (p_table_name in varchar2, p_id in number)
is
begin
    execute immediate 'DELETE FROM ' || p_table_name || ' WHERE id = :1'
    using p_id;
    commit;
end;
/
