
CREATE SCHEMA IF NOT EXISTS views;

CREATE OR REPLACE VIEW views.People AS
SELECT
    CONCAT(SUBSTRING(person_name FROM 1 FOR 1), '. ',
          SUBSTRING(SPLIT_PART(person_name, ' ', 2) FROM 1 FOR 1), '.') AS masked_person_name,
    person_status,
    CONCAT(SUBSTRING(contact_info from 1 for 1), 
          REPEAT('*', POSITION('@' in contact_info) - 2), 
          '@', 
          SUBSTRING(contact_info from POSITION('@' in contact_info) + 1)) as contact_info_masked
FROM People;

CREATE OR REPLACE VIEW views.Museums AS
SELECT 
    museum_name,
    museum_city,
    museum_country
FROM Museums;


CREATE OR REPLACE VIEW views.PeopleXMuseum AS
SELECT 
    museum_id,
    person_id
FROM PeopleXMuseum;


CREATE OR REPLACE VIEW views.Exhibits AS
SELECT 
    exhibit_type,
    exhibit_name,
    creator,
    creation_year,
    storage_city,
    museum_id,
    owner_id,
    exhibit_condition,
    CASE 
        WHEN exhibit_price >= 1000 THEN CONCAT(SUBSTRING(exhibit_price::TEXT, 1, LENGTH(exhibit_price::TEXT) - 3), '***')
        ELSE '***'
    END AS exhibit_price_masked
FROM Exhibits;


CREATE OR REPLACE VIEW views.Actions AS
SELECT 
    action_type,
    exhibit_id,
    action_address,
    action_date
FROM Actions;


CREATE OR REPLACE VIEW views.Ownership_History AS
SELECT 
    exhibit_id,
    owner_id,
    start_date,
    end_date
FROM Ownership_History;


CREATE OR REPLACE VIEW views.Restorations AS
SELECT 
    exhibit_id,
    restorer_id,
    sponsor_id,
    start_date,
    end_date,
    restoration_status,
    return_readiness,
    restoration_address
FROM Restorations;


CREATE OR REPLACE VIEW views.Auctions AS
SELECT 
    exhibit_id,
    sponsor_id,
    action_id,
    auction_status,
    start_price,
    end_price
FROM Auctions;