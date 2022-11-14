--Как зовут продавцов, которые оформили заказов в Берлин больше, чем в Париж?
--1 --Подзапрос
SELECT		FirstName + ' ' + LastName as Name
FROM		Employees
WHERE		(
			SELECT		COUNT(*)
			FROM		Orders
			WHERE		EmployeeID = Employees.EmployeeID
					AND	ShipCity = 'Berlin'
			)
			>
			(
			SELECT		COUNT(*)
			FROM		Orders
			WHERE		EmployeeID = Employees.EmployeeID
					AND	ShipCity = 'Paris'
			)

--2	-Pivot
--WHERE		ShipCity IN ('Berlin', 'Paris')
--GROUP BY	FirstName + ' ' + LastName, ShipCity
SELECT		Name--, [Berlin], [Paris]
FROM		(
			SELECT		FirstName + ' ' + LastName AS Name, ShipCity, OrderID
			FROM		Employees AS E lEFT JOIN Orders AS O
						ON E.EmployeeID = O. EmployeeID
			) MyOrders
Pivot		(
			COUNT(OrderID) FOR ShipCity IN ([Berlin], [Paris])
			) MyReport
WHERE		[Berlin]>[Paris]

--3 -JOIN (Только Джоинами)
SELECT		FirstName + ' ' + LastName
FROM		Employees E LEFT JOIN Orders AS BO
		ON	E.EmployeeID = BO.EmployeeID
		AND	BO.ShipCity = 'Berlin'
			LEFT JOIN Orders AS PO
		ON	E.EmployeeID = PO.EmployeeID
		AND	PO.ShipCity = 'Paris'
GROUP BY	FirstName + ' ' + LastName
HAVING		COUNT(DISTINCT BO.OrderID) > COUNT(DISTINCT PO.OrderID) 
--Дистинкт тут потому что на 3 шаге получил таблицу заказов в квадрате
--Потому что джоинил заказы к заказам
--Если без дистинкта, то в городах, куда было огромное количество заказов начнутся аномалии данных