UPDATE	Authors
SET		City = 'Кострома',
		au_lname = REVERSE (au_lname),
		Contract = 1 - Contract
WHERE 	City IN ('Москва', 'Ленинград')
