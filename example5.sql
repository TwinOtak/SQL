SELECT	Top (1) WITH TIES ShipCountry
FROM	Orders
WHERE	Year(OrderDate) = 1997
	AND Month(OrderDate) IN (9, 10, 11)
ORDER BY	OrderDate DESC
