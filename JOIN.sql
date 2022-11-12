--CROSS JOIN - Самый обычный join
SELECT		*
FROM		Categories CROSS JOIN Employees

--JOIN позновляет создавать нам пары значений из одной таблицы
--Например пары продавцов
SELECT		E1.FirstName + ' ' + E1.LastName,
			E2.FirstName + ' ' + E2.LastName
FROM		Employees AS E1 CROSS JOIN Employees AS E2
WHERE		E1.TitleOfCourtesy = 'Mr.'	--Слева фильтруем мальчиков
		AND	E2.TitleOfCourtesy = 'Ms.'	--Справа фильтруем девочек
		AND E1.City = E2.City			--Смотрим чтобы они были из одного города

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

--Пример INNER JOIN с тремя таблицами
--Сколько денег выручил каждый продавец (ФИО)?
SELECT		LastName + ' ' + FirstName AS Name, SUM(UnitPrice * Quantity * (1 - Discount)) AS Income
FROM		Employees AS E INNER JOIN Orders AS O	ON E.EmployeeID = O.EmployeeID
			INNER JOIN [Order Details] AS OD		ON O.OrderID = OD.OrderID
GROUP BY	LastName + ' ' + FirstName

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

--Сколько заказов оформил каждый продавец (ФИО) в Париж?
SELECT		FirstName + ' ' + LastName, COUNT(OrderID)
FROM		Employees AS E LEFT JOIN Orders AS O	ON E.EmployeeID = O.EmployeeID
		AND	ShipCity = 'Paris'	--Правильно
--WHERE		ShipCity = 'Paris'	--Не правильно
GROUP BY	FirstName + ' ' + LastName


------------------------------------------------------------------------------------
--Работа Cross Join
SELECT		CategoryName, CategoryID,
			EmployeeID, FirstName + ' ' + LastName
--				8					9	=8*9=72 строки
FROM		Categories CROSS JOIN Employees
--Работа Inner Join
SELECT		CategoryName, CategoryID,
			EmployeeID, FirstName + ' ' + LastName
--				8						9			=на выходе 8 строк в этом условии
FROM		Categories AS C INNER JOIN Employees AS E	ON C.CategoryID = E.EmployeeID
--Работа Left Join
SELECT		CategoryName, CategoryID,
			EmployeeID, FirstName + ' ' + LastName
--				8						9			= на выходе 8 строк, тк Left Join больше нечего добавить к таблице
FROM		Categories AS C LEFT JOIN Employees AS E	ON C.CategoryID = E.EmployeeID
--Работа Right Join
SELECT		CategoryName, CategoryID,
			EmployeeID, FirstName + ' ' + LastName
--				8						9			= на выходе 9 строк, тк во второй таблице строк больше
FROM		Categories AS C RIGHT JOIN Employees AS E	ON C.CategoryID = E.EmployeeID

SELECT		CategoryName, CategoryID,
			EmployeeID, FirstName + ' ' + LastName
--				8						9			--Условие никогда не выполнится, но спасет строки из правой таблицы
FROM		Categories AS C RIGHT JOIN Employees AS E	
			ON 1 = 2
			--ON C.CategoryID = E.EmployeeID
----Работа Full Join
SELECT		CategoryName, CategoryID,
			EmployeeID, FirstName + ' ' + LastName
--				8						9			= Условие никогда не выполнится, но спасает строки из двух таблиц, подставляя значения NULL
FROM		Categories AS C FULL JOIN Employees AS E	
			ON 1 = 2
			--ON C.CategoryID = E.EmployeeID


SELECT		CategoryName, CategoryID,
			EmployeeID, FirstName + ' ' + LastName
--				8						9
FROM		Categories AS C RIGHT JOIN Employees AS E	
			ON C.CategoryID < E.EmployeeID
------------------------------------------------------------------------------------

