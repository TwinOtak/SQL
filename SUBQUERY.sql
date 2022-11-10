--SUBQUERY
--Сколько заказов оформил каждый продавец (ФИО)?
--Каждая строка в ответе, это продавец
--Если я хочу получить список продавцов, то к нему и пишу select
--Как только сталкиваюсь с нехваткой данных, ставлю () и внутри пишу подзапрос
SELECT		EmployeeID, FirstName, LastName,
			(
			SELECT		COUNT(*)
			FROM		Orders
			WHERE		EmployeeID = Employees.EmployeeID
			)
FROM		Employees

--Посчитать среднюю цену товара для каждой категории
SELECT		CategoryName,
			(
			SELECT		AVG(UnitPrice)	--Нужно чтобфы возвращал только 1 значение
			FROM		Products
			WHERE		CategoryID = Categories.CategoryID
			) AS AveragePrice
FROM		Categories