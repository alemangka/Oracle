-- �ּ��� ǥ���� ���� ���̳ʽ� 2���� ����

-- DB Language���� �з�
-- CREATE�� ���۵Ǵ� ��ɵ��� DBA(SYSDBA)�� ����ϴ� DDL(Database Definition Lang)�̴�.
--      DROP���� ���۵Ǵ� ��ɵ��� DBA�� ����ϴ� DDL�̸�, �ſ� ������ ����̴�.
-- SELECT, UPDATE, INSERT, DELETE ����� DBA�� DataUser�� ����ϴ� DML(Data Management Lang)�̴�.
-- GRANT, REVOKE ����� DBA ���� ����ϴµ� DCL(Data Controll Lang)�̴�.

-- SQL Developer ����
-- �� ȭ���� sys�� ������ ȭ��
-- sys(SYSDBA ����) ����ڴ�
-- ���ο� �����, ���ο� �����, ���ο� DB ���� ���� �� �ְ�, �����ϴ� ������ ���´�.

-- ���� ���ӵ� ����ڰ� ����?
SHOW user ;

-- ���� �ý��ۿ� ��ϵ� ����ڸ� ��� ������.
SELECT *
FROM all_users
WHERE username = 'HR' ;

-- 1. ���ο� ����� ����
--      ����Ŭ������ ���ο� DataBase�� �����ϱ� ���� ���ο� ����Ҹ� ����� ���� �����Ѵ�.
--      ����, ���ο� ����Ҹ� ������ �ʰ�, DataBase�� �����ص� ������
--      ���ο� ����Ұ� ���� DataBase�� ����� �Ǹ�, ����Ŭ DataBase Server�� �δ��� �ȴ�.
-- ����Ŭ�� "�����"�� "TableSpace"��� �Ѵ�.
-- ��. ����ڰ� ���Ƿ� ���� ������ ������ �� �ְ�, �ʱ� ũ�⸦ ������ �� �ִ�.
CREATE TABLESPACE myts -- ���� ����� tablespace �̸�
DATAFILE 'd:\oData\myts.dbf' -- ���� ����� ����
SIZE 100M -- ���ʿ� ��������� 100MB ��ŭ Ȯ���϶�
AUTOEXTEND -- ����߿� �뷮�� �����ϸ� �ڵ����� ũ�⸦ �÷���
ON NEXT 100K ; -- �̶�, 100KB ������ �÷���

-- TABLESPACE ����
-- �ſ� �����ؼ� ����� ��!!!
DROP TABLESPACE myts
INCLUDING CONTENTS AND DATAFILES
CASCADE CONSTRAINTS ;

-- 2. ���ο� ����� ���
CREATE USER test1 IDENTIFIED BY 1234 ;

SELECT *
FROM all_users ;

-- ����� ����
DROP USER test1 CASCADE ; -- ����ڸ� �����ϰ� ���õ� ������ �����϶�.

CREATE USER user1 IDENTIFIED BY 1234 ;
-- ���ο� ����� ��� ���Ŀ���
-- �� ����ڿ��Դ� �ƹ��� ������ ����.(GUEST)
-- ����Ŭ������ ���ο� ����� ��� �� �ּ����� ������ �ο� �ؾ��Ѵ�.

-- �ּ����� ����(DB�� ������ �� �ִ� ����)
GRANT CREATE SESSION TO user1 ;

-- Data �б� ����
-- ��� ���̺��� ���� �� �ִ� ����
GRANT SELECT ANY TABLE TO user1 ; -- ���� �ֱ�
REVOKE SELECT ANY TABLE FROM user1 ; -- ���� ����

-- �б� ������ ��Ģ
-- [table]�� ���� �� �ִ� ����
GRANT SELECT ON [table] TO user1 ;

-- �ý��� ����
GRANT DBA TO user1 ;
-- sysDBA���� �Ѵܰ� ���� DBA�� ������ �ο��ϴ� ��
-- CREATE�� ���κ�, CRUD�� ��� ���, DCL ��� ���� ������ �� �ִ� ����
