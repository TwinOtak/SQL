-- ”ниверсально, но нечитаемо
SELECT	*
FROM	sales
WHERE	ord_date = '19940913'
-- „итаемо, но непривычно и зависит от формата бд
SELECT	*
FROM	sales
WHERE	ord_date = '1994-13-09'
-- „итаемо, привычно, но лишн€€ функци€
SET DATEFORMAT dmy
SELECT	*
FROM	sales
WHERE	ord_date = '13.09.1994'