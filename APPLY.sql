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