create or replace function "even_or_odd_count"
return varchar2 is
    v_even_count number := 0;
    v_odd_count number := 0;
begin
    select count(case when mod(VAL, 2) = 0 then 1 end),
           count(case when mod(VAL, 2) != 0 then 1 end)
    into v_even_count, v_odd_count from "MyTable";

    if v_even_count > v_odd_count then
        return 'TRUE';

    elsif v_even_count < v_odd_count then
        return 'FALSE';

    else
        return 'EQUAL';
    end if;
end;
/


create or replace function "generate_insert_command"
    (p_id number)
return varchar2 is
    v_insert_command varchar2(4000);
begin
    v_insert_command := 'INSERT INTO MyTable (id, val) VALUES (' || p_id || ', <your_value>);';

    DBMS_OUTPUT.PUT_LINE(v_insert_command);

    return v_insert_command;
end;
/

CREATE OR REPLACE FUNCTION calculate_annual_compensation
    (p_monthly_salary IN NUMBER, p_annual_bonus_rate IN NUMBER)
RETURN NUMBER IS
    v_annual_compensation NUMBER;
BEGIN
    IF p_monthly_salary IS NULL OR p_monthly_salary <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Месячная зарплата должна быть больше нуля.');
    END IF;

    IF p_annual_bonus_rate IS NULL THEN
        RAISE_APPLICATION_ERROR(-20002, 'Процент годовых премиальных не может быть пустым.');
    END IF;

    IF p_annual_bonus_rate < 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Процент годовых премиальных не может быть отрицательным.');
    END IF;

    p_annual_bonus_rate := p_annual_bonus_rate / 100;
    v_annual_compensation := (1 + p_annual_bonus_rate) * 12 * p_monthly_salary;

    RETURN v_annual_compensation;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20004, 'Произошла ошибка: ' || SQLERRM);
    RETURN NULL;
END;
/

DECLARE
    v_monthly_salary NUMBER := 5000;
    v_annual_bonus_rate NUMBER := 10;
    v_annual_compensation NUMBER;
BEGIN
    v_annual_compensation := calculate_annual_compensation(v_monthly_salary, v_annual_bonus_rate);

    DBMS_OUTPUT.PUT_LINE('Общее годовое вознаграждение: ' || v_annual_compensation);
END;
/
