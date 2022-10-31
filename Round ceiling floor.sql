SELECT	price, 
		Round(price, 0), Round(price, -1), --количество чисел после запятой
		Ceiling(price), Floor(price) --Округлениее веерх, вниз
FROM	titles