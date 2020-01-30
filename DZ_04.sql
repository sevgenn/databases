-- ii. �������� ������, ������������ ������ ���� (������ firstname) ������������� ��� ���������� � ���������� �������

SELECT DISTINCT vk.firstname from users
ORDER BY firstname ASC;

-- iii. �������� ������, ���������� ������������������ ������������� ��� ���������� (���� is_active = false).
--      �������������� �������� ����� ���� � ������� profiles �� ��������� �� ��������� = true (��� 1)

ALTER TABLE vk.profiles ADD is_active BIT DEFAULT 1 NULL;	-- �������� ������ �������	
UPDATE vk.profiles
SET is_active = 0
WHERE TIMESTAMPDIFF(YEAR,birthday,CURDATE()) < 18;			-- ������ �� ������������

-- iv. �������� ������, ��������� ��������� ��� �������� (���� ����� �����������)

DELETE FROM vk.messages
WHERE created_at > CURDATE();




