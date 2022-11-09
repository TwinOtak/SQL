SELECT	TOP(1) ProductName, UnitPrice
FROM	Products
ORDER BY	UnitPrice DESC	--по убыванию

SELECT	TOP(11) WITH TIES ProductName, UnitPrice --Добирает дубликаты значений, чтобы их учитывать
FROM	Products
ORDER BY	UnitPrice DESC	--по убыванию

--Выводит самого молодого сотрудника из лондона
SELECT	TOP(1) WITH TIES *
FROM	Employees
WHERE	City = 'London'
ORDER BY	BirthDate DESC --по возрастанию
