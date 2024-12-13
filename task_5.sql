
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
