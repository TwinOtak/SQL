--Ранжирование
--Row_Number

SELECT		ProductName, UnitPrice,
			ROW_NUMBER() OVER(ORDER BY UnitPrice DESC)
FROM		Products
ORDER BY	UnitPrice DESC -- тут можем менять поле, но ранжирование будет сохраняться по тому полю, что сверху в скобочках

--Rank
SELECT		ProductName, UnitPrice,
			RANK() OVER(ORDER BY UnitPrice DESC)
FROM		Products
ORDER BY	UnitPrice DESC -- тут можем менять поле, но ранжирование будет сохраняться по тому полю, что сверху в скобочках

--Dense_Rank
SELECT		ProductName, UnitPrice,
			DENSE_RANK() OVER(ORDER BY UnitPrice DESC)
FROM		Products
ORDER BY	UnitPrice DESC -- тут можем менять поле, но ранжирование будет сохраняться по тому полю, что сверху в скобочках

--nTile -- Разбивает таблицу на равное количество выбранных секций
SELECT		ProductName, UnitPrice,
			nTile(3) OVER(ORDER BY UnitPrice DESC)
FROM		Products
ORDER BY	UnitPrice DESC -- тут можем менять поле, но ранжирование будет сохраняться по тому полю, что сверху в скобочках

--Дополнительно
--Секционирование
SELECT		ProductName, CategoryID, UnitPrice,
			RANK() OVER	(
						PARTITION BY CategoryID
						ORDER BY UnitPrice DESC
						)
FROM		Products
ORDER BY	CategoryID, UnitPrice DESC

--
SELECT		ProductName, CategoryID, UnitPrice,
			nTile(3) OVER	(
						PARTITION BY CategoryID
						ORDER BY UnitPrice DESC
						)
FROM		Products
ORDER BY	CategoryID,
			UnitPrice DESC

--Выбрать значения после ранжирования
SELECT	*
FROM	(
		SELECT		ProductName, CategoryID, UnitPrice,
					nTile(3) OVER	(
								PARTITION BY CategoryID
								ORDER BY UnitPrice DESC
								) AS PriceGroup
		FROM		Products
		) AS MyProducts
WHERE	PriceGroup = 3

-----------------------------------------------------------
--Старый постраничный вывод
SELECT	*
FROM	(
		SELECT		ProductName, UnitPrice,
					ROW_NUMBER() OVER	(
									ORDER BY UnitPrice DESC
									) AS Num
		FROM		Products
		) AS MyScroller
WHERE	Num BETWEEN 11 AND 20

--Добавление переменных к постраничному вводу
	
DECLARE	@Page int, @PageSize int
SET		@Page = 3
SET		@PageSize = 5

SELECT	*
FROM	(
		SELECT		ProductName, UnitPrice,
					ROW_NUMBER() OVER	(
									ORDER BY UnitPrice DESC
									) AS Num
		FROM		Products
		) AS MyScroller
WHERE	Num BETWEEN (@Page -1) * @PageSize + 1 AND @Page * @PageSize

--Новый постраничный вывод--Возможно работает только MsSQL
SELECT		ProductName, UnitPrice
FROM		Products
ORDER BY	UnitPrice DESC
			OFFSET	(3-1) * 5 ROWS		--Сколько строк пропустить
			FETCH	NEXT 5 ROWS ONLY	--Размер страницы

----------------------------------------------------------------------
--Смещение (Lag, Lead)
SELECT		OrderID, Freight,
			LAG(Freight) OVER (ORDER BY OrderID ASC),
			LAG(Freight, 7) OVER (ORDER BY OrderID ASC),	--Задаем смещение (По умолчанию = 1)
			LAG(Freight, 7, 0) OVER (ORDER BY OrderID ASC)	--Встроенный IsNull
FROM		Orders
--Lead--Работает так же, только двигается в другую сторону
SELECT		OrderID, Freight,
			LEAD(Freight) OVER (ORDER BY OrderID ASC),
			LEAD(Freight, 7) OVER (ORDER BY OrderID ASC),	--Задаем смещение (По умолчанию = 1)
			LEAD(Freight, 7, 0) OVER (ORDER BY OrderID ASC)	--Встроенный IsNull
FROM		Orders

--Красивое представление смещения
SELECT		YEAR(OrderDate), MONTH(OrderDate),
			SUM(Freight),	--Сумма за месяц
			LAG(SUM(Freight)) OVER (ORDER BY YEAR(OrderDate), MONTH(OrderDate)), -- Смещение
			SUM(Freight) - LAG(SUM(Freight)) OVER (ORDER BY YEAR(OrderDate), MONTH(OrderDate)), -- Разница между месяцами
			SIGN(SUM(Freight) - LAG(SUM(Freight)) OVER (ORDER BY YEAR(OrderDate), MONTH(OrderDate))) --Возвращает знак числа
FROM		Orders
GROUP BY	YEAR(OrderDate), MONTH(OrderDate)
ORDER BY	YEAR(OrderDate), MONTH(OrderDate)

