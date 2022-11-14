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
