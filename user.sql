-- 1.  자신이 사용할 TABLESPACE를 먼저 생성
CREATE TABLESPACE userTS
DATAFILE 'd:\oData\userts.dbf'
SIZE 100M AUTOEXTEND ON NEXT 100K ;

-- 2. DEFAULT로 지정
ALTER USER user1 DEFAULT TABLESPACE userTS ;

-- 3. TABLE 생성
CREATE TABLE test (
    ID NUMBER, -- 최대 40자리까지 숫자 저장
    NAME VARCHAR2(20),
    POSTCODE CHAR(5),
    ADDR VARCHAR2(50),
    TEL VARCHAR2(15),
    GRADE NUMBER(5,2) -- 전체 자릿수 5개, 소수점이하 2자리
);

-- 테이블 구조 확인
DESC test ;

-- 테이블 삭제
DROP TABLE test ;

-- 데이터 추가
INSERT INTO test (name, addr, tel) VALUES('홍길동','서울시','02') ;
-- 필요한 칼럼만 지정해서 추가

INSERT INTO test
VALUES(1, '이몽룡', '61182', '남원', '042', 90) ;
-- 전체 칼럼에 추가

-- 데이터 확인
SELECT * FROM test ;

-- DCL(Data Controll Lang)
COMMIT ;

-- 데이터 삭제
DELETE FROM test ;
ROLLBACK ;
SELECT * FROM test ;

INSERT INTO test
VALUES(2, '이몽룡', '61182', '남원', '042', 90) ;

INSERT INTO test
VALUES(3, '성춘향', '61182', '남원', '042', 90) ;

COMMIT ; -- INSERT, UPDATE, DELETE를 수행한 결과를 실제 DB에 반영


INSERT INTO test
VALUES(2, '이몽룡', '61182', '남원', '042', 90) ;
INSERT INTO test
VALUES(3, '성춘향', '61182', '남원', '042', 90) ;

ROLLBACK ;

SELECT * FROM test ;

DELETE FROM test ;

SET AUTOCOMMIT OFF ;

-- ROLLBACK은 순간적인 실수로 UPDATE, DELETE를 수행했을 때
-- 이전 상태로 되돌리는 명령
-- ROLLBACK이 안되는 경우
-- COMMIT을 수행해 버렸을 때, DDL 명령을 수행했을 때
-- TRUNCATE 명령 = DELETE 명령과 유사
-- TRUNCATE 명령을 수행한 후에는 ROLLBACK으로 되돌릴 수 없다.
-- TABLE 관련해서 전체 데이터를 삭제하는 명령 3가지
-- 1. DELETE FROM [table]을 WHERE 없이 실행한 경우
-- 2. DROP TABLE >> 아예 TABLE 자체를 삭제
-- 3. TRUNCATE TABLE >> TABLE을 삭제 했다가 다시 CREATE
--      DROP TABLE + CREATE TABLE

-- 현재 시스템시간으로부터 5분전으로 복구
CREATE TABLE test_bak AS
SELECT * FROM test AS OF TIMESTAMP(SYSTIMESTAMP - INTERVAL '5'MINUTE) ;

-- 1시간 전
SELECT * FROM test AS OF TIMESTAMP(SYSTIMESTAMP - INTERVAL '1'HOUR) ;





