
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