-- �̹� ������ ������ ó���ϸ鼭 ����ϰ� �ִ�
-- ���Ը������ ���� ������ �ִµ�
-- �� ���Ͽ� �ִ� ���Ը������� ����Ŭ Database�� �ű��

-- �ǹ��󿡼� ����ϴ� DataBase�� Table �з�
-- 1. master table
--  ��. �⺻���� ������ ��� �ִ� table
--  ��. ���� data�� �Էµǰ�, ��ȸ�Ǵ� table�� ���� ������ �����ϴ� table
--  ��. �ŷ�ó ������ ������ table, ��ǰ������ ������ table

-- 2. work table
--  ��. ���÷� �����Ͱ� insert, update, delete�� �Ǿ � ���� �帧�� �ľ��� �� �ִ� table
--  �� . ���Ը����� ����ϴ� table

CREATE TABLE tbl_inout(
    io_id	NUMBER	NOT NULL	PRIMARY KEY,	
    io_date	CHAR(10)	NOT NULL,		
    io_dept	VARCHAR2(20)	NOT NULL,		
    io_inout	CHAR(1)	NOT NULL,   -- 1:����, 2:����
    io_pro_name	VARCHAR2(20)	NOT NULL,		
    io_pro_qty	VARCHAR2(10),			
    io_vat_check	CHAR(1),	    -- 1:����, 2: �鼼
    io_su	NUMBER,			
    Io_dan	NUMBER,			
    io_sub_total	NUMBER,		    -- �ܰ� * ����
    io_vat	NUMBER,		            -- �����̸� �ݾ�/10
    io_total	NUMBER	            -- �ݾ� * ����
);

DESC tbl_inout ;

-- ��ü ������ Ȯ��
SELECT * FROM tbl_inout;

-- ��ü ������ ���� Ȯ��
SELECT COUNT(*) FROM tbl_inout ;

DELETE tbl_inout ;

-- �����ڷ� ���� Ȯ��
SELECT COUNT(*)
FROM tbl_inout
GROUP BY io_inout ;

-- ������ �������� �Ϸ�

-- master ���̺�� worktable�� �и�
-- ����ȭ ����
-- ���Ը������̺�(tbl_inout)���κ��� �ŷ�ó������ ��ǰ������ �и�

-- 1. �ŷ�ó���� master table ����
--  ��. ���Ը��� ���̺�κ��� �ŷ�ó ������ ����
SELECT *
FROM tbl_inout
GROUP BY io_dept ;
-- GROUP BY�� ������ ���� SELECT�� ������ Į��(PROJECT Į��)�� ��� GROUP BY �׸� �����Ǿ�� �Ѵ�.
-- ��, GROUP BY�� ������ ���� SELECT * �� �ȵȴ�.

SELECT io_dept
FROM tbl_inout
GROUP BY io_dept
ORDER BY io_dept ;

CREATE TABLE tbl_dept (
    d_code	CHAR(4)	NOT NULL	PRIMARY KEY,
    d_name	VARCHAR2(20)	NOT NULL,	
    d_ceo	VARCHAR2(20),		
    d_tel	VARCHAR2(15),		
    d_sid	CHAR(13),		
    d_addr	VARCHAR(50),		
    d_man	VARCHAR(20),	
    d_man_tel	VARCHAR(15)		
);

DESC tbl_dept ;

SELECT * FROM tbl_dept ;
-- ��. �ŷ�ó master table�� ���� �Ϸ�

-- ��. ���Ը������ �ŷ�ó master�� �����ϵ��� ����

-- ���� ������� ���Ը������ �ŷ�ó������ JOIN�� �ؼ�
-- ������ ����

-- 2011�� 01�� 24�� �����ڷḸ Ȯ��
SELECT *
FROM tbl_inout
WHERE io_inout = '1' AND
io_date = '2011-01-24' ;

-- ������(��������) Į���� ���
-- BETWEEN�� ����ؼ� ������ �˻��� �����ϴ�.
-- �׷���, ��¥�� ����� Į���� ���������� �����
-- ��¥�� ���ڷ� ��ȯ �� INSERT �صθ�
-- ���� Date������ �������� �ʾƵ� �ȴ�.

-- DB���� Į���� Date, DateTime ������ �����ϸ�
-- �ٸ� ���α׷� ���� DB�� �����Ͽ� �����͸� INSERT, SELECT �Ҷ�
-- Data Type ������ �������� �������� ��Ÿ����.
SELECT *
FROM tbl_inout
WHERE io_date BETWEEN '2011-01-01' AND '2011-05-31' ;

SELECT io_date, io_inout, io_dept, d_code, d_name, d_ceo
FROM tbl_inout
LEFT JOIN tbl_dept
    ON tbl_inout.io_dept = tbl_dept.d_name
WHERE io_inout = '1' AND
io_date = '2011-01-24' ;
-- ���� ����� ���Ը������ �ŷ�ó������ ������ �� �� ���ִ��� Ȯ���ϴ� ����
-- ����ȯ�濡���� d_name���� �����ϴ� ������ ������� �ʴ´�.
-- ���Ը����忡 �ŷ�ó�ڵ� Į���� �����, �ŷ�ó���� �������� �ŷ�ó�ڵ带
-- UPDATE �� ����

-- ���Ը����忡 �ŷ�ó�ڵ� Į���� �߰�
ALTER TABLE tbl_inout ADD(io_dept_code CHAR(4)) ;

-- ������ �ŷ�ó�ڵ� Į���� �ŷ�ó �ڵ带 UPDATE�Ѵ�.
-- �ŷ�ó���� �ŷ�ó�������� �˻��ϰ�, �˻��� �ڵ带 UPDATE�ؾ��Ѵ�.
UPDATE tbl_inout
SET io_dept_code =
(
    SELECT d_code FROM tbl_dept
    WHERE io_dept = d_name
);

