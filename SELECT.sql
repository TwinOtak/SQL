SELECT	Title, price
FROM	Titles
---------------------------
SELECT	Title,
		Price,
		Price * (1+0.18) AS PriceWithVAT
FROM	Titles

SELECT	au_FName + '' + au_LName AS Name
FROM	authors