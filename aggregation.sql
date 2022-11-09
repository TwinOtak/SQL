SELECT	Avg(Price), Min(Price), Max(Price), Sum(Price)
FROM	titles

SELECT	Avg(Price), Avg(Price * (1 + 0.18)) --Можно передавать производные значения
FROM	titles

SELECT	Count(*), Count(Price) --1. Считает строки с Null; 2. Считает строки со значениями в выбранном столбце
FROM	titles


SELECT	Avg(Price)	--Сначала срабатывает WHERE
FROM	titles
WHERE	type = 'business'

----------------------------------------------------------------------
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