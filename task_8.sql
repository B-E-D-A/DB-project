
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
