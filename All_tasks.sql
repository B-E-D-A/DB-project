--3

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

--4 

INSERT INTO People (person_name, person_status, contact_info) VALUES
('Иван Иванов', 'представитель музея', 'ivan@mail.com'),
('Анна Шмидт', 'представитель музея', 'anna.schmidt@kunsthistorisches-museum.at'),
('Джон Смит', 'представитель музея', 'john.smith@metmuseum.org'),
('Сергей Сергеев', 'спонсор', 'sergey@mail.com'),
('Ольга Петрова', 'реставратор', 'olga@mail.com'),
('Эмма Джонсон', 'представитель музея', 'emma.johnson@museumoffinearts.org'),
('Алексей Крутой', 'владелец', 'anna@mail.com'),
('Дмитрий Кузнецов', 'продавец', 'dmitry@mail.com'),
('Елена Васильева', 'владелец', 'elena@mail.com'),
('Катрин Дюпонт', 'представитель музея', 'catherine.dupont@louvre.fr'),
('Александр Попов', 'покупатель', 'alexander@mail.com');

INSERT INTO Museums ( museum_name, museum_city, museum_country) VALUES
('Музей истории искусств', 'Вена', 'Австрия'),
('Государственный Эрмитаж', 'Санкт-Петербург', 'Россия'),
('Лувр', 'Париж', 'Франция'),
('Метрополитен-музей', 'Нью-Йорк', 'США'),
('Музей изящных искусств', 'Бостон', 'США'),
('Московский музей изобразительных искусств', 'Москва', 'Россия'); 

INSERT INTO PeopleXMuseum (museum_id, person_id) VALUES
((SELECT museum_id FROM Museums WHERE museum_name = 'Музей истории искусств' AND museum_city = 'Вена'), (SELECT person_id FROM People WHERE person_name = 'Анна Шмидт')),
((SELECT museum_id FROM Museums WHERE museum_name = 'Государственный Эрмитаж'), (SELECT person_id FROM People WHERE person_name = 'Иван Иванов')),
((SELECT museum_id FROM Museums WHERE museum_name = 'Лувр'), (SELECT person_id FROM People WHERE person_name = 'Катрин Дюпонт')),
((SELECT museum_id FROM Museums WHERE museum_name = 'Метрополитен-музей'), (SELECT person_id FROM People WHERE person_name = 'Джон Смит')),
((SELECT museum_id FROM Museums WHERE museum_name = 'Музей изящных искусств'),  (SELECT person_id FROM People WHERE person_name = 'Эмма Джонсон')),
((SELECT museum_id FROM Museums WHERE museum_name = 'Московский музей изобразительных искусств'),  (SELECT person_id FROM People WHERE person_name = 'Иван Иванов'));


