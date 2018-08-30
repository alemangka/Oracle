-- 주석을 표시할 때는 마이너스 2개로 시작

-- DB Language들의 분류
-- CREATE로 시작되는 명령들은 DBA(SYSDBA)가 사용하는 DDL(Database Definition Lang)이다.
--      DROP으로 시작되는 명령들은 DBA가 사용하는 DDL이며, 매우 위험한 명령이다.
-- SELECT, UPDATE, INSERT, DELETE 명령은 DBA나 DataUser가 사용하는 DML(Data Management Lang)이다.
-- GRANT, REVOKE 명령은 DBA 등이 사용하는데 DCL(Data Controll Lang)이다.

-- SQL Developer 사용법
-- 이 화면은 sys로 접속한 화면
-- sys(SYSDBA 권한) 사용자는
-- 새로운 저장소, 새로운 사용자, 새로운 DB 등을 만들 수 있고, 삭제하는 권한을 갖는다.

-- 현재 접속된 사용자가 누구?
SHOW user ;

-- 현재 시스템에 등록된 사용자를 모두 보여라.
SELECT *
FROM all_users
WHERE username = 'HR' ;

-- 1. 새로운 저장소 생성
--      오라클에서는 새로운 DataBase를 생성하기 전에 새로운 저장소를 만드는 것을 권장한다.
--      물론, 새로운 저장소를 만들지 않고, DataBase를 생성해도 되지만
--      새로운 저장소가 없이 DataBase를 만들게 되면, 오라클 DataBase Server에 부담이 된다.
-- 오라클의 "저장소"는 "TableSpace"라고 한다.
-- 가. 사용자가 임의로 저장 폴더를 지정할 수 있고, 초기 크기를 지정할 수 있다.
CREATE TABLESPACE myts -- 내가 사용할 tablespace 이름
DATAFILE 'd:\oData\myts.dbf' -- 실제 저장된 파일
SIZE 100M -- 최초에 저장공간을 100MB 만큼 확보하라
AUTOEXTEND -- 사용중에 용량이 부족하면 자동으로 크기를 늘려라
ON NEXT 100K ; -- 이때, 100KB 단위씩 늘려라

-- TABLESPACE 삭제
-- 매우 조심해서 사용할 것!!!
DROP TABLESPACE myts
INCLUDING CONTENTS AND DATAFILES
CASCADE CONSTRAINTS ;

-- 2. 새로운 사용자 등록
CREATE USER test1 IDENTIFIED BY 1234 ;

SELECT *
FROM all_users ;

-- 사용자 삭제
DROP USER test1 CASCADE ; -- 사용자를 삭제하고 관련된 정보도 삭제하라.

CREATE USER user1 IDENTIFIED BY 1234 ;
-- 새로운 사용자 등록 직후에는
-- 그 사용자에게는 아무런 권한이 없다.(GUEST)
-- 오라클에서는 새로운 사용자 등록 후 최소한의 권한을 부여 해야한다.

-- 최소한의 권한(DB에 접속할 수 있는 권한)
GRANT CREATE SESSION TO user1 ;

-- Data 읽기 권한
-- 모든 테이블을 읽을 수 있는 권한
GRANT SELECT ANY TABLE TO user1 ; -- 권한 주기
REVOKE SELECT ANY TABLE FROM user1 ; -- 권한 뺏기

-- 읽기 권한의 원칙
-- [table]만 읽을 수 있는 권한
GRANT SELECT ON [table] TO user1 ;

-- 시스템 권한
GRANT DBA TO user1 ;
-- sysDBA보다 한단계 낮은 DBA의 권한을 부여하는 것
-- CREATE의 상당부분, CRUD의 모든 명령, DCL 명령 등을 수행할 수 있는 권한
