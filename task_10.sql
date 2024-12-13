
CREATE OR REPLACE PROCEDURE move_exhibit_by_museum_name(
    p_exhibit_id INT,          
    p_new_museum_name VARCHAR 
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_new_museum_id INT;        
    v_old_museum_id INT;        
    v_new_owner_id INT;
    v_new_city VARCHAR;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Exhibits WHERE exhibit_id = p_exhibit_id) THEN
        RAISE EXCEPTION 'Exhibit with ID % does not exist', p_exhibit_id;
    END IF;

    SELECT museum_id INTO v_old_museum_id
    FROM Exhibits
    WHERE exhibit_id = p_exhibit_id;

    SELECT museum_id, museum_city INTO v_new_museum_id, v_new_city
    FROM Museums
    WHERE museum_name = p_new_museum_name;

    IF NOT FOUND THEN
        INSERT INTO Museums (museum_name, museum_city, museum_country)
        VALUES (p_new_museum_name, 'не указан', 'не указана')
        RETURNING museum_id, museum_city INTO v_new_museum_id, v_new_city;
    END IF;

    IF v_old_museum_id IS DISTINCT FROM v_new_museum_id THEN
        SELECT person_id INTO v_new_owner_id
        FROM PeopleXMuseum
        WHERE museum_id = v_new_museum_id
        LIMIT 1;

        IF FOUND THEN
            UPDATE Exhibits
            SET owner_id = v_new_owner_id
            WHERE exhibit_id = p_exhibit_id;
        ELSE
            UPDATE Exhibits
            SET owner_id = NULL
            WHERE exhibit_id = p_exhibit_id;
        END IF;

        UPDATE Exhibits
        SET museum_id = v_new_museum_id, storage_city = v_new_city
        WHERE exhibit_id = p_exhibit_id;

        INSERT INTO Actions (action_type, exhibit_id, action_address, action_date)
        VALUES ('перемещение', p_exhibit_id, p_new_museum_name || ', ' || v_new_city, CURRENT_DATE);
    ELSE
        RAISE NOTICE 'Exhibit ID % is already in Museum ID %. No changes made.', p_exhibit_id, v_new_museum_id;
    END IF;
END;
$$;

ALTER TABLE Exhibits
DROP CONSTRAINT exhibits_museum_id_owner_id_fkey;

CALL move_exhibit_by_museum_name(1, 'Метрополитен-музей');

--

CREATE OR REPLACE PROCEDURE transfer_exhibit_to_new_owner(
    p_exhibit_id INT,
    p_new_owner_id INT
)
LANGUAGE plpgsql AS $$
DECLARE
    v_previous_owner_id INT;
    v_start_date DATE;
    v_end_date DATE;
    v_new_museum_id INT;
BEGIN
    SELECT owner_id INTO v_previous_owner_id
    FROM Exhibits
    WHERE exhibit_id = p_exhibit_id;

    IF v_previous_owner_id IS NOT NULL THEN
        SELECT end_date INTO v_end_date
        FROM Ownership_History
        WHERE exhibit_id = p_exhibit_id AND owner_id = v_previous_owner_id
        ORDER BY start_date DESC
        LIMIT 1;

        IF v_end_date IS NOT NULL THEN
            INSERT INTO Ownership_History (exhibit_id, owner_id, start_date, end_date)
            VALUES (p_exhibit_id, v_previous_owner_id, v_end_date, CURRENT_DATE);
        END IF;
    END IF;
    
    SELECT museum_id INTO v_new_museum_id
    FROM PeopleXMuseum
    WHERE person_id = p_new_owner_id
    LIMIT 1;

     UPDATE Exhibits
    SET owner_id = p_new_owner_id,
        museum_id = v_new_museum_id
    WHERE exhibit_id = p_exhibit_id;

END;
$$;

CALL transfer_exhibit_to_new_owner(8, 5);
