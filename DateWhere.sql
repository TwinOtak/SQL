-- ������������, �� ���������
SELECT	*
FROM	sales
WHERE	ord_date = '19940913'
-- �������, �� ���������� � ������� �� ������� ��
SELECT	*
FROM	sales
WHERE	ord_date = '1994-13-09'
-- �������, ��������, �� ������ �������
SET DATEFORMAT dmy
SELECT	*
FROM	sales
WHERE	ord_date = '13.09.1994'