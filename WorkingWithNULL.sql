SELECT	ContactName
FROM	customers
WHERE	city = 'London'
	AND	fax IS NOT NULL

SELECT	Title + '(' + Notes + ')', 
		Title + '(' + IsNull(Notes, '��� ��������') + ')'
FROM	titles