﻿--Работа с текстом-------------------------------------------
--Like
SELECT		*
FROM		Production.ProductDescription
WHERE		Description LIKE '%ride%'		-- 20 Товаров
--Если поставить слева и справа от слова ПРОБЕЛЫ то будет искать конкретное слово
SELECT		*
FROM		Production.ProductDescription
WHERE		Description LIKE '% ride %'		-- 6 строк Товаров
--Но тогда придется учитывать что может не брать слова где рядом стоит какой-либо знак, точка, запятая и т.д.
SELECT		*
FROM		Production.ProductDescription
WHERE		Description LIKE '% ride %'		-- 10 строк Товаров
		OR	Description LIKE '% ride.%'
		OR	Description LIKE '% ride,%'

--Полнотекстовые операторы-- Более продвинутая штука, работает со специальным алфавитным указателем
--Contains-- Ищет четко конкретное слово
SELECT		*
FROM		Production.ProductDescription
WHERE		Contains (Description, 'ride') -- 10 строк

--FreeText-- Учитывает морфологию(Падежи, множественное число и т.д.)
SELECT		*
FROM		Production.ProductDescription
WHERE		FreeText (Description, 'ride') -- 22 строки

--Contains Table--
SELECT		ProductDescriptionID, Description, CT.[key], RANK
FROM		[Production].[ProductDescription] AS P
			INNER JOIN
			ContainsTable	(
							[Production].[ProductDescription],
							Description,
							'ride'
							) CT
			ON P.ProductDescriptionID = CT.[Key]
ORDER BY	CT.Rank DESC

--FreeTextTable-- Работает так же как и Contains Table, только с упором на свои особенности
SELECT		ProductDescriptionID, Description, CT.[key], RANK
FROM		[Production].[ProductDescription] AS P
			INNER JOIN
			FreeTextTable	(
							[Production].[ProductDescription],
							Description,
							'ride'
							) CT
			ON P.ProductDescriptionID = CT.[Key]
ORDER BY	CT.Rank DESC