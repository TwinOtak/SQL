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

--Как зовут продавцов, которые в 1997 году оформили больше 30 заказов?
SELECT		LastName + ' ' + FirstName
FROM		Employees
WHERE		(
			SELECT		COUNT(OrderID)
			FROM		Orders
			WHERE		YEAR(OrderDate) = 1997
					AND EmployeeID = Employees.EmployeeID
			) > 30

---------------------------------------------------------------------------------------------

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

------JOIN-----------------------------------------------------------------------
--CROSS JOIN
--Сколько товаров в каждой категории?
--1 шаг. Переджоинить все, что упомянуто в условии задачи
SELECT		CategoryName, COUNT(*) AS Quantity
FROM		Categories CROSS JOIN Products
--2 шаг. Нужно оставить только те комбинации, которые в реальности действительно связаны
WHERE		Categories.CategoryID = Products.CategoryID
--3 шаг. (Самый сложный) Ответить себе "Список чего я сейчас получил?"
--Мы получили список товаров (Продуктов).
--Логика рассуждения.
--Мы спрашиваем себя "В одной категории может быть несколько товаров?" :Да
--Если категории могут повторяться, то это не список категорий
--НО в этой базе данных ОДИН товар всегда в ОДНОЙ категории. Поэтому товары повторяться не могут!!!
--Следовательно мы получили список товаров, который дополнительно обогащен своей категорией (Названием, а не ID)
--4 шаг. Ответить себе "Что я хочу получить?" (Группировка)
Group by	Categories.CategoryID, CategoryName

--Сколько заказов оформил каждый продавец?
SELECT		FirstName + ' ' + LastName AS Name, COUNT(*) AS Quantity, COUNT(DISTINCT CustomerID) AS Q_Customers	--В подзапросах пришлось бы ветку писать
--5.Считаем количество заказов
FROM		Employees AS E CROSS JOIN Orders AS O
--1.Перемножаем все, что в условии
WHERE		E.EmployeeID = O.EmployeeID
--2.Отбираем действительные комбинации
--3.Получился список заказов
GROUP	BY	FirstName + ' ' + LastName
--4.Группируем по продавцам

--Сколько штук каждого товара (Название) мы продали? (Дополнительно: Больше 100 штук. Дополнительно: Какой больше всего продавался)
SELECT		TOP(1) ProductName, SUM(Quantity) AS Quantity
FROM		Products AS P CROSS JOIN [Order Details] AS OD
WHERE		P.ProductID = OD.ProductID
GROUP BY	ProductName
HAVING		SUM(Quantity) > 100	--Дополнительно 1
ORDER BY	SUM(Quantity) DESC	--Дополнительно 2

--Если таблиц больше 2, то нужно перемножить все что в условии + все что между этими таблицами
--Сколько денег выручил каждый продавец (ФИО)?
SELECT		LastName + ' ' + FirstName AS Name, SUM(UnitPrice * Quantity * (1 - Discount)) AS Income
FROM		Employees AS E CROSS JOIN Orders AS O CROSS JOIN [Order Details] AS OD
WHERE		E.EmployeeID = O.EmployeeID
		AND	O.OrderID = OD.OrderID
GROUP BY	LastName + ' ' + FirstName

--INNER JOIN - Это как cross join но со встроенной фильтровкой (Пересечение)
--Сколько заказов оформил каждый покупатель в 1997?
SELECT		FirstName + ' ' + LastName, COUNT(*)
FROM		Employees AS E CROSS JOIN Orders AS O
WHERE		E.EmployeeID = O.EmployeeID	-- Это условие постоянно при CROSS JOIN, его убираем с помощью INNER JOIN
		AND	YEAR(OrderDate) = 1997		-- Бизнес условие, в каждой задаче разное
GROUP BY	FirstName + ' ' + LastName
----------------
--Переделываем в INNER JOIN с фильтрацией ВНЕ join (По умолчания делается так)
--Нужно разделять технические и бизнес условия
SELECT		FirstName + ' ' + LastName, COUNT(*)
FROM		Employees AS E INNER JOIN Orders AS O
			ON E.EmployeeID = O.EmployeeID
WHERE		YEAR(OrderDate) = 1997
GROUP BY	FirstName + ' ' + LastName
--Можно поменять местами проверку ключей и произвольного условия
SELECT		FirstName + ' ' + LastName, COUNT(*)
FROM		Employees AS E INNER JOIN Orders AS O
			ON YEAR(OrderDate) = 1997
WHERE		E.EmployeeID = O.EmployeeID
GROUP BY	FirstName + ' ' + LastName
--Можно оставить фильтрацию ВНУТРИ join
SELECT		FirstName + ' ' + LastName, COUNT(*)
FROM		Employees AS E INNER JOIN Orders AS O
			ON E.EmployeeID = O.EmployeeID
			AND YEAR(OrderDate) = 1997
GROUP BY	FirstName + ' ' + LastName

--Задача INNER JOIN на 4 таблицы
--Как называется категория, которой заинтересовалос больше всего покупателей?
SELECT		TOP(1) CategoryName--, COUNT(DISTINCT CustomerID) as Q_CustomerID
FROM		Categories AS C INNER JOIN Products AS P	ON C.CategoryID = P.CategoryID
			INNER JOIN [Order Details] AS OD	ON	P.ProductID = OD.ProductID
			INNER JOIN Orders AS O	ON OD.OrderID = O.OrderID
GROUP BY	CategoryName
ORDER BY	COUNT(DISTINCT CustomerID) DESC

-----Типичные ошибки при использовании join
--Сколько заказов сделал каждый покупатель (ФИО)?
--Решение с помоью подзапроса (Вывел 91 строку)
SELECT		ContactName,
			(
			SELECT	COUNT(*)
			FROM	Orders
			WHERE	CustomerID = Customers.CustomerID
			)
FROM		Customers
ORDER BY	ContactName ASC
--Решение с помощью join (Вывел 89 строк)
SELECT		ContactName, COUNT(*)
FROM		Customers AS C INNER JOIN Orders AS O ON C.CustomerID = O.CustomerID
GROUP BY	ContactName
--Тк у нас есть покупатели без заказов, нужно использовать LEFT JOIN
SELECT		ContactName, COUNT(*) --Тут появляется ОШИБКА №2
FROM		Customers AS C LEFT JOIN Orders AS O ON C.CustomerID = O.CustomerID
GROUP BY	ContactName
--При стороннем join нельзя использовать COUNT(*), т.к. будем считать не понятно что
--В таком случае нужно применять COUNT к какому то полю из второй таблицы (При LEFT JOIN) и которое ВСЕГДА ЕСТЬ (Обычно это первичный ключ)
SELECT		ContactName, COUNT(OrderID) --Поправляем COUNT
FROM		Customers AS C LEFT JOIN Orders AS O ON C.CustomerID = O.CustomerID
GROUP BY	ContactName

--Сколько штук продал каждый продавец (ФИО) в Лондон? Дополнительно: Считать товары только с номером 1.
SELECT		FirstName + ' ' + LastName, IsNull(SUM(Quantity),0)
FROM		Employees AS E LEFT JOIN Orders AS O	ON E.EmployeeID = O.EmployeeID
			LEFT JOIN [Order Details] AS OD	ON	O.OrderID = OD.OrderID
		AND	ShipCity = 'London'
WHERE		ProductID = 1	--Дополнительно
GROUP BY	FirstName + ' ' + LastName