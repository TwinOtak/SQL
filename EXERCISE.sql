-- В какую страну был оформлен последний заказ осенью 1997 года?
SELECT	TOP(1) WITH TIES ShipCountry
FROM	Orders
WHERE	YEAR(OrderDate) = 1997
	AND	MONTH(OrderDate) BETWEEN 9 AND 11
ORDER BY OrderDate DESC
