-- Универсально, но нечитаемо
SELECT	*
FROM	sales
WHERE	ord_date = '19940913'
-- Читаемо, но непривычно и зависит от формата бд
SELECT	*
FROM	sales
WHERE	ord_date = '1994-13-09'
-- Читаемо, привычно, но лишняя функция
SET DATEFORMAT dmy
SELECT	*
FROM	sales
WHERE	ord_date = '13.09.1994'