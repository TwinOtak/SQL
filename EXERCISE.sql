-- В какую страну был оформлен последний заказ осенью 1997 года?
SELECT	TOP(1) WITH TIES ShipCountry
FROM	Orders
WHERE	YEAR(OrderDate) = 1997
	AND	MONTH(OrderDate) BETWEEN 9 AND 11
ORDER BY OrderDate DESC

--В какие города оформлял заказы продавец №1 в 1996 году?
SELECT	DISTINCT ShipCity
FROM	Orders
WHERE	EmployeeID = 1
	AND	YEAR(OrderDate) = 1996

--Сколько клиентов проживает в Лондоне?
SELECT	Count(*)
FROM	Customers
WHERE	City = 'London'

--Каких клиентов больше: с факсом или без факса?
SELECT	COUNT(*)
FROM	Customers
WHERE	Fax IS NOT NULL

SELECT	COUNT(*)
FROM	Customers
WHERE	Fax IS NULL
--В данном решении количество находится в разных запросах, нам нужно поместить их в один следующим образом
SELECT	COUNT(Fax), COUNT(*) - COUNT(Fax)
FROM	Customers
--Нужно стараться загонять значнеия в одну строку для дальнейших операций

--Сколько клиентов обслужил продавец №1 в 1997 году?
SELECT	COUNT(*), COUNT(DISTINCT CustomerID) --Нужно брать уникальные значения, т.к. я работаю с таблицей заказов, а мне нужно получить количество обслуженных ПОКУПАТЕЛЕЙ, А НЕ ЗАКАЗОВ
FROM	Orders
WHERE	EmployeeID = 1
	AND	YEAR(OrderDate) = 1997

----------------------------------------------------------------------

SELECT	TOP(100) *
FROM	[Order Details]

SELECT	TOP(100) *
FROM	Orders

--Посчитать выручку с товара №1
SELECT	ROUND(SUM(UnitPrice * Quantity * (1 - Discount)), 6)
FROM	[Order Details]
WHERE	ProductID = 1

--Сколько немецких городов обсужили летом 1997 года?
SELECT	COUNT(DISTINCT ShipCity)
FROM	Orders
WHERE	ShipCountry = 'Switzerland'
	AND	YEAR(OrderDate) = 1997
	AND	MONTH(OrderDate) BETWEEN 6 AND 8

----------------------------------------------------------------------

--Какой продавец оформил самый последний заказ в Париж?
SELECT	TOP(1) WITH TIES EmployeeID
FROM	Orders
WHERE	ShipCity = 'Paris'
ORDER BY	OrderDate DESC

--В какой категории(талице) больше всего товаров?
SELECT		TOP(1) WITH TIES CategoryID--, Count(*)
FROM		Products
GROUP BY	CategoryID
ORDER BY	Count(*) DESC

--Сколько заказов оформлено в каждый город?
SELECT		ShipCity, COUNT(*)
FROM		Orders
GROUP BY	ShipCity

--Какой продавец поставил рекорд:
--Обслужил больше всего клиентов из одной страны в течение месяца?
SELECT		TOP(1) WITH TIES EmployeeID--, COUNT(DISTINCT CustomerID)
FROM		Orders
GROUP BY	YEAR(OrderDate), MONTH(OrderDate), EmployeeID, ShipCountry
ORDER BY	COUNT(DISTINCT CustomerID) DESC

----------------------------------------------------------------------

--Какие товары принесли выручку больше 10.000?
SELECT		DISTINCT ProductID--, SUM(UnitPrice*Quantity*(1-Discount)) AS Total
FROM		[Order Details]
GROUP BY	ProductID
HAVING		SUM(UnitPrice*Quantity*(1-Discount)) > 10000

--Какаие продавцы в 1997 году сумели обслужить больше пяти городов в одной стране?
SELECT		DISTINCT EmployeeID--, ShipCountry, COUNT(DISTINCT ShipCity)
FROM		Orders
WHERE		YEAR(OrderDate) = 1997
GROUP BY	EmployeeID, ShipCountry
HAVING		COUNT(DISTINCT ShipCity) > 5

--1. Сначала придумать, потом решить
--2. Осмысленная задача
--3. Не решается без HAVING'а
--Какиие доставщики доставили более 3 миллионов заказов?
SELECT		ShipVia, SUM(OrderID)
FROM		Orders
GROUP BY	ShipVia
HAVING		SUM(OrderID) > 3000000

---------------------------------------------------------------

SELECT		City
FROM		Employees

SELECT		City
FROM		Customers
---------------------
SELECT		City
FROM		Employees
	UNION		--DISTINCT объединение
SELECT		City
FROM		Customers
---------------------
SELECT		City
FROM		Employees
	UNION ALL	--Объединение всего, но в данном случае будут повторения
SELECT		City
FROM		Customers
---------------------
--Нашли отток клиентов
SELECT		CustomerID
FROM		Orders
WHERE		YEAR(OrderDate) = 1997
	EXCEPT
SELECT		CustomerID
FROM		Orders
WHERE		YEAR(OrderDate) = 1998

--Нашли новых клиентов
SELECT		CustomerID
FROM		Orders
WHERE		YEAR(OrderDate) = 1998
	EXCEPT
SELECT		CustomerID
FROM		Orders
WHERE		YEAR(OrderDate) = 1997

--Постоянные клиенты, которые покупали на протяжении 3 лет
SELECT		CustomerID
FROM		Orders
WHERE		YEAR(OrderDate) = 1998
	INTERSECT
SELECT		CustomerID
FROM		Orders
WHERE		YEAR(OrderDate) = 1997
	INTERSECT
SELECT		CustomerID
FROM		Orders
WHERE		YEAR(OrderDate) = 1996

------------------------------------------------------------------------------------

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