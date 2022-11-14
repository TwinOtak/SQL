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

--Новый постраничный вывод
SELECT		ProductName, UnitPrice
FROM		Products
ORDER BY	UnitPrice DESC
			OFFSET	(3-1) * 5 ROWS		--Сколько строк пропустить
			FETCH	NEXT 5 ROWS ONLY	--Размер страницы