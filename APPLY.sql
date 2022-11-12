--APPLY - разновидность join

--Показать названия двух самых дорогих товаров в каждой категории
--Если решать данную задачу подзапросам, то непонятно таблицу ЧЕГО мы хотим получить в конце
--Если решать join'ами мы споткнемся на написании группировки, тк мы схлопнем либо категории, либо товары
--Конечно можно решить и одним и вторым способом, но придется все усложнить

--Решая подзапросами
--Находим Топ 1 товар по цене
SELECT	CategoryName,
		(
		SELECT	TOP(1) ProductName
		FROM	Products
		WHERE	Products.CategoryID = Categories.CategoryID
		ORDER BY UnitPrice ASC
		)
FROM	Categories
	UNION ALL
--Находим Топ 2 товара и из них вытаскиваем ВТОРОЙ
SELECT	CategoryName,
		(
		SELECT	TOP(1) ProductName
		FROM	(
				SELECT	TOP(2) ProductName, UnitPrice
				FROM	Products
				WHERE	CategoryID = Categories.CategoryID
				ORDER BY UnitPrice DESC
				) as TopProducts
		ORDER BY UnitPrice ASC
		)
FROM	Categories
ORDER BY CategoryName
--Решение абсолютно не гибкое, тк если нас попросят вытащить 50 товаров, то придется 50 раз копировать вторую часть и менять там ТОП
--Нужно чтобы можно было задавать переменной
--Для таких ситуаций и придуман APPLY
--Пример
SELECT	C.CategoryName, P.ProductName
FROM	Categories AS C CROSS APPLY	(
									SELECT	TOP(2) *
									FROM	Products
									WHERE	CategoryID = C.CategoryID
									ORDER BY UnitPrice DESC
									) P
--Добавляем with ties
SELECT	C.CategoryName, P.ProductName, UnitPrice
FROM	Categories AS C CROSS APPLY	(
									SELECT	TOP(4) WITH TIES *
									FROM	Products
									WHERE	CategoryID = C.CategoryID
									ORDER BY UnitPrice DESC
									) P

--Для каждого продавца показать три его любимых города? (Город в который он чаще всего продает заказы)
--Продавцы - Список №1 (Его перебираем), Города - Список №2 (Его обновляем). Начинаем решать со второго списка.
--Строим второй список
SELECT	TOP(3) WITH TIES ShipCity, COUNT(*)
FROM	Orders
WHERE	EmployeeID = 2
GROUP BY ShipCity
ORDER BY COUNT(*) DESC
--Вот три любимых города для продавца №2. (Для примера: У него есть одинаковые значения)
--Теперь формируем первый список
SELECT	FirstName + ' ' + LastName
FROM	Employees
--Теперь соединяем списки через CROSS APPLY
SELECT	FirstName + ' ' + LastName, ShipCity
FROM	Employees AS E	CROSS APPLY (
									SELECT	TOP(3) WITH TIES ShipCity
									FROM	Orders
									WHERE	EmployeeID = E.EmployeeID
									GROUP BY ShipCity
									ORDER BY COUNT(*) DESC
									) AS C