SELECT		FirstName + '' + LastName AS Name
FROM		Employees
	UNION
SELECT		ContactName
FROM		Customers

----------------------------------------------

SELECT		ProductName, UnitPrice, 'Еда'
FROM		Products
	UNION
SELECT		title, price, 'Книга'
FROM		pubs..titles

----------------------------------------------

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

----------------------------------------------

SELECT		City
FROM		Employees
	INTERSECT	
SELECT		City
FROM		Customers

----------------------------------------------

SELECT		City
FROM		Employees
	EXCEPT
SELECT		City
FROM		Customers
	UNION		--Объединяю две таблички
SELECT		City
FROM		Customers
	EXCEPT
SELECT		City
FROM		Employees
ORDER BY City DESC

----------------------------------------------
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