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

--Как зовут продавцов, которые в 1997 году оформили больше 30 заказов?
SELECT		LastName + ' ' + FirstName
FROM		Employees
WHERE		(
			SELECT		COUNT(OrderID)
			FROM		Orders
			WHERE		YEAR(OrderDate) = 1997
					AND EmployeeID = Employees.EmployeeID
			) > 30

--------------------------------------------------------------------------
--Сложные аспекты подзапросов
SELECT		LastName + ' ' + FirstName AS Name,
			(
			SELECT		COUNT(*)
			FROM		Orders
			WHERE		EmployeeID = Employees.EmployeeID
			) AS Total
FROM		Employees
WHERE		(
			SELECT		COUNT(*)
			FROM		Orders
			WHERE		EmployeeID = Employees.EmployeeID
			) > 100
--Если нам нужно убрать дубликаты кода, то можно решенную задачу предатавить в запросе в виде таблицы FROM (Главное чтобы все колонки были наименованы), и можно обращаться к наименованным столбцам, а не дублировать код при вставке в WHERE
SELECT *
FROM	(
		SELECT		LastName + ' ' + FirstName AS Name,
					(
					SELECT		COUNT(*)
					FROM		Orders
					WHERE		EmployeeID = Employees.EmployeeID
					) AS Total
		FROM		Employees
		) AS MyTable
WHERE	Total > 100

-- Сколько штук товаров продано в каждую страну?
SELECT		ShipCountry,
			(
			SELECT		SUM(Quantity)
			FROM		[Order Details]
			WHERE		OrderID = Orders.OrderID
			)
FROM		Orders
--Вот мы решили задачу, но у нас теперь таблица заказов и есть дубликаты стран, т.к. изначально таблицы стран нет
--Оборачиваем решенную задачу во внешний запрос и поместим нашу задачу в поле FROM
--После чего можем использовать group by
SELECT		ShipCountry, SUM(SubTotal)
FROM		(
			SELECT		ShipCountry,
						(
						SELECT		SUM(Quantity)
						FROM		[Order Details]
						WHERE		OrderID = Orders.OrderID
						) AS SubTotal
			FROM		Orders
			) AS MyOrders
GROUP BY	ShipCountry

--Протягивание данных черех несколько не смежных таблиц
--Сколько денег потратил каждый покупатель
--Список чего я хочу получить? :Покупателя, иду в таблицу покупателей
SELECT		ContactName,
			(
			SELECT		SUM(UnitPrice * Quantity * (1 - Discount))
			FROM		[Order Details]
			WHERE		OrderID IN	(--Список заказов одного покупателя
									SELECT		OrderID
									FROM		Orders
									WHERE		CustomerID = Customers.CustomerID
									)
			) AS Spend
FROM		Customers

--Сколько штук мы продали в каждой категории? :Нужен список категорий

SELECT		CategoryName, --Теперь нужно посчитать количество штук
			(
			SELECT		SUM(Quantity)
			FROM		[Order Details]
			WHERE		ProductID IN	(--Список товаров из одной категории
										SELECT		ProductID
										FROM		Products
										WHERE		CategoryID = Categories.CategoryID
										)
			) AS Quantity
FROM		Categories

--Сколько штук купил каждый покупатель (ФИО) в 1997 году?
SELECT		ContactName,
			(--Беру сумму количества из детализации заказов где ID заказа находится в диапазоне
			SELECT		SUM(Quantity)
			FROM		[Order Details]
			WHERE		OrderID IN	(--Беру все ID заказов из таблицы заказов, где ID покупателя совпадает с ID из внешнего Select
									SELECT		OrderID
									FROM		Orders
									WHERE		CustomerID = Customers.CustomerID
											AND YEAR(OrderDate) = 1997
									)
			) AS Quantity
FROM		Customers