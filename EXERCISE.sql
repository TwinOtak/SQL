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
SELECT		TOP(1) EmployeeID--, COUNT(DISTINCT CustomerID)
FROM		Orders
GROUP BY	YEAR(OrderDate), MONTH(OrderDate), EmployeeID
ORDER BY	COUNT(DISTINCT CustomerID) DESC
