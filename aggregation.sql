SELECT	Avg(Price), Min(Price), Max(Price), Sum(Price)
FROM	titles

SELECT	Avg(Price), Avg(Price * (1 + 0.18)) --Можно передавать производные значения
FROM	titles

SELECT	Count(*), Count(Price) --1. Считает строки с Null; 2. Считает строки со значениями в выбранном столбце
FROM	titles


SELECT	Avg(Price)	--Сначала срабатывает WHERE
FROM	titles
WHERE	type = 'business'

----------------------------------------------------------------------

SELECT	Avg(UnitPrice) -- для другой бд
FROM	Products
WHERE	CategoryID = 1