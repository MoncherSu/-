--Общее описание объектов с информацией о типе, статусе, продавце

CREATE VIEW View_Object_Details AS
SELECT o.Object_ID, o.Object_Desc, ot.Type_name, os.Object_Stat, a.Last_Name AS Seller_LastName, a.First_Name AS Seller_FirstName
FROM Object o
JOIN Object_Type ot ON o.Object_Type = ot.Type_Id
JOIN Object_Status os ON o.Status = os.Object_Status_ID
JOIN Klient a ON o.Seller_Id = a.Klient_Id;

--Информация о сделках с данными по объектам и клиентам

CREATE VIEW View_Deal_Info AS
SELECT d.Deal_ID, d.Deal_Date, dt.Deal_Spec,o.Object_Desc,k.First_Name AS Buyer_FirstName, k.Last_Name AS Buyer_LastName, d.Value
FROM Deal d
JOIN Deal_Type dt ON d.Deal_Type = dt.Deal_Type
JOIN Object o ON d.Object = o.Object_ID
JOIN Klient k ON d.Klient_Buyer = k.Klient_Id;