SELECT		type	--Тут новая таблица со свойствами type'ов
FROM		titles	--Таблица №1 (Список книг)
GROUP BY	type	--Таблица №2 (Список типов книг)

SELECT		DISTINCT type, price	--Тут старая таблица и новые ячейки, это будут свойства книг
FROM		titles

SELECT		Country		--Остальные колонки "не выживают", но можно обогощать новыми колонками
FROM		Customers
GROUP BY	Country

SELECT		type, Count(*) AS 'Count', Avg(Price) AS 'Average', MAX(Price) AS 'Maximum', Min(price) AS 'Minimum'
FROM		titles	
GROUP BY	type
ORDER BY	Avg(price) DESC

SELECT		Country, Count(*)
FROM		Customers
GROUP BY	Country
ORDER BY	Count(*) DESC

--В какой категории(талице) больше всего товаров?
SELECT		TOP(1) WITH TIES CategoryID--, Count(*)
FROM		Products
GROUP BY	CategoryID
ORDER BY	Count(*) DESC

--Сколько заказов оформлено в каждый город?
SELECT		ShipCity, COUNT(*)
FROM		Orders
GROUP BY	ShipCity

SELECT		YEAR(BirthDate), COUNT(*)
FROM		Employees
GROUP BY	YEAR(BirthDate)

--Уникальные кортежи по стране и году для которых можно посчитать количество заказов
--Сколько заказов было по странам и по годам
SELECT		ShipCountry, YEAR(OrderDate), COUNT(*)
FROM		Orders
GROUP BY	ShipCountry, YEAR(OrderDate)

--Какой продавец поставил рекорд:
--Обслужил больше всего клиентов из одной страны в течение месяца?
SELECT		TOP(1) EmployeeID--, COUNT(DISTINCT CustomerID)
FROM		Orders
GROUP BY	YEAR(OrderDate), MONTH(OrderDate), EmployeeID, ShipCountry
ORDER BY	COUNT(DISTINCT CustomerID) DESC

------------------------------------------------
SELECT		COUNT(*)
FROM		Orders

SELECT		COUNT(*)
FROM		Orders
GROUP BY	YEAR(OrderDate)

SELECT		COUNT(*)
FROM		Orders
GROUP BY	YEAR(OrderDate), ShipCountry
------------------------------------------------