--Сколько штук продал каждый продавец (ФИО) в Лондон? Дополнительно: Считать товары только с номером 1.
SELECT		FirstName + ' ' + LastName, IsNull(SUM(Quantity),0)
FROM		Employees AS E LEFT JOIN Orders AS O	ON E.EmployeeID = O.EmployeeID
			LEFT JOIN [Order Details] AS OD	ON	O.OrderID = OD.OrderID
		AND	ShipCity = 'London'
		AND ProductID = 1	--Дополнительно
GROUP BY	FirstName + ' ' + LastName

--Пример			--ЭТО ПРИМЕР НЕПРАВИЛЬНОГО РЕШЕНИЯ JOIN'ОМ С ОШИБКОЙ
--Сколько штук чая(ProductName = 'chai') продал каждый продавец (ФИО) в Лондон?
SELECT		FirstName + ' ' + LastName, IsNull(SUM(Quantity),0)
FROM		Employees AS E LEFT JOIN Orders AS O	ON E.EmployeeID = O.EmployeeID
		AND	ShipCity = 'London'
			LEFT JOIN [Order Details] AS OD	ON	O.OrderID = OD.OrderID
			LEFT JOIN Products AS P	ON OD.ProductID = P.ProductID
		AND P.ProductName = 'Chai'	
GROUP BY	FirstName + ' ' + LastName

--Пример. Пояснение	--ЭТО ПРИМЕР НЕПРАВИЛЬНОГО РЕШЕНИЯ JOIN'ОМ С ОШИБКОЙ
SELECT		FirstName + ' ' + LastName, ShipCity, P.ProductID, Quantity,  ProductName
FROM		Employees AS E LEFT JOIN Orders AS O	ON E.EmployeeID = O.EmployeeID
		AND	ShipCity = 'London'
			LEFT JOIN [Order Details] AS OD	ON	O.OrderID = OD.OrderID
			LEFT JOIN Products AS P	ON OD.ProductID = P.ProductID
		AND P.ProductName = ('Chai')	

--ПРИМЕР ПРАВИЛЬНОГО РЕШЕНИЯ методом закрутки join'ов в обратную сторону (Не очень красивый метод, но простой)
SELECT		FirstName + ' ' + LastName, IsNull(SUM(Quantity),0)
FROM		Products AS P INNER JOIN [Order Details] AS OD	ON P.ProductID = OD.ProductID	--Тут меняем на INNER
		AND P.ProductName = 'Chai'
			INNER JOIN Orders AS O	ON OD.OrderID = O.OrderID	--Тут меняем на INNER
		AND	ShipCity = 'London'
			RIGHT JOIN Employees AS E	ON E.EmployeeID = O.EmployeeID	--Тут меняем на RIGHT
GROUP BY	FirstName + ' ' + LastName

--ПРИМЕР ПРАВИЛЬНОГО РЕШЕНИЯ методом установки скобочек
--УСТАНОВКА СКОБОЧЕК для порядка действий
SELECT		FirstName + ' ' + LastName, IsNull(SUM(Quantity),0)
FROM		Employees AS E LEFT JOIN
			(
			Orders AS O	INNER JOIN [Order Details] AS OD
			ON	O.OrderID = OD.OrderID
			AND	ShipCity = 'London'
			INNER JOIN Products AS P
			ON OD.ProductID = P.ProductID
			AND P.ProductName = 'Chai'
			)
			ON E.EmployeeID = O.EmployeeID
GROUP BY	FirstName + ' ' + LastName

--Сколько штук каждого товара (Название) мы продали в августе 1996 года?
SELECT	ProductName, IsNull(SUM(Quantity),0)
FROM	Products AS P LEFT JOIN 
		(
		[Order Details] AS OD INNER JOIN Orders AS O
		ON OD.OrderID = O.OrderID
		AND YEAR(OrderDate) = 1996
		AND MONTH(OrderDate) = 8
		)
		ON P.ProductID = OD.ProductID
GROUP BY	ProductName