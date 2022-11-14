SELECT		EnglishMonthName,
			EnglishOccupation,
			SUM(SalesAmount)
FROM		FactInternetSales AS I	--Берем таблицу фактов
			INNER JOIN DimCustomer AS C	--Джоиним к ней таблицу размерностей
			ON	I.CustomerKey = C.CustomerKey
			INNER JOIN DimDate as D -- и еще джоиним к ней таблицу размерностей
			ON I.OrderDateKey = D.DateKey
WHERE		D.CalendarYear = 2011
		AND	C.Gender = 'F'
GROUP BY	EnglishMonthName,
			EnglishOccupation
ORDER BY	SUM(SalesAmount) DESC