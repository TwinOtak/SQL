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


--WITH ROLLUP, WITH CUBE, Подытоги (Subtotals)----------------------------------------------

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

--WITH CUBE--Появляется много пустых строк, каке-то подытоги, а какие-то могут быть реально пустыми
SELECT		ShipCountry, YEAR(OrderDate), COUNT(*),
			Grouping(ShipCountry),
			Grouping(YEAR(OrderDate))
FROM		Orders
GROUP BY	ShipCountry, YEAR(OrderDate) WITH CUBE

--Иммитация подытога с помощью UNION--
SELECT		ShipCountry, YEAR(OrderDate), EmployeeID, COUNT(*)
FROM		Orders
GROUP BY	ShipCountry, YEAR(OrderDate),EmployeeID

	UNION ALL

SELECT		ShipCountry, YEAR(OrderDate), NULL, COUNT(*)
FROM		Orders
GROUP BY	ShipCountry, YEAR(OrderDate)	--По стране и году, без участия продавца

	UNION ALL

SELECT		NULL, YEAR(OrderDate), EmployeeID, COUNT(*)
FROM		Orders
GROUP BY	YEAR(OrderDate), EmployeeID	--По году и продавцу

	UNION ALL

SELECT		NULL, NULL, NULL, COUNT(*)
FROM		Orders

--GROUPING SETS, Более современная функция для подытогов--
SELECT		ShipCountry, YEAR(OrderDate), EmployeeID, COUNT(*)
FROM		Orders
GROUP BY	GROUPING SETS	(
							(ShipCountry, YEAR(OrderDate), EmployeeID),
							(ShipCountry, YEAR(OrderDate)),
							(YEAR(OrderDate), EmployeeID),
							()--Общий итог
							)
