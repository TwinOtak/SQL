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

--Subtotals, Подытоги----------------------------------------------