SELECT	price, 
		Round(price, 0), Round(price, -1), --���������� ����� ����� �������
		Ceiling(price), Floor(price) --����������� �����, ����
FROM	titles