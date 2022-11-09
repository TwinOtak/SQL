SELECT	TOP(100) *
FROM	Products
ORDER BY	UnitPrice ASC,	--по возрастанию (По умолчанию, можно не писать)
			ProductName		--Вторичный уровень сортировки

SELECT	TOP(100) *
FROM	Products
ORDER BY	UnitPrice DESC	--по убыванию

SELECT	Title, Price
FROM	Titles
ORDER BY	IsNull (Price, 0) DESC --Если значение Null, ставим вместо него 0 чтобы отсортировать

SELECT	Top (1) WITH TIES ShipCountry
FROM	Orders
WHERE	Year(OrderDate) = 1997
	AND Month(OrderDate) IN (9, 10, 11)
ORDER BY	OrderDate DESC
