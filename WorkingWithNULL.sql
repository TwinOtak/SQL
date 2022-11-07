SELECT	ContactName
FROM	customers
WHERE	city = 'London'
	AND	fax IS NOT NULL

SELECT	Title + '(' + Notes + ')', 
		Title + '(' + IsNull(Notes, 'no description') + ')'
FROM	titles