SELECT io_date, io_dept, io_dept_code
FROM tbl_inout
WHERE io_date = '2011-01-24' ;

SELECT io_dept_code, io_dept, d_name, d_ceo, d_tel
FROM tbl_inout
    LEFT JOIN tbl_dept
        ON io_dept_code = d_code
WHERE io_dept_code = 'D002' ;

-- �ŷ�ó �������� �ڵ尡 D002�� ȸ���� ��ȭ��ȣ��
-- 010-111-2222 �� �ٲٰ� �ʹ�.
UPDATE tbl_dept
SET d_tel = '010-111-2222'
WHERE d_code = 'D002' ;

-- 2. ��ǰ���� master ����
--  ��. ���Ը��� ���̺��� ��ǰ�� ����
SELECT io_pro_name
FROM tbl_inout
GROUP BY io_pro_name
ORDER BY io_pro_name ;

CREATE TABLE tbl_product (
    p_code	CHAR(6)	NOT NULL	PRIMARY KEY,
    p_name	VARCHAR2(20)	NOT NULL,	
    p_item	VARCHAR2(20),		
    p_qyt	VARCHAR2(15),		
    p_vat_check	CHAR(1),	
    p_iprice	NUMBER,		
    p_oprice	NUMBER,		
    p_margin	NUMBER		
);

-- ���Ը������ ��ǰ������ JOIN�ؼ� Ȯ��
SELECT io_pro_name, p_name
FROM tbl_inout
    LEFT JOIN tbl_product
    ON io_pro_name = p_name
    WHERE p_code = 'P00004' ;
    
ALTER TABLE tbl_inout ADD(io_p_code CHAR(6)) ;

-- ���Ը������� ��ǰ�ڵ� UPDATE
UPDATE tbl_inout
SET io_p_code =
(
    SELECT p_code
    FROM tbl_product
        WHERE p_name = io_pro_name
);

-- JOIN �� Ȯ��
SELECT io_p_code, p_code, io_pro_name, p_name
FROM tbl_inout
    LEFT JOIN tbl_product
        ON io_p_code = p_code ;
        
-- ���Ը������ ��ǰ������ JOIN ���Ը��� �ݾ� ���
SELECT io_date,
    DECODE(io_inout, '1', '����', '����' ) AS ����,
    io_p_code, p_name, io_su, p_iprice, p_oprice,
    DECODE(io_inout, '1', io_su * p_iprice, 0) AS ���Աݾ�,
    DECODE(io_inout, '2', io_su * p_oprice, 0) AS ����ݾ�
FROM tbl_inout
    LEFT JOIN tbl_product
        ON io_p_code = p_code ;

-- ���� ��ϵ� ���Ը������� �� ���Աݾװ�, �� ����ݾ� �׸��� ���� ���
-- ����Լ� �̿�
SELECT
    SUM( DECODE(io_inout, '1', io_su * p_iprice, 0)) AS ���Աݾ�,
    SUM( DECODE(io_inout, '2', io_su * p_oprice, 0)) AS ����ݾ�,
    
    SUM( DECODE(io_inout, '2', io_su * p_oprice, 0)) -
    SUM( DECODE(io_inout, '1', io_su * p_iprice, 0)) AS �����ͱ�
FROM tbl_inout
    LEFT JOIN tbl_product
        ON io_p_code = p_code ; 
        
-- ��¥�� ���Ը��� �հ�
SELECT io_date,
    DECODE(io_inout, '1', '����', '����') AS ����,
    SUM( DECODE(io_inout, '1', io_su * p_iprice, 0 )) AS ���Աݾ�,
    SUM( DECODE(io_inout, '2', io_su * p_Oprice, 0 )) AS ����ݾ�    
FROM tbl_inout
LEFT JOIN tbl_product ON io_p_code = p_code
GROUP BY io_date, DECODE(io_inout,'1','����', '����')


UNION
SELECT '=============', '=', 0, 0 FROM DUAL -- DUMY ���̺�
UNION

SELECT '��ü�հ�', ' ',
    SUM( DECODE(io_inout, '1', io_su * p_iprice, 0)) AS ���Աݾ�,
    SUM( DECODE(io_inout, '2', io_su * p_oprice, 0)) AS ����ݾ�
FROM tbl_inout
LEFT JOIN tbl_product ON io_p_code = p_code ;

-- ������(��)
-- 11������ ����Ŭ���� PK Į���� �����ϴ� AUTO INCREMENT �ɼ�(���)�� ����.
-- �׷��� �� ������� �������� �����ؼ� AUTO INCREMENT ó�� �����ϵ��� �� �� �ִ�.

-- ������ ����
CREATE SEQUENCE myAuto
START WITH 300 -- ���۰�
INCREMENT BY 1 ; -- ������

SELECT myAuto.NEXTVAL FROM DUAL ;

ALTER TABLE tbl_inout DROP COLUMN io_dept ;
ALTER TABLE tbl_inout DROP COLUMN io_pro_name ;

INSERT INTO tbl_inout
(io_id, io_date, io_inout, io_dept_code, io_p_code, io_su)
VALUES
(myAuto.NEXTVAL, '2018-08-30', '1', 'D003','P00007',100) ;

INSERT INTO tbl_inout
(io_id, io_date, io_inout, io_dept_code, io_p_code, io_su)
VALUES
(myAuto.NEXTVAL, '2018-08-30', '2', 'D003','P00008',100) ;

SELECT * FROM tbl_inout
WHERE io_date > '2018-08-30' ;






