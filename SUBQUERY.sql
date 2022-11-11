﻿--SUBQUERY
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
			SELECT		AVG(UnitPrice)	--Нужно чтобы возвращал только 1 значение
			FROM		Products
			WHERE		CategoryID = Categories.CategoryID
			) AS AveragePrice
FROM		Categories

--Посчитать выручку с каждого товара (Название)
SELECT		ProductName,
			(
			SELECT		SUM(UnitPrice*Quantity*(1-Discount))
			FROM		[Order Details]
			WHERE		ProductID = Products.ProductID
			)  AS INCOME
FROM		Products
-----

--Если мы хотим искать по вложенному селекту или сортировать по нему же
--то в where и order by нужно переносить весь вложенный селект целиком
WHERE		(
			SELECT		SUM(UnitPrice*Quantity*(1-Discount))
			FROM		[Order Details]
			WHERE		ProductID = Products.ProductID
			) > 10000
ORDER BY	(
			SELECT		SUM(UnitPrice*Quantity*(1-Discount))
			FROM		[Order Details]
			WHERE		ProductID = Products.ProductID
			)

--Как зовут покупателей, обслуживавшихся у разных продавцов?
SELECT		ContactName, CompanyName			
FROM		Customers
WHERE		(
			SELECT		COUNT(DISTINCT EmployeeID)
			FROM		ORDERS
			WHERE		CustomerID = Customers.CustomerID
			) > 1

-- Как называется товар, которого мы продали больше всего (штук)?
SELECT		TOP(1) WITH TIES  ProductName--,ProductID,
--			(
--			SELECT		SUM(Quantity)
--			FROM		[Order Details]
--			WHERE		ProductID = Products.ProductID
--			) AS Quantity
FROM		Products
ORDER BY	(
			SELECT		SUM(Quantity)
			FROM		[Order Details]
			WHERE		ProductID = Products.ProductID
			) DESC