INSERT INTO Exhibits (exhibit_type, exhibit_name, creator, creation_year, storage_city, museum_id, owner_id, exhibit_condition, exhibit_price) VALUES
(
    'Картина', 
    'Водяные лилии',
    'Клод Моне', 
    1890, 
    'Париж', 
    (SELECT museum_id FROM Museums WHERE museum_name = 'Лувр'), 
    (SELECT person_id FROM PeopleXMuseum WHERE museum_id = (SELECT museum_id FROM Museums WHERE museum_name = 'Лувр') LIMIT 1), 
    'требует реставрации', 
    50000
),
(
    'Картина', 
    'Кувшинки в Живерии',
    'Клод Моне', 
    1865, 
    'Париж', 
    (SELECT museum_id FROM Museums WHERE museum_name = 'Лувр'), 
    (SELECT person_id FROM PeopleXMuseum WHERE museum_id = (SELECT museum_id FROM Museums WHERE museum_name = 'Лувр') LIMIT 1), 
    'требует реставрации', 
    75000
),
(
    'Картина', 
    'Пристань Лувра',
    'Клод Моне', 
    1867, 
    'Париж', 
    (SELECT museum_id FROM Museums WHERE museum_name = 'Лувр'), 
    (SELECT person_id FROM PeopleXMuseum WHERE museum_id = (SELECT museum_id FROM Museums WHERE museum_name = 'Лувр') LIMIT 1), 
    'требует реставрации', 
    90000
),
(
    'Скульптура', 
    'Давид',
    'Микеланджело', 
    1501, 
    'Нью-Йорк', 
    (SELECT museum_id FROM Museums WHERE museum_name = 'Метрополитен-музей'), 
    (SELECT person_id FROM PeopleXMuseum WHERE museum_id = (SELECT museum_id FROM Museums WHERE museum_name = 'Метрополитен-музей') LIMIT 1), 
    'требует реставрации', 
    300000
),
(
    'Картина', 
    'Сотворение Адама',
    'Микеланджело', 
    1511, 
    'Нью-Йорк', 
    (SELECT museum_id FROM Museums WHERE museum_name = 'Метрополитен-музей'), 
    (SELECT person_id FROM PeopleXMuseum WHERE museum_id = (SELECT museum_id FROM Museums WHERE museum_name = 'Метрополитен-музей') LIMIT 1), 
    'требует реставрации', 
    30000000
),
(
    'Гравюра', 
    'Страшный суд',
    'Микеланджело', 
    1541, 
    'Вена', 
    (SELECT museum_id FROM Museums WHERE museum_name = 'Музей истории искусств'), 
    (SELECT person_id FROM PeopleXMuseum WHERE museum_id = (SELECT museum_id FROM Museums WHERE museum_name = 'Музей истории искусств') LIMIT 1), 
    'требует реставрации', 
    20000000
),
(
    'Икона', 
    'Богоматерь Владимирская',
    'Аэлит', 
    1700, 
    'Вена', 
    (SELECT museum_id FROM Museums WHERE museum_name = 'Музей истории искусств'), 
    (SELECT person_id FROM PeopleXMuseum WHERE museum_id = (SELECT museum_id FROM Museums WHERE museum_name = 'Музей истории искусств') LIMIT 1), 
    'на реставрации', 
    15000
),
(
    'Гравюра', 
    'Поцелуй',
    'Густав Климт', 
    1900, 
    'Вена', 
    NULL, 
    (SELECT person_id FROM People WHERE person_name = 'Алексей Крутой'), 
    'на реставрации', 
    25000
),
(
    'Ваза', 
    'Ваза Минг',
    'Неизвестный мастер', 
    1400, 
    'Пекин', 
    NULL,
    (SELECT person_id FROM People WHERE person_name = 'Алексей Крутой'), 
    'не требует реставрации', 
    50000
);

-- Продажа
INSERT INTO Actions (action_type, exhibit_id, action_address, action_date) VALUES
(
    'продажа', 
    (SELECT exhibit_id FROM Exhibits WHERE exhibit_name = 'Водяные лилии'),
    'Лувр, Париж',
    '2021-06-15'
);

-- Реставрация
INSERT INTO Actions (action_type, exhibit_id, action_address, action_date) VALUES
(
    'реставрация', 
    (SELECT exhibit_id FROM Exhibits WHERE exhibit_name = 'Богоматерь Владимирская'),
    'Реставрационная мастерская, Вена',
    '2021-09-17'
);

-- Покупка
INSERT INTO Actions (action_type, exhibit_id, action_address, action_date) VALUES
(
    'покупка', 
    (SELECT exhibit_id FROM Exhibits WHERE exhibit_name = 'Поцелуй' AND exhibit_type='Гравюра'),
    'Метрополитен-музей, Нью-Йорк',
    '2021-07-20'
);

-- Реставрация
INSERT INTO Actions (action_type, exhibit_id, action_address, action_date) VALUES
(
    'реставрация', 
    (SELECT exhibit_id FROM Exhibits WHERE exhibit_name = 'Поцелуй' AND exhibit_type='Гравюра'),
    'Реставрационная мастерская, Вена',
    '2021-09-17'
);

-- Передача в музей
INSERT INTO Actions (action_type, exhibit_id, action_address, action_date) VALUES
(
    'передача в музей', 
    (SELECT exhibit_id FROM Exhibits WHERE exhibit_name = 'Поцелуй' AND exhibit_type='Гравюра'),
    'Музей истории искусств, Вена',
    '2021-12-12'
);

-- Аукцион
INSERT INTO Actions (action_type, exhibit_id, action_address, action_date) VALUES
(
    'аукцион', 
    (SELECT exhibit_id FROM Exhibits WHERE exhibit_name = 'Ваза Минг'),
    'Аукционный дом Sotheby, Лондон',
    '2022-08-05'
);

INSERT INTO Actions (action_type, exhibit_id, action_address, action_date) VALUES
(
    'аукцион', 
    (SELECT exhibit_id FROM Exhibits WHERE exhibit_name = 'Страшный суд'),
    'Аукционный дом Sotheby, Лондон',
    '2022-08-05'
);

