SELECT	*
FROM	orders
WHERE	Year(OrderDate) = 1997
	AND	Month(OrderDate) IN (3,4,5)
-------------------------------------
SELECT	*
FROM	orders
WHERE	Year(OrderDate) = 1997
	AND	Month(OrderDate) BETWEEN 3 AND 5
-------------------------------------
SELECT	*
FROM	Orders
WHERE	OrderDate >= '19970301'
	AND	OrderDate < '19971201'
