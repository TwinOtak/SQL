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