-- Передача в музей
INSERT INTO Actions (action_type, exhibit_id, action_address, action_date) VALUES
(
    'передача в музей', 
    (SELECT exhibit_id FROM Exhibits WHERE exhibit_name = 'Богоматерь Владимирская'),
    'Музей истории искусств, Вена',
    '2022-02-20'
);

INSERT INTO Ownership_History (exhibit_id, owner_id, start_date, end_date) VALUES
(
    (SELECT exhibit_id FROM Exhibits WHERE exhibit_name = 'Поцелуй' AND exhibit_type='Гравюра'),
    (SELECT person_id FROM People WHERE person_name = 'Елена Васильева'),
    '2020-05-14',
    '2021-07-20'
),
(
    (SELECT exhibit_id FROM Exhibits WHERE exhibit_name = 'Поцелуй' AND exhibit_type='Гравюра'),
    (SELECT person_id FROM People WHERE person_name = 'Алексей Крутой'),
    '2021-07-20',
    '2021-12-12'
),
(
    (SELECT exhibit_id FROM Exhibits WHERE exhibit_name = 'Ваза Минг'),
    (SELECT person_id FROM People WHERE person_name = 'Дмитрий Кузнецов'),
    '2018-03-10',
    '2022-08-05'
),
(
    (SELECT exhibit_id FROM Exhibits WHERE exhibit_name = 'Водяные лилии'),
    (SELECT person_id FROM People WHERE person_name = 'Елена Васильева'),
    '2019-06-01',
    '2021-06-15'
),
(
    (SELECT exhibit_id FROM Exhibits WHERE exhibit_name = 'Богоматерь Владимирская'),
    (SELECT person_id FROM PeopleXMuseum WHERE museum_id = (SELECT museum_id FROM Museums WHERE museum_name = 'Государственный Эрмитаж') LIMIT 1),
    '2010-01-01',
    '2022-02-20'
);

INSERT INTO Restorations (exhibit_id, restorer_id, sponsor_id, start_date, end_date, restoration_status, return_readiness, restoration_address) VALUES
(
    (SELECT exhibit_id FROM Exhibits WHERE exhibit_name = 'Богоматерь Владимирская'),
    (SELECT person_id FROM People WHERE person_name = 'Ольга Петрова' AND person_status = 'реставратор'),
    (SELECT person_id FROM People WHERE person_name = 'Сергей Сергеев'),
    '2024-06-01',
    NULL,
    'в процессе',
    FALSE,
    'Реставрационная мастерская, Вена'
),
(
    (SELECT exhibit_id FROM Exhibits WHERE exhibit_name = 'Поцелуй'),
    (SELECT person_id FROM People WHERE person_name = 'Ольга Петрова' AND person_status = 'реставратор'),
    (SELECT person_id FROM People WHERE person_name = 'Сергей Сергеев'),
    '2021-09-17',
    '2021-10-30',
    'завершен',
    TRUE,
    'Реставрационная мастерская, Вена'
);

INSERT INTO Auctions (exhibit_id, sponsor_id, action_id, auction_status, start_price, end_price) VALUES
(
    (SELECT exhibit_id FROM Exhibits WHERE exhibit_name = 'Ваза Минг'),
    NULL,
    (SELECT action_id FROM Actions WHERE action_type = 'аукцион' AND action_date='2022-08-05' AND action_address='Аукционный дом Sotheby, Лондон' 
    and exhibit_id = (SELECT exhibit_id FROM Exhibits WHERE exhibit_name = 'Ваза Минг')),
    'завершен',
    50000,
    157000
),
(
    NULL,
    NULL,
    NULL,
    'запланирован',
    0,
    0
),
(
    (SELECT exhibit_id FROM Exhibits WHERE exhibit_name = 'Давид' AND exhibit_type='Скульптура'),
    (SELECT person_id FROM People WHERE person_name = 'Сергей Сергеев'),
    NULL,
    'запланирован',
    0,
    0
),
(
    (SELECT exhibit_id FROM Exhibits WHERE exhibit_name = 'Ваза Минг'),
    (SELECT person_id FROM People WHERE person_name = 'Сергей Сергеев'),
    NULL,
    'приостановлен',
    157000,
    0
),
(
    (SELECT exhibit_id FROM Exhibits WHERE exhibit_name = 'Ваза Минг'),
    (SELECT person_id FROM People WHERE person_name = 'Алексей Крутой'),
    NULL,
    'отменен',
    0,
    0
),
(
    (SELECT exhibit_id FROM Exhibits WHERE exhibit_name = 'Страшный суд'),
    NULL,
    (SELECT action_id FROM Actions WHERE action_type = 'аукцион' AND action_date='2022-08-05' AND action_address='Аукционный дом Sotheby, Лондон' 
    and exhibit_id = (SELECT exhibit_id FROM Exhibits WHERE exhibit_name = 'Страшный суд')),
    'завершен',
    30000,
    210453
);

