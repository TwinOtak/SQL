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
SELECT		FirstName + '' + LastName AS Name, COUNT(*) AS Quantity	--5.Считаем количество заказов
FROM		Employees AS E CROSS JOIN Orders AS O	--1.Перемножаем все, что в условии
WHERE		E.EmployeeID = O.EmployeeID	--2.Отбираем действительные комбинации
										--3.Получился список заказов
GROUP	BY	FirstName + '' + LastName	--4.Группируем по продавцам
