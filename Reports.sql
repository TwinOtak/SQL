--Pivot, Unpivot, Сводные тыблицы----------------------------------------------

SELECT		ShipCountry, YEAR(OrderDate), COUNT(*)
FROM		Orders
GROUP BY	ShipCountry, YEAR(OrderDate)

SELECT		ShipCountry, [1996], [1997], [1998], [1996] + [1997] + [1998] --То что будет по горизонтали мы должны знать заранее и ручками вписать
FROM		(
			SELECT		ShipCountry, YEAR(OrderDate) AS MyYear, OrderID
			FROM		Orders
			) AS MyOrders
PIVOT		(
			COUNT(OrderID) FOR MyYear IN ([1996], [1997], [1998])
			) MyReport
WHERE		[1998] > [1997]
		AND	[1997] > [1996]


--WITH ROLLUP, Подытоги (Subtotals)----------------------------------------------

SELECT		ShipCountry, YEAR(OrderDate), COUNT(*)
FROM		Orders
GROUP BY	ShipCountry, YEAR(OrderDate) WITH ROLLUP

SELECT		ShipCountry, YEAR(OrderDate), COUNT(*)
FROM		Orders
GROUP BY	YEAR(OrderDate), ShipCountry WITH ROLLUP --Поменяли столбцы для группировки
--Было по странам, каждый год роллапился (собирался) по стране
--Стало что каждая страна роллапится (собирается) по году

--Если добавлять в группировку столбцы, то строк будет становиться больше и будет строиться "лесенка" от последнего столбца в Group by к первому
SELECT		ShipCountry, YEAR(OrderDate), EmployeeID,  COUNT(*)
FROM		Orders
GROUP BY	ShipCountry, YEAR(OrderDate), EmployeeID WITH ROLLUP --Добавили ID работника