-- 5

-- добавили новый музей
INSERT INTO Museums (museum_name, museum_city, museum_country) VALUES ('Государственный музей', 'Санкт-Петербург', 'Россия');

-- получили все музеи
SELECT * FROM Museums;

-- получили последний добавленный
SELECT museum_id, museum_name FROM Museums WHERE museum_name = 'Государственный музей';

-- поменяли название и город
UPDATE Museums SET museum_city = 'Москва' WHERE museum_name = 'Государственный музей';
UPDATE Museums SET museum_name = 'Музей современного искусства' WHERE museum_id = 7;

-- удалили музей
DELETE FROM Museums WHERE museum_name = 'Музей современного искусства';

-- получили все музеи
SELECT * FROM Museums;

-- добавили экспонат
INSERT INTO Exhibits (exhibit_type, exhibit_name, creator, creation_year, storage_city, museum_id, owner_id, exhibit_condition, exhibit_price)
VALUES ('Картина', 'Звездная ночь', 'Винсент Ван Гог', 1889, 'Амстердам',
(SELECT museum_id FROM Museums WHERE museum_name = 'Музей истории искусств'),
(SELECT person_id FROM PeopleXMuseum WHERE museum_id = (SELECT museum_id FROM Museums WHERE museum_name = 'Музей истории искусств') LIMIT 1), 
'не требует реставрации', 500000);

-- получили все экспонаты
SELECT * FROM Exhibits;

-- получили последний добавленный
SELECT * FROM Exhibits WHERE exhibit_name = 'Звездная ночь';

-- поменяли состояние и стоимость
UPDATE Exhibits SET exhibit_condition = 'требует реставрации', exhibit_price = 550000 WHERE exhibit_name = 'Звездная ночь' AND creator = 'Винсент Ван Гог';

-- удалили экспонат
DELETE FROM Exhibits WHERE exhibit_name = 'Звездная ночь' AND creator = 'Винсент Ван Гог';

-- получили все экспонаты
SELECT * FROM Exhibits;

-- 6

-- музеи в которых есть требующие рестоврации экспонаты, отсортированы по их количеству 
SELECT Museums.museum_name, Museums.museum_city, COUNT(Exhibits.exhibit_id) AS restoration_needed_count FROM Museums
LEFT JOIN Exhibits ON Museums.museum_id = Exhibits.museum_id
WHERE Exhibits.exhibit_condition = 'требует реставрации'
GROUP BY Museums.museum_id, Museums.museum_name, Museums.museum_city
HAVING COUNT(Exhibits.exhibit_id) > 0
ORDER BY restoration_needed_count DESC;

-- типы экспонатов, у которых средняя цена превышает 30,000
SELECT Exhibits.exhibit_type, ROUND(AVG(Exhibits.exhibit_price),2) AS average_price FROM Exhibits
GROUP BY Exhibits.exhibit_type
HAVING AVG(Exhibits.exhibit_price) > 30000;

-- список людей, отсортированный по общей стоимости экспонатов, которыми они владеют по убыванию
SELECT People.person_name, SUM(Exhibits.exhibit_price) AS total_exhibit_value FROM People
LEFT JOIN Exhibits ON People.person_id = Exhibits.owner_id
GROUP BY People.person_id, People.person_name
HAVING SUM(Exhibits.exhibit_price) IS NOT NULL
ORDER BY total_exhibit_value DESC;

-- картины в период 1500-2000, отсортированные по убыванию стоимости
SELECT exhibit_name AS painting_name, creation_year, exhibit_price FROM Exhibits
WHERE exhibit_type = 'Картина' AND CAST(creation_year AS INT) BETWEEN 1500 AND 2000
ORDER BY exhibit_price DESC;

