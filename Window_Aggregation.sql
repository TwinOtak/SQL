SELECT		OrderID, Freight, 
			SUM(Freight) OVER	(
								ORDER BY OrderID ASC
								ROWS BETWEEN	--Задаем границы окна
									UNBOUNDED PRECEDING	--Верхняя граница не двигается (Тут зафиксирована)
									AND
									CURRENT ROW			--Нижняя граница (Скользит с текущей строкой)
								)
FROM		Orders
ORDER BY	OrderID