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