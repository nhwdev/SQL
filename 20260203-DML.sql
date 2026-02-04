/*
DDL : Data Definition Language (데이터 정의어)
        객체의 구조를 생성,수정,제거하는 명령어
      create : 객체 생성 명령어
		   table 생성 : create table  
		   user 생성  : create user
		   index 생성  : create index
		   ....
		alter : 객체 수정 명령어. 컬럼 추가, 컬럼제거, 컬럼크기변경...
		   컬럼 추가 : alter table 테이블명 add 컬럼명 자료형
		   컬럼 크기 변경 : alter table 테이블명 modify 컬럼명 자료형
		   컬럼 이름 변경 : alter table 테이블명 change 원본컬럼명 새로운컬럼명 자료형
		   컬럼 제거 : alter table 테이블명 drop 컬럼명
		   제약조건 추가: alter table 테이블명 add constraint .... 
		   제약조건 제거: alter table 테이블명 drop constraint 제약조건 이름
		   
		제약조건 조회
		  information_schema 데이터베이스 선택
		  table_constraints 테이블 조회하기
		  
		drop : 객체 제거 명령어
		truncate : 테이블과 데이터 분리
		
    DML : Data Manipulation Language : 데이터 처리(조작)어
         데이터의 추가,변경,삭제 언어
      insert : 데이터 추가 - C
		update : 데이터 수정,변경 - U
		delete : 데이터 삭제 - D
		select : 데이터 조회 - R
		
		CRUD : Create,Read,Update,Delete   
	 Transaction 처리 가능 : commit,rollback 가능	
 
   insert : 데이터 추가
        insert into 테이블명 [(컬럼명1,컬럼명2,...)] values (값1,값2,....)
         => 컬럼명의 갯수와  값의 갯수가 동일해야함.
            컬럼명1 <= 값1
            컬럼명2 <= 값2     
            ....

         컬럼명 부분을 구현하지 않으면 스키마에 정의된 순서대로 값을 입력해야함.

     여러개의 레코드를 한번 추가하기
	   insert into 테이블명 [(컬럼명1, 컬럼명2,...)] values 
		                     (값11,값12,....),  
		                     (값21,값22,....),  
                            ...
									(값n1,값n2,...)		                  
     기존의 테이블을 이용하여 데이터 추가하기
	   insert into 테이블명 [(컬럼명1, 컬럼명2,...)] 
	   select 구문

   update : 데이터의 내용을 변경 명령어
      update 테이블명 set 컬럼명1 = 값1, 컬럼명2=값2,...
      where 조건문 => 없는 경우는 모든 레코드의 값이 변경
                   => 있는 경우는 조건문 만족하는 레코드만 값이 변경됨.

*/
-- 보너스가 없는 시간강사의 보너스를 조교수의 평균보너스의 50%로 변경하지
SELECT AVG(bonus) FROM professor WHERE POSITION = '조교수'
SELECT bonus FROM professor WHERE POSITION = '조교수'
SELECT * FROM professor WHERE POSITION = '시간강사' AND bonus IS NULL

-- AUTOCOMMIT 상태 조회
SHOW VARIABLES LIKE 'autocommit%'
-- AUTOCOMMIT 상태를 OFF로 변경하기
SET autocommit = FALSE

UPDATE professor SET bonus=50
WHERE POSITION = '시간강사' AND bonus IS NULL

SELECT * FROM professor WHERE POSITION = '시간강사'
ROLLBACK

-- SUBQUERY를 이용
UPDATE professor SET bonus = (SELECT AVG(bonus) * 0.5 FROM professor WHERE POSITION = '조교수')
WHERE POSITION = '시간강사' AND bonus IS NULL

-- 문제
-- 지도교수가 없는 학생의 지도교수를 이용 학생의 지도교수로 변경하기
UPDATE student SET profno = (SELECT profno FROM student WHERE NAME = '이용')
WHERE profno IS NULL
ROLLBACK

-- 교수 중 김옥남교수와 같은 직급의 교수 급여를 101번학과의 평균 급여로 변경하기
-- 김옥남 교수의 직급
SELECT POSITION FROM professor WHERE NAME = '김옥남'
-- 101번 학과의 평균 급여 조회
SELECT AVG(salary) FROM professor WHERE deptno = 101
-- 시간강사의 급여 조회
SELECT * FROM professor WHERE POSITION = '시간강사'

-- 변경하기
UPDATE professor SET salary = (SELECT AVG(salary) FROM professor WHERE deptno = 101)
WHERE POSITION = (SELECT POSITION FROM professor WHERE NAME = '김옥남')
ROLLBACK

/*
	DELETE : 레코드 삭제
		DELETE FROM 테이블명
		WHERE 조건문 => 없으면 모든 레코드 삭제됨
						 => 있으면 조건문의 결과가 참인 레코드만 삭제됨
*/
SELECT* FROM depttest1
-- depttest1의 모든 레코드를 제거하기
DELETE FROM depttest1

