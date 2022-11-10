SELECT		type, COUNT(*)
FROM		titles
--WHERE		COUNT(*) > 3 Не будет работать, выдаст ошибку, тк group by и нужен having
--WHERE		TYPE = 'business' вот так можно
GROUP BY	type
HAVING		COUNT(*) > 3
	AND		TYPE = 'business'

--Какие товары принесли выручку больше 10.000?
SELECT		DISTINCT ProductID--, SUM(UnitPrice*Quantity*(1-Discount)) AS Total
FROM		[Order Details]
GROUP BY	ProductID
HAVING		SUM(UnitPrice*Quantity*(1-Discount)) > 10000

--Какаие продавцы в 1997 году сумели обслужить больше пяти городов в одной стране?
SELECT		DISTINCT EmployeeID--, ShipCountry, COUNT(DISTINCT ShipCity)
FROM		Orders
WHERE		YEAR(OrderDate) = 1997
GROUP BY	EmployeeID, ShipCountry
HAVING		COUNT(DISTINCT ShipCity) > 5
