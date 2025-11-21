		--Агрегатные функции

--Общая сумма стоимости всех сделок и средняя цена за сделку
SELECT SUM(d.Value) AS 'Сумма стоимости всех сделок', AVG(d.Value) AS 'Средняя цена за сделку'
FROM Deal d;

 --Максимальная и минимальная площадь объектов, а также их количество
 SELECT MAX(o.Square) AS 'Максимальная площадь', MIN(o.Square) AS 'Минимальная площадь', COUNT(*) AS 'Количество объектов недвижимости'
FROM Object o;

		--Внутренние и внешние соединения

--Получить список сделок с информацией о объекте и клиенте покупателе
SELECT d.Deal_ID 'Id сделки', d.Deal_Date 'Дата сделки', o.Object_Desc 'Объект недвижимости', 
k.First_Name AS 'Имя покупателя', k.Last_Name AS 'Фамилия покупателя'
FROM Deal d
JOIN Object o ON d.Object = o.Object_ID
JOIN Klient k ON d.Klient_Buyer = k.Klient_Id;

--Получить всех сделок и информацию о продавце
SELECT d.Deal_ID 'Id сделки', d.Deal_Date'Дата заключения сделки', o.Object_Desc'Объект недвижимости', 
a.Last_Name 'Фамилия продавца'
FROM Deal d
LEFT JOIN Object o ON d.Object = o.Object_ID
LEFT JOIN Klient a ON o.Seller_Id = a.Klient_Id;

--Получить информацию о всех объектах и связанные с ними сделками 
SELECT o.Object_Desc 'Объект недвижимости', d.Deal_ID 'Id сделки', d.Deal_Date 'Дата заключения сделки'
FROM Object o
RIGHT JOIN Deal d ON o.Object_ID = d.Object
WHERE d.Deal_ID IS NOT NULL;

--все сделки и объекты, даже если они не связаны
SELECT o.Object_Desc 'Объект недвижимости', d.Deal_ID 'Id сделки', d.Deal_Date 'Дата заключения сделки'
FROM Object o
FULL OUTER JOIN Deal d ON o.Object_ID = d.Object
WHERE o.Object_ID IS NOT NULL OR d.Deal_ID IS NOT NULL;

		--Запросы с наборами данных

--Клиенты, не являющиеся продавцами

SELECT First_Name, Last_Name from Klient Except
SELECT First_Name, Last_Name from Klient k
join Klient_Seller KS ON k.Klient_Id = KS.Klient_Id 

--Клиенты - покупатели имеющие сделки

SELECT First_Name, Last_Name FROM Klient
INTERSECT
SELECT First_Name, Last_Name FROM  Klient k
join Klient_Buyer KB on k.Klient_Id = KB.Klient_Id
WHERE Klient_Buyer_ID IN (SELECT Klient_Buyer FROM Deal);

		--Итоговые запросы

--Общая сумма сделок по агентам и статусам с группировкой по ROLLUP

SELECT ISNULL(a.Last_Name, N'Всего') AS 'Фамилия агента',
ISNULL(ds.Status_Sp, N'Всего') 'Статус сделок', SUM(d.Value) 'Сумма'
FROM Deal d
Join Klient_Buyer KB on d.Klient_Buyer = KB.Klient_Buyer_ID
join Klient k on KB.Klient_Id = k.Klient_Id
JOIN Agents a ON k.Agent = a.Agent_Id
JOIN Deal_Status ds ON d.Deal_Status = ds.Status_Id
GROUP BY ROLLUP (a.Last_Name, ds.Status_Sp);

--Суммы по типам объектов и статусам

SELECT ISNULL(ot.Type_name, N'Всего') 'Тип объекта недвижимости',
ISNULL(os.Object_Stat, N'Всего') 'Статус объекта', COUNT(*) 'Количество'
FROM Object o
JOIN Object_Type ot ON o.Object_Type = ot.Type_Id
JOIN Object_Status os ON o.Status = os.Object_Status_ID
GROUP BY GROUPING SETS (
    (ot.Type_name, os.Object_Stat),
    (ot.Type_name),
    (os.Object_Stat)
);