-- рейтинг экспонатов по цене в рамках одного музея во всем музеям
SELECT museum.museum_name, exhibit.exhibit_name, exhibit.exhibit_price, RANK() OVER (PARTITION BY museum.museum_id ORDER BY exhibit.exhibit_price DESC) AS price_rank FROM People person
INNER JOIN Exhibits exhibit ON person.person_id = exhibit.owner_id
INNER JOIN Museums museum ON exhibit.museum_id = museum.museum_id
ORDER BY museum.museum_name, price_rank;

-- рейтинг владельцев экспонатов, основываясь на количестве экземпляров
SELECT person.person_name AS owner_name, COUNT(exhibit.exhibit_id) AS exhibit_count, ROW_NUMBER() OVER (ORDER BY COUNT(exhibit.exhibit_id) DESC) AS rating FROM People person
LEFT JOIN Exhibits exhibit ON person.person_id = exhibit.owner_id
GROUP BY person.person_name
HAVING COUNT(exhibit.exhibit_id) > 0
ORDER BY rating;

-- люди, которые владеют количеством экспонатов больше, чем другие в среднем (люди без экспонатов во владении не учитываются)
WITH ExhibitCounts AS ( SELECT person.person_name AS owner_name, COUNT(exhibit.exhibit_id) AS exhibit_count
FROM People person
    LEFT JOIN Exhibits exhibit ON person.person_id = exhibit.owner_id
    GROUP BY person.person_name
    HAVING COUNT(exhibit.exhibit_id) > 0
)
SELECT owner_name,exhibit_count
FROM ExhibitCounts
WHERE exhibit_count > (SELECT AVG(exhibit_count) FROM ExhibitCounts);

--7

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

--8

-- количество экспонатов, среднюю стоимость экспонатов, а также общее количество реставраций для каждого музея.
CREATE OR REPLACE VIEW views.MuseumExhibitStatistic AS
SELECT 
    m.museum_name,
    concat(m.museum_city, ', ' , m.museum_country) as museum_address,
    COUNT(e.exhibit_id) AS exhibit_count,
    ROUND(COALESCE(AVG(e.exhibit_price), 0),2) AS average_exhibit_price,
    COALESCE(COUNT(r.restoration_id), 0) AS restoration_count
FROM Museums as m
LEFT JOIN Exhibits as e ON m.museum_id = e.museum_id
LEFT JOIN Restorations as r ON e.exhibit_id = r.exhibit_id
GROUP BY m.museum_id, m.museum_name, museum_address;

select * from views.MuseumExhibitStatistic;

--Анализирует доходы от проданных экспонатов на завершённых аукционах, включая прибыль и имя продавца.
CREATE OR REPLACE VIEW views.ExhibitSalesRevenue AS
SELECT 
    e.exhibit_name,
    p.person_name AS seller_name,
    a.start_price,
    a.end_price,
    (a.end_price - a.start_price) AS profit
FROM Auctions as a
LEFT JOIN Exhibits as e ON a.exhibit_id = e.exhibit_id
LEFT JOIN People as p ON e.owner_id = p.person_id
WHERE a.auction_status = 'завершен' AND a.end_price IS NOT NULL;

select * from views.ExhibitSalesRevenue;

-- Представление ExhibitOwnershipHistory показывает историю владения экспонатами,
-- включая имя владельца, даты начала и окончания, объединяет данные из таблицы Ownership_History с последними данными о текущем владельце экспоната
CREATE OR REPLACE VIEW views.ExhibitOwnershipHistory AS
SELECT 
    e.exhibit_name,
    p.person_name AS owner_name,
    oh.start_date,
    oh.end_date
FROM Ownership_History AS oh
LEFT JOIN People AS p ON oh.owner_id = p.person_id
LEFT JOIN Exhibits AS e ON oh.exhibit_id = e.exhibit_id

UNION ALL

SELECT 
    e.exhibit_name,
    p.person_name AS owner_name,
    (SELECT MAX(oh.end_date) 
    FROM Ownership_History AS oh 
    WHERE oh.exhibit_id = e.exhibit_id) AS start_date,
    CURRENT_DATE AS end_date
FROM Exhibits AS e
INNER JOIN People AS p ON e.owner_id = p.person_id
WHERE NOT EXISTS (
    SELECT 1
    FROM Ownership_History AS oh
    WHERE oh.exhibit_id = e.exhibit_id
    AND oh.end_date >= CURRENT_DATE
);

select * from views.ExhibitOwnershipHistory;

--9

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

--10

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

