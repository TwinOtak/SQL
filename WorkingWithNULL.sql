SELECT	Title + '(' + Notes + ')', --так делать нельзя
		Title + '(' + IsNull(Notes, 'нет описания') + ')'
FROM	titles

SELECT	ContactName
FROM	customers
WHERE	city = 'London'
	AND	fax IS NOT NULL

SELECT	ContactName
FROM	customers
WHERE	city = 'London'
	AND	fax IS NULL
