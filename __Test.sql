SELECT	*
FROM	Employees

SELECT	*
FROM	Orders

SELECT	*
FROM	[Order Details]

SELECT	*
FROM	Products

SELECT	*
FROM	Categories

--Какие продавцы
SELECT	E.EmployeeID, FirstName + ' ' + LastName AS flName, P.CategoryID, CategoryName
FROM	Employees AS E LEFT JOIN 
		(ORDERS AS O INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
		INNER JOIN Products AS P ON OD.ProductID = P.ProductID
		INNER JOIN Categories AS C ON P.CategoryID = C.CategoryID
		) ON E.EmployeeID = O.EmployeeID
ORDER BY FirstName + ' ' + LastName

SELECT	FirstName + ' ' + LastName as 'Name', c.CategoryName AS 'CountCategory'
FROM	Employees AS E LEFT JOIN 
		(ORDERS AS O INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
		INNER JOIN Products AS P ON OD.ProductID = P.ProductID
		INNER JOIN Categories AS C ON P.CategoryID = C.CategoryID
		) ON E.EmployeeID = O.EmployeeID
GROUP BY FirstName + ' ' + LastName
HAVING COUNT(c.CategoryName) > 300
ORDER BY Name

SELECT	*
FROM	ORDERS AS O INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
-----
SELECT CategoryName, [Davolio Nancy],[Fuller Andrew],[Leverling Janet],[Peacock Margaret],[Buchanan Steven],[Suyama Michael],[King Robert],[Callahan Laura],[Dodsworth Anne]
FROM	(
		SELECT	CategoryName, LastName + ' ' + FirstName AS flName, P.CategoryID
		FROM	Employees AS E LEFT JOIN 
				(ORDERS AS O INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
				INNER JOIN Products AS P ON OD.ProductID = P.ProductID
				INNER JOIN Categories AS C ON P.CategoryID = C.CategoryID
				) ON E.EmployeeID = O.EmployeeID
		) as Test
PIVOT	(
		COUNT(CategoryID) FOR flName IN ([Davolio Nancy],[Fuller Andrew],[Leverling Janet],[Peacock Margaret],[Buchanan Steven],[Suyama Michael],[King Robert],[Callahan Laura],[Dodsworth Anne])
		) 
		AS MyReport
-----

SELECT	flName, [Beverages],[Condiments],[Confections],[Dairy Products],[Grains/Cereals],[Meat/Poultry],[Produce],[Seafood]
FROM	(
		SELECT	LastName + ' ' + FirstName AS flName, CategoryName, P.CategoryID
		FROM	Employees AS E LEFT JOIN 
				(ORDERS AS O INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
				INNER JOIN Products AS P ON OD.ProductID = P.ProductID
				INNER JOIN Categories AS C ON P.CategoryID = C.CategoryID
				) ON E.EmployeeID = O.EmployeeID
		) as TestQ
PIVOT	(
		COUNT(CategoryID) FOR CategoryName IN ([Beverages],[Condiments],[Confections],[Dairy Products],[Grains/Cereals],[Meat/Poultry],[Produce],[Seafood])
		) 
		AS MyReport
-----

SELECT	LastName + ' ' + FirstName AS flName, CategoryName, COUNT(*)
FROM	Employees AS E LEFT JOIN 
		(ORDERS AS O INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
		INNER JOIN Products AS P ON OD.ProductID = P.ProductID
		INNER JOIN Categories AS C ON P.CategoryID = C.CategoryID
		) ON E.EmployeeID = O.EmployeeID
GROUP BY LastName + ' ' + FirstName, CategoryName WITH ROLLUP
-----

--Придумал сам (Записать больше всего)
--Найти продавца, который продавал больше всех (в среднем) по категориям (Тут куча лишних расчетов)
--Можно  просто посчитать по CategoryID
SELECT	LastName + ' ' + FirstName AS flName, CategoryName, COUNT(*) AS CountCategoryName, GROUPING(CategoryName) AS Gr, (COUNT(*) / COUNT(DISTINCT C.CategoryID)) AS Itog
FROM	Employees AS E LEFT JOIN 
		(ORDERS AS O INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
		INNER JOIN Products AS P ON OD.ProductID = P.ProductID
		INNER JOIN Categories AS C ON P.CategoryID = C.CategoryID
		) ON E.EmployeeID = O.EmployeeID
--WHERE
GROUP BY LastName + ' ' + FirstName, CategoryName WITH ROLLUP
HAVING	GROUPING(CategoryName) = 1
	AND	GROUPING(LastName + ' ' + FirstName) != 1
	--AND	COUNT(*) / COUNT(DISTINCT C.CategoryID) > 50
ORDER BY COUNT(*) / COUNT(DISTINCT C.CategoryID) DESC
--LIMIT

--Какой продавец продал больше всего и в какой категории?
SELECT	TOP(1) LastName + FirstName, CategoryName--, COUNT(CategoryName) AS CountCategoryName
FROM	Employees AS E LEFT JOIN 
		(ORDERS AS O INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
		INNER JOIN Products AS P ON OD.ProductID = P.ProductID
		INNER JOIN Categories AS C ON P.CategoryID = C.CategoryID
		) ON E.EmployeeID = O.EmployeeID
GROUP BY LastName + FirstName, CategoryName
ORDER BY COUNT(CategoryName) DESC