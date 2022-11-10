SELECT		type, COUNT(*)
FROM		titles
--WHERE		COUNT(*) > 3 Не будет работать, выдаст ошибку, тк group by и нужен having
GROUP BY	type
HAVING		COUNT(*) > 3