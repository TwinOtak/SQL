﻿SELECT	DISTINCT Country, City
FROM	Customers


--В какие города оформлял заказы продавец №1 в 1996 году?
SELECT	DISTINCT ShipCity
FROM	Orders
WHERE	EmployeeID = 1
	AND	YEAR(OrderDate) = 1996