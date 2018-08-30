-- 이미 기존에 업무를 처리하면서 사용하고 있는
-- 매입매출장부 엑셀 파일이 있는데
-- 이 파일에 있는 매입매출장을 오라클 Database로 옮기기

-- 실무상에서 사용하는 DataBase의 Table 분류
-- 1. master table
--  가. 기본적인 정보를 담고 있는 table
--  나. 실제 data가 입력되고, 조회되는 table에 대해 정보를 제공하는 table
--  다. 거래처 정보를 보관할 table, 상품정보를 보관할 table

-- 2. work table
--  가. 수시로 데이터가 insert, update, delete가 되어서 어떤 일의 흐름을 파악할 수 있는 table
--  나 . 매입매출을 기록하는 table

CREATE TABLE tbl_inout(
    io_id	NUMBER	NOT NULL	PRIMARY KEY,	
    io_date	CHAR(10)	NOT NULL,		
    io_dept	VARCHAR2(20)	NOT NULL,		
    io_inout	CHAR(1)	NOT NULL,   -- 1:매입, 2:매출
    io_pro_name	VARCHAR2(20)	NOT NULL,		
    io_pro_qty	VARCHAR2(10),			
    io_vat_check	CHAR(1),	    -- 1:과세, 2: 면세
    io_su	NUMBER,			
    Io_dan	NUMBER,			
    io_sub_total	NUMBER,		    -- 단가 * 수량
    io_vat	NUMBER,		            -- 과세이면 금액/10
    io_total	NUMBER	            -- 금액 * 세액
);

DESC tbl_inout ;

-- 전체 데이터 확인
SELECT * FROM tbl_inout;

-- 전체 데이터 개수 확인
SELECT COUNT(*) FROM tbl_inout ;

DELETE tbl_inout ;

-- 구분자로 개수 확인
SELECT COUNT(*)
FROM tbl_inout
GROUP BY io_inout ;

-- 데이터 가져오기 완료

-- master 테이블과 worktable을 분리
-- 정규화 과정
-- 매입매출테이블(tbl_inout)으로부터 거래처정보와 상품정보를 분리

-- 1. 거래처정보 master table 생성
--  가. 매입매출 테이블로부터 거래처 정보만 추출
SELECT *
FROM tbl_inout
GROUP BY io_dept ;
-- GROUP BY를 실행할 때는 SELECT에 나열된 칼럼(PROJECT 칼럼)이 모두 GROUP BY 항목에 나열되어야 한다.
-- 즉, GROUP BY를 실행할 때는 SELECT * 는 안된다.

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
-- 나. 거래처 master table을 생성 완료

-- 다. 매입매출장과 거래처 master를 연결하도록 설정

-- 현재 만들어진 매입매출장과 거래처정보로 JOIN을 해서
-- 정보를 보기

-- 2011년 01월 24일 매입자료만 확인
SELECT *
FROM tbl_inout
WHERE io_inout = '1' AND
io_date = '2011-01-24' ;

-- 문자형(고정길이) 칼럼일 경우
-- BETWEEN을 사용해서 구간별 검색이 가능하다.
-- 그래서, 날짜가 저장될 칼럼을 문자형으로 만들고
-- 날짜를 문자로 변환 후 INSERT 해두면
-- 굳이 Date형으로 지정하지 않아도 된다.

-- DB에서 칼럼을 Date, DateTime 형으로 지정하면
-- 다른 프로그램 언어에서 DB에 접근하여 데이터를 INSERT, SELECT 할때
-- Data Type 때문에 여러가지 문제들이 나타난다.
SELECT *
FROM tbl_inout
WHERE io_date BETWEEN '2011-01-01' AND '2011-05-31' ;

SELECT io_date, io_inout, io_dept, d_code, d_name, d_ceo
FROM tbl_inout
LEFT JOIN tbl_dept
    ON tbl_inout.io_dept = tbl_dept.d_name
WHERE io_inout = '1' AND
io_date = '2011-01-24' ;
-- 위의 방법은 매입매출장과 거래처정보의 연결이 잘 될 수있는지 확인하는 절차
-- 실제환경에서는 d_name으로 조인하는 형식은 사용하지 않는다.
-- 매입매출장에 거래처코드 칼럼을 만들고, 거래처명을 기준으로 거래처코드를
-- UPDATE 할 예정

-- 매입매출장에 거래처코드 칼럼을 추가
ALTER TABLE tbl_inout ADD(io_dept_code CHAR(4)) ;

-- 생성된 거래처코드 칼럼에 거래처 코드를 UPDATE한다.
-- 거래처명을 거래처정보에서 검색하고, 검색된 코드를 UPDATE해야한다.
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

-- 거래처 정보에서 코드가 D002인 회사의 전화번호를
-- 010-111-2222 로 바꾸고 싶다.
UPDATE tbl_dept
SET d_tel = '010-111-2222'
WHERE d_code = 'D002' ;

-- 2. 상품정보 master 생성
--  가. 매입매출 테이블에서 상품명만 추출
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

-- 매입매출장과 상품정보를 JOIN해서 확인
SELECT io_pro_name, p_name
FROM tbl_inout
    LEFT JOIN tbl_product
    ON io_pro_name = p_name
    WHERE p_code = 'P00004' ;
    
ALTER TABLE tbl_inout ADD(io_p_code CHAR(6)) ;

-- 매입매출장의 상품코드 UPDATE
UPDATE tbl_inout
SET io_p_code =
(
    SELECT p_code
    FROM tbl_product
        WHERE p_name = io_pro_name
);

-- JOIN 후 확인
SELECT io_p_code, p_code, io_pro_name, p_name
FROM tbl_inout
    LEFT JOIN tbl_product
        ON io_p_code = p_code ;
        
-- 매입매출장과 상품정보를 JOIN 매입매출 금액 계산
SELECT io_date,
    DECODE(io_inout, '1', '매입', '매출' ) AS 구분,
    io_p_code, p_name, io_su, p_iprice, p_oprice,
    DECODE(io_inout, '1', io_su * p_iprice, 0) AS 매입금액,
    DECODE(io_inout, '2', io_su * p_oprice, 0) AS 매출금액
FROM tbl_inout
    LEFT JOIN tbl_product
        ON io_p_code = p_code ;

-- 현재 등록된 매입매출장의 총 매입금액과, 총 매출금액 그리고 마진 계산
-- 통계함수 이용
SELECT
    SUM( DECODE(io_inout, '1', io_su * p_iprice, 0)) AS 매입금액,
    SUM( DECODE(io_inout, '2', io_su * p_oprice, 0)) AS 매출금액,
    
    SUM( DECODE(io_inout, '2', io_su * p_oprice, 0)) -
    SUM( DECODE(io_inout, '1', io_su * p_iprice, 0)) AS 총이익금
FROM tbl_inout
    LEFT JOIN tbl_product
        ON io_p_code = p_code ; 
        
-- 날짜별 매입매출 합계
SELECT io_date,
    DECODE(io_inout, '1', '매입', '매출') AS 구분,
    SUM( DECODE(io_inout, '1', io_su * p_iprice, 0 )) AS 매입금액,
    SUM( DECODE(io_inout, '2', io_su * p_Oprice, 0 )) AS 매출금액    
FROM tbl_inout
LEFT JOIN tbl_product ON io_p_code = p_code
GROUP BY io_date, DECODE(io_inout,'1','매입', '매출')


UNION
SELECT '=============', '=', 0, 0 FROM DUAL -- DUMY 테이블
UNION

SELECT '전체합계', ' ',
    SUM( DECODE(io_inout, '1', io_su * p_iprice, 0)) AS 매입금액,
    SUM( DECODE(io_inout, '2', io_su * p_oprice, 0)) AS 매출금액
FROM tbl_inout
LEFT JOIN tbl_product ON io_p_code = p_code ;

-- 시퀀서(스)
-- 11까지의 오라클에는 PK 칼럼에 지정하는 AUTO INCREMENT 옵션(기능)이 없다.
-- 그래서 그 대안으로 시퀀서를 응용해서 AUTO INCREMENT 처럼 동작하도록 할 수 있다.

-- 시퀀서 생성
CREATE SEQUENCE myAuto
START WITH 300 -- 시작값
INCREMENT BY 1 ; -- 증가값

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






