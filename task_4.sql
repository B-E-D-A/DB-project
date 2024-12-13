
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
