
CREATE schema IF NOT EXISTS museum_management;

CREATE table IF NOT EXISTS People(
    person_id SERIAL PRIMARY KEY,
    person_name VARCHAR(100) NOT NULL,
    person_status VARCHAR(100) NOT NULL,
    contact_info VARCHAR(100) NOT NULL
);

CREATE table IF NOT EXISTS Museums(
    museum_id SERIAL PRIMARY KEY,
    museum_name VARCHAR(100) NOT NULL,
    museum_city VARCHAR(100) NOT NULL,
    museum_country VARCHAR(100) NOT NULL
);

CREATE table IF NOT EXISTS PeopleXMuseum(
    museum_id INT,
    person_id INT,
    PRIMARY KEY (museum_id, person_id),
    FOREIGN KEY (museum_id) REFERENCES Museums(museum_id) ON DELETE CASCADE,
    FOREIGN KEY (person_id) REFERENCES People(person_id) ON DELETE CASCADE
);

CREATE table IF NOT EXISTS Exhibits(
    exhibit_id SERIAL PRIMARY KEY,
    exhibit_type VARCHAR(100) NOT NULL,
    exhibit_name VARCHAR(100) NOT NULL,
    creator VARCHAR(100),
    creation_year VARCHAR(100) NOT NULL,
    storage_city VARCHAR(100) NOT NULL,
    museum_id INT,
    owner_id INT,
    exhibit_condition VARCHAR(100) NOT NULL,
    exhibit_price INT,
    FOREIGN KEY (museum_id, owner_id) REFERENCES PeopleXMuseum(museum_id, person_id)
);

CREATE table IF NOT EXISTS Actions(
    action_id SERIAL PRIMARY KEY,
    action_type VARCHAR(100) NOT NULL,
    exhibit_id INT NOT NULL,
    action_address VARCHAR(100) NOT NULL,
    action_date DATE NOT NULL,
    FOREIGN KEY (exhibit_id) REFERENCES Exhibits(exhibit_id)
);

CREATE table IF NOT EXISTS Ownership_History(
    exhibit_id INT NOT NULL,
    owner_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    PRIMARY KEY (exhibit_id, start_date),
    FOREIGN KEY (owner_id) REFERENCES People(person_id),
    FOREIGN KEY (exhibit_id) REFERENCES Exhibits(exhibit_id)
);

CREATE table IF NOT EXISTS Restorations(
    restoration_id SERIAL PRIMARY KEY,
    exhibit_id INT NOT NULL,
    restorer_id INT NOT NULL,
    sponsor_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    restoration_status VARCHAR(100) NOT NULL,
    return_readiness BOOLEAN NOT NULL,
    restoration_address VARCHAR(100) NOT NULL,
    FOREIGN KEY (exhibit_id) REFERENCES Exhibits(exhibit_id),
    FOREIGN KEY (restorer_id) REFERENCES People(person_id),
    FOREIGN KEY (sponsor_id) REFERENCES People(person_id)
);

CREATE table IF NOT EXISTS Auctions(
    auction_id SERIAL PRIMARY KEY,
    exhibit_id INT,
    sponsor_id INT,
    action_id INT,
    auction_status VARCHAR(100) NOT NULL,
    start_price INT,
    end_price INT,
    FOREIGN KEY (exhibit_id) REFERENCES Exhibits(exhibit_id),
    FOREIGN KEY (sponsor_id) REFERENCES People(person_id),
    FOREIGN KEY (action_id) REFERENCES Actions(action_id)
);

ALTER TABLE Exhibits ADD CONSTRAINT check_exhibit_price_positive CHECK (exhibit_price >= 0);

ALTER TABLE Auctions ADD CONSTRAINT check_start_price_positive CHECK (start_price >= 0);

ALTER TABLE Auctions ADD CONSTRAINT check_end_price_positive CHECK (end_price >= 0);

ALTER TABLE Restorations ADD CONSTRAINT check_start_date_before_end_date CHECK (start_date < end_date);

ALTER TABLE Ownership_History ADD CONSTRAINT check_start_date_before_end_date CHECK (start_date < end_date);

ALTER TABLE People ADD CONSTRAINT unique_contact_info UNIQUE (contact_info);

ALTER TABLE People ADD CONSTRAINT check_person_status CHECK (person_status IN ('спонсор', 'покупатель', 'продавец', 'представитель музея', 'владелец', 'реставратор'));

ALTER TABLE Auctions ADD CONSTRAINT check_auction_status CHECK (Auctions.auction_status IN ('запланирован', 'завершен', 'в процессе', 'отменен', 'приостановлен'));

ALTER TABLE Actions ADD CONSTRAINT check_action_type CHECK (action_type IN ('покупка', 'продажа', 'наследование', 'передача в музей', 'перемещение', 'аукцион', 'реставрация'));

ALTER TABLE Exhibits ADD CONSTRAINT check_exhibit_status CHECK (exhibit_condition IN ('требует реставрации', 'не требует реставрации', 'на реставрации'));
