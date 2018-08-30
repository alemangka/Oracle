-- 1.  �ڽ��� ����� TABLESPACE�� ���� ����
CREATE TABLESPACE userTS
DATAFILE 'd:\oData\userts.dbf'
SIZE 100M AUTOEXTEND ON NEXT 100K ;

-- 2. DEFAULT�� ����
ALTER USER user1 DEFAULT TABLESPACE userTS ;

-- 3. TABLE ����
CREATE TABLE test (
    ID NUMBER, -- �ִ� 40�ڸ����� ���� ����
    NAME VARCHAR2(20),
    POSTCODE CHAR(5),
    ADDR VARCHAR2(50),
    TEL VARCHAR2(15),
    GRADE NUMBER(5,2) -- ��ü �ڸ��� 5��, �Ҽ������� 2�ڸ�
);

-- ���̺� ���� Ȯ��
DESC test ;

-- ���̺� ����
DROP TABLE test ;

-- ������ �߰�
INSERT INTO test (name, addr, tel) VALUES('ȫ�浿','�����','02') ;
-- �ʿ��� Į���� �����ؼ� �߰�

INSERT INTO test
VALUES(1, '�̸���', '61182', '����', '042', 90) ;
-- ��ü Į���� �߰�

-- ������ Ȯ��
SELECT * FROM test ;

-- DCL(Data Controll Lang)
COMMIT ;

-- ������ ����
DELETE FROM test ;
ROLLBACK ;
SELECT * FROM test ;

INSERT INTO test
VALUES(2, '�̸���', '61182', '����', '042', 90) ;

INSERT INTO test
VALUES(3, '������', '61182', '����', '042', 90) ;

COMMIT ; -- INSERT, UPDATE, DELETE�� ������ ����� ���� DB�� �ݿ�


INSERT INTO test
VALUES(2, '�̸���', '61182', '����', '042', 90) ;
INSERT INTO test
VALUES(3, '������', '61182', '����', '042', 90) ;

ROLLBACK ;

SELECT * FROM test ;

DELETE FROM test ;

SET AUTOCOMMIT OFF ;

-- ROLLBACK�� �������� �Ǽ��� UPDATE, DELETE�� �������� ��
-- ���� ���·� �ǵ����� ���
-- ROLLBACK�� �ȵǴ� ���
-- COMMIT�� ������ ������ ��, DDL ����� �������� ��
-- TRUNCATE ��� = DELETE ��ɰ� ����
-- TRUNCATE ����� ������ �Ŀ��� ROLLBACK���� �ǵ��� �� ����.
-- TABLE �����ؼ� ��ü �����͸� �����ϴ� ��� 3����
-- 1. DELETE FROM [table]�� WHERE ���� ������ ���
-- 2. DROP TABLE >> �ƿ� TABLE ��ü�� ����
-- 3. TRUNCATE TABLE >> TABLE�� ���� �ߴٰ� �ٽ� CREATE
--      DROP TABLE + CREATE TABLE

-- ���� �ý��۽ð����κ��� 5�������� ����
CREATE TABLE test_bak AS
SELECT * FROM test AS OF TIMESTAMP(SYSTIMESTAMP - INTERVAL '5'MINUTE) ;

-- 1�ð� ��
SELECT * FROM test AS OF TIMESTAMP(SYSTIMESTAMP - INTERVAL '1'HOUR) ;





