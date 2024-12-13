
CREATE OR REPLACE FUNCTION exhibits_insert_or_update_trigger()
RETURNS TRIGGER AS $$
BEGIN

    PERFORM * FROM People WHERE person_id = NEW.owner_id;
    IF NOT FOUND THEN
        INSERT INTO People (person_id, person_name, person_status, contact_info)
        VALUES (NEW.owner_id, 'Имя неизвестно', 'владелец', 'не указан');
    END IF;

    IF NEW.museum_id IS NOT NULL THEN
        PERFORM * FROM Museums WHERE museum_id = NEW.museum_id;
        IF NOT FOUND THEN
            INSERT INTO Museums (museum_id, museum_name, museum_city, museum_country)
            VALUES (NEW.museum_id, 'Неизвестный музей', 'не указан', 'не указана');
        END IF;
    END IF;

    RETURN NEW;
    
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER exhibit_insert_update_trigger
AFTER INSERT OR UPDATE ON Exhibits
FOR EACH ROW
EXECUTE FUNCTION exhibits_insert_or_update_trigger();

CREATE OR REPLACE FUNCTION handle_auction_completion()
RETURNS TRIGGER AS $$
BEGIN
        INSERT INTO Actions (action_type, exhibit_id, action_address, action_date)
        VALUES ('аукцион', NEW.exhibit_id, 'Auction House', CURRENT_DATE)
        RETURNING action_id INTO NEW.action_id;

        UPDATE Exhibits
        SET exhibit_price = NEW.end_price
        WHERE exhibit_id = NEW.exhibit_id;

        RAISE NOTICE 'Auction for Exhibit ID % completed. Final price: %', NEW.exhibit_id, NEW.end_price;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER auction_completion_trigger
AFTER UPDATE ON Auctions
FOR EACH ROW
WHEN (OLD.auction_status IS DISTINCT FROM NEW.auction_status AND NEW.auction_status = 'завершен')
EXECUTE FUNCTION handle_auction_completion();