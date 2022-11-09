SELECT TOP(100) *
FROM	authors

INSERT 
INTO	Authors (au_id, au_fname, au_lname, city, contract) --Всегда упоминать колонки для вставки(делает запрос более устойчивым к последующим изменениям таблицы)
VALUES	('111-22-3333', 'Евгений', 'Онегин', 'Ленинград', 1),
		('111-22-3334', 'Владимир', 'Ленский', 'Москва', 0)

UPDATE	Authors
SET		City = 'Кострома',
		au_lname = REVERSE (au_lname),
		Contract = 1 - Contract
WHERE 	City IN ('Москва', 'Ленинград') --Обязательно прописывать для точного изменения позиций, а не всей таблицы