SELECT * FROM depttest2
-- depttest2 테이블에서 총무부와 인사부를 삭제하기
SELECT * FROM depttest2 WHERE dname IN ('총무부', '인사부')
DELETE FROM depttest2 WHERE dname IN ('총무부', '인사부')
ROLLBACK

-- 문제
-- depttest2 테이블에서 부서명에 '기' 문자가 있는 부서 삭제하기
SELECT * FROM depttest2 WHERE dname LIKE '%기%'
DELETE FROM depttest2 WHERE dname LIKE '%기%'
ROLLBACK

-- depttest1의 모든 레코드를 제거하기(TRUNCATE 이용)
/*
	DML을 사용 후 DDL 명령어 실행시 AUTOCOMMIT 됨
	DML 사용 후 DDL 명령어 실행시 TRANSACTION을 종료해야함 (COMMIT, ROLLBACK)
*/
TRUNCATE TABLE depttest1 -- DDL 명령어 사용
SELECT * FROM depttest1
ROLLBACK

/*
	VIEW : 가상테이블
			 물리적으로 테이블을 저장하지 않음.
			 테이블처럼 JOIN, SUQBQUERY 가능함
	
	CREATE OR REPLACE VIEW 뷰이름
	AS
	SELECT 구문			 
*/

-- 2학년 학생의 학번, 이름, 키, 몸무게를 가진 뷰 v_stu2 생성하기
CREATE OR REPLACE VIEW v_stu2
AS SELECT studno, NAME, height, weight FROM student WHERE grade = 2

SELECT * FROM v_stu2

-- 972001 학번의 홍길동, 학년: 2, 키: 160, 몸무게: 60, id: hongkd 레코드 추가하기
INSERT INTO student (studno, NAME, grade, height, weight, id, jumin) 
		 VALUES(972001, '홍길동', 2, 160, 60, 'hongkd', 9712301234567)
SELECT * FROM student WHERE grade = 2

-- 2학년 학생의 학번, 이름, 국어, 영어, 수학 컬럼을 가지는 v_score2 VIEW 생성하기
CREATE OR REPLACE VIEW v_score2 AS 
SELECT s1.studno, s1.name, s2.kor, s2.eng, s2.math 
FROM student s1 LEFT OUTER JOIN score s2 
ON s1.studno = s2.studno
WHERE s1.grade = 2

SELECT * FROM v_score2

-- v_stu2, v_score2 뷰를 이용하여 학번, 이름, 총점, 키, 몸무게 출력하기
SELECT s1.studno, s1.name, s2.kor+s2.eng+s2.math 총점, s1.height, s1.weight
FROM v_stu2 s1 JOIN v_score2 s2
  ON s1.studno = s2.studno
WHERE s2.kor+s2.eng+s2.math IS NOT NULL

-- v_score2 뷰와 student 테이블을 이용하여 학번, 이름, 점수들, 학년, 지도교수번호 출력하기
SELECT s1.studno, s1.name, s2.kor, s2.eng, s2.math, s1.grade, s1.profno
FROM student s1, v_score2 s2
WHERE s1.studno = s2.studno 
  AND s1.profno IS NOT NULL
  
-- 2학년 학생의 학번, 이름, 점수들, 학년, 지도교수번호, 지도교수이름 출력하기
-- MariaDB
SELECT s1.studno, s1.name, s2.kor+s2.math+s2.eng 총점, s1.grade, s1.profno, p.name 
FROM student s1, score s2, professor p
WHERE s1.studno = s2.studno AND s1.profno = p.no
-- ANSI
SELECT s1.studno, s1.name, s2.kor + s2.math + s2.eng 총점, s1.grade, s1.profno, p.name
FROM student s1 JOIN score s2 ON s1.studno = s2.studno 
					 JOIN professor p ON s1.profno = p.no
					 
-- VIEW 객체 조회하기
USE information_schema
SELECT view_definition FROM views
WHERE TABLE_NAME = 'v_stu2'

select `gdjdb`.`student`.`studno` AS 
		 `studno`,`gdjdb`.`student`.`name` AS 
		 `NAME`,`gdjdb`.`student`.`height` AS 
		 `height`,`gdjdb`.`student`.`weight` AS 
		 `weight` 
from `gdjdb`.`student` 
where `gdjdb`.`student`.`grade` = 2

-- 뷰제거
-- v_stu2 뷰 제거하기
USE gdjdb
DROP VIEW v_stu2
SELECT * FROM v_stu2

/*
	INLINE 뷰 : 뷰의 이름이 없고, 일회성으로 사용되는 뷰
					SELECT 구문의 FROM 절에 사용되는 SUBQUERY
					반드시 별명 작성을 해야함
*/
-- 학생의 학번, 이름, 학년, 키, 몸무게, 본인학년의 평균키, 본인학년의 평균몸무게 출력하기
-- 상호연관 SUBQUERY 사용
SELECT studno, NAME, grade, height, weight,
		 (SELECT AVG(height) FROM student s2 WHERE s2.grade = s1.grade) 평균,
		 (SELECT AVG(weight) FROM student s2 WHERE s2.grade = s1.grade) 평균몸무게
FROM student s1

-- INLINE VIEW로 조인하여 출력
SELECT studno, NAME, s.grade, height, weight, a.avgheight 평균키, a.avgweight 평균몸무게
FROM student s, (SELECT grade, AVG(height) avgheight, AVG(weight) avgweight FROM student GROUP BY grade) a
WHERE s.grade = a.grade

-- 사원 테이블에서 사원번호, 사원명, 직급, 부서코드, 부서명, 부서명 평균 급여, 부서별 평균 보너스 출력하기
-- 보너스가 없으면 0 으로 처리한다.
SELECT e.empno 사원번호, e.ename 사원명, e.job 직급, e.deptno 부서코드, d.dname 부서명, a.avgsalary 평균급여, a.avgbonus 평균보너스
FROM emp e, dept d, 
	  (SELECT deptno, AVG(salary) avgsalary, AVG(IFNULL(bonus, 0)) avgbonus FROM emp GROUP BY deptno) a
WHERE e.deptno = a.deptno
  AND e.deptno = d.deptno
ORDER BY e.deptno

ROLLBACK
-- SELECT 구문 분석하기
EXPLAIN SELECT studno, NAME, grade, height, weight,
		 (SELECT AVG(height) FROM student s2 WHERE s2.grade = s1.grade) 평균,
		 (SELECT AVG(weight) FROM student s2 WHERE s2.grade = s1.grade) 평균몸무게
FROM student s1
/*
	type: ALL => 전체 레코드 순회함. 성능이 제일 안좋음
*/
EXPLAIN SELECT studno, NAME, s.grade, height, weight, a.avgheight 평균키, a.avgweight 평균몸무게
FROM student s, (SELECT grade, AVG(height) avgheight, AVG(weight) avgweight FROM student GROUP BY grade) a
WHERE s.grade = a.grade

ROLLBACK
/*
	INDEX 테이블
		테이블을 조회하기 위한 색인 테이블
		INDEX 테이블에 설정된 컬럼명으로 조회시 성능 ↑
		INDEX 테이블에 설정된 컬럼이 변경이 되는 경우는 성능 ↓
*/
-- student 테이블의 grade 컬럼으로 인덱스 테이블 생성하기
CREATE INDEX idx_stu_grade ON student(grade)     -- 중복 가능한 인덱스 (비 고유 인덱스 : Non Unique 인덱스)
CREATE UNIQUE INDEX idx_stu_grade ON student(id) -- 중복 불가능한 인덱스(고유 인덱스 : Unique 인덱스)

-- INDEX 제거하기
DROP INDEX idx_stu_grade ON student

/*
	환경 설정 : 사용자, 데이터베이스 생성
*/
-- 데이터베이스 생성
CREATE DATABASE classdb
-- 데이터 베이스 삭제
DROP DATABASE classdb
-- 데이터베이스 목록 조회
SHOW DATABASE
-- 테이블 목록 조회
-- 데이터베이스 선택
USE gdjdb
SHOW TABLES
USE classdb
SHOW TABLES

-- 사용자 생성하기
CREATE USER nhw
CREATE TABLE test1 (NO INT)

-- 비밀번호 설정하기
SET PASSWORD FOR 'nhw' = PASSWORD('4986')

-- 권한주기
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, CREATE VIEW ON gdjdb.* TO 'nhw'@'%'
SELECT * FROM student

-- 권한 조회
USE information_schema
SELECT * FROM user_privileges WHERE grantee LIKE '%nhw%'
USE gdjdb

-- 권한 회수 하기
REVOKE ALL PRIVILEGES ON gdjdb.* FROM nhw@'%'

/*
	DDL : 데이터 정의어 (Data Definition Language)
			CREATE, ALTER, DROP, TRUNCATE
			트랜젝션 처리 안됨
			객체(DATABASE, TABLE, VIEW, INDEX, USER)를 생성, 수정, 삭제기능
			
	DML : 데이터 조작(처리)어 (Data Manipulation Language)
			INSERT, SELECT, UPDATE, DELETE
			TRANSACTION 처리 가능(ROLLBACK, COMMIT)
	
	DCL : 데이터 제어어 (Data Control Language) => 관리자의 언어
		   GRANT  : 권한 부여
		   REVOKE : 권한 회수
		   
	TCL : TRANSACTION 제어어 (Transaction Control Language)
			COMMIT   : 정상 처리
			ROLLBACK : 취소 처리
*/

-- nhw 사용자 제거하기
DROP USER nhw

-- 등록된 사용자 조회
SELECT user, HOST FROM mysql.user;

SELECT * FROM professor GROUP BY deptno
DESC professor
