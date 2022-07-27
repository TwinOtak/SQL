SELECT	* 
FROM	titles 
WHERE	price IS NULL

SELECT	* 
FROM	titles 
WHERE	price IS NOT NULL

SELECT	title + ' (' + notes + ')' 
FROM	titles

--Если складывать строки с NULL то получится NULL строка
--Можно делать вот так

SELECT	title + ' (' + IsNull (Notes, 'Нет описания') + ')' 
FROM	titles

--IsNull(Реальная строка, условие если стоит NULL)