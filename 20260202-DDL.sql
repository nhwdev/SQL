/*
		CREATE TABLE 테이블명(
			컬럼명1 자료형1 [제약조건:기본키,AUTO_INCREMENT,DEFAULT],
			컬럼명2 자료형2,
			...
			컬럼명N 자료형N,
			PRIMARY(컬럼1, 컬럼2)
		)
*/
/*
	DEFAULT 제약조건
		값이 없는 경우 기본값으로 설정
*/
CREATE TABLE test5 (
	NO INT PRIMARY KEY,
	NAME VARCHAR(30) DEFAULT "홍길동" -- name의 값이 없으면 홍길동으로 저장
)

DESC test5
SELECT * FROM test5
INSERT INTO test5 (no) VALUES(1); -- 데이터를 추가하는 DML 명령어
SELECT * FROM test5

/*
	AUTO_INCREMENT : 자동으로 1씩 증가.
						  기본키에서만 사용가능
						  오라클 사용 불가 : 시퀀스 객체 이용함
*/
CREATE TABLE test6 (
	NO INT PRIMARY KEY AUTO_INCREMENT,
	NAME VARCHAR(30)
)
SELECT * FROM test6
INSERT INTO test6 (NAME) VALUES('홍길동')
SELECT * FROM test6
INSERT INTO test6 (NAME) VALUES('김삿갓')
SELECT * FROM test6

/*
	기존 테이블을 이용하여 새로운 테이블 생성하기
*/
-- dept 테이블의 모든 컬럼과 모든 레코드를 가진 depttest1 테이블 생성하기
CREATE TABLE depttest1 AS SELECT * FROM dept
SELECT * FROM depttest1
DESC dept
DESC depttest1

-- dept 테이블 중 지역이 서울인 레코드만 depttest2 테이블로 생성하기
CREATE TABLE depttest2 AS SELECT * FROM dept WHERE loc = '서울'
SELECT * FROM depttest2

-- dept 테이블 중 deptno, dname 컬럼만 가지고 있는 depttest3 테이블 생성하기
CREATE TABLE depttest3 AS SELECT deptno, dname FROM dept
SELECT * FROM depttest3

-- dept 테이블 중 deptno, dname 컬럼명 가지고, 레코드가 없는 테이블 depttest4 테이블 생성하기
CREATE TABLE depttest4 AS SELECT deptno, dname FROM dept WHERE 1 = 2
SELECT * FROM depttest4

-- 문제
-- 교수테이블에서 101학과 교수들만 데이터로 가지고 있는 테이블 professor_101 테이블 생성하기
-- 필요한 컬럼 : 교수번호, 교수이름, 학과코드, 직급, 학과명
CREATE TABLE professor_101 
AS
SELECT p.no, p.name, p.deptno, p.position, m.name mname 
FROM professor p, major m 
WHERE p.deptno = m.code 
  AND p.deptno = 101
SELECT * FROM professor_101

-- 2. 학생테이블에서 1학년 학생들만 student_1 테이블로 생성하기
-- 필요한 컬럼: 학번, 이름, 전공1학과, 총점
CREATE TABLE student_1
AS
SELECT s1.studno, s1.name, m.name mname, s2.kor + s2.math + s2.eng totscore
FROM student s1, score s2, major m
WHERE s1.studno = s2.studno AND s1.major1 = m.code AND s1.grade = 1
SELECT * FROM student_1
SHOW TABLES
/*
	alter : 테이블의 구조 수정 명령어
*/
DESC depttest3
-- gdj 데이터베이스의 테이블목록 조회하기
ALTER TABLE depttest3 ADD loc VARCHAR(100)
DESC depttest3

-- 문제. depttest3 int 형 컬럼 part 컬럼 추가하기
ALTER TABLE depttest3 ADD part INT
DESC depttest3

-- part 컬럼의 자료형은 int -> int(2) 크기 변경하기
SELECT * FROM depttest3
ALTER TABLE depttest3 MODIFY part INT(2)
DESC depttest3

-- 문제. depttest3의 loc 컬럼의 크기를 varchar 30자리로 변경하기
ALTER TABLE depttest3 MODIFY loc VARCHAR(30)
DESC depttest3

-- depttest3 테이블에서 part 컬럼을 제거하기
ALTER TABLE depttest3 DROP part
DESC depttest3

-- depttest3 테이블의 loc 컬럼의 이름을 area로 변경하기
ALTER TABLE depttest3 CHANGE loc AREA VARCHAR(100)
DESC depttest3
/*
	컬럼 관련 수정
	컬럼 추가             : ADD [COLUMN] 컬럼명 자료형
	컬럼 자료형 크기 변경 : MODIFY 컬럼명 자료형
	컬럼 제거             : DROP 컬럼명
	컬럼 이름 변경        : CHANGE (기존 컬럼명) (변경 컬럼명) 자료형
	               오라클 : RENAME COLUMN (기존 컬럼명) to (변경 컬럼명)
*/
/*
	제약 조건 변경
*/
-- depttest3 테이블에 deptno 컬럼을 기본키로 설정하기
ALTER TABLE depttest3 ADD CONSTRAINT PRIMARY KEY(deptno)
DESC depttest3

-- 외래키 설정하기
-- 외부 테이블의 컬럼을 외래키로 설정
-- professor 테이블의 deptno를 major 테이블의 code 컬럼을 참조하도록 외래키로 설정하기
ALTER TABLE professor ADD CONSTRAINT FOREIGN KEY (deptno) REFERENCES major(CODE)
DESC professor
DESC major

-- professor_101 테이블에 deptno 컬럼을 major 테이블의 code 컬럼을 참조하도록 외래키 설정하기
ALTER TABLE professor_101 ADD CONSTRAINT FOREIGN KEY (deptno) REFERENCES major(CODE)
DESC professor_101
-- professor_101 테이블에 레코드 추가
INSERT INTO professor_101 (NO, NAME, deptno, POSITION, mname)
 VALUES(9000, '임시직', 300, '임시강사', '임시학과')
SELECT * FROM major
SELECT * FROM professor_101

-- 문제
-- 1. professor_101 테이블의 no 컬럼을 기본키로 설정하기
ALTER TABLE professor_101 ADD CONSTRAINT PRIMARY KEY (NO)
DESC professor_101
-- 2. student 테이블의 major1 컬럼을 major 테이블의 code 값을 참조하는 외래키로 설정하기
ALTER TABLE student ADD CONSTRAINT FOREIGN KEY (major1) REFERENCES major (CODE)
ALTER TABLE student ADD CONSTRAINT FOREIGN KEY (major2) REFERENCES major (CODE)
DESC student
/*
	하나의 테이블에 외래키는 여러개 가능함
	하나의 테이블에 기본키는 한개만 가능함
*/
-- student 테이블에 studno 컬럼이 기본키로 설정됨. jumin 컬럼을 기본키로 설정하기
ALTER TABLE student AS CONSTRAINT PRIMARY KEY (jumin) -- 기본키는 한개만 가능
DESC professor_101

-- 등록된 제약 조건 조회하기
-- HeidiSQL
USE information_schema
SELECT * FROM Table_CONSTRAINTS
WHERE TABLE_NAME = 'professor_101'

-- 외래키 제거하기
USE gdjdb
ALTER TABLE professor_101 DROP FOREIGN KEY professor_101_fk_1
DESC professor_101

-- professor_101 테이블의 기본키 제거하기
ALTER TABLE professor_101 DROP PRIMARY KEY
DESC professor_101

-- test2 테이블 제거하기
DROP TABLE test2
DESC test1
DESC test2

/*
	truncate : 테이블과 데이터를 분리
*/
SELECT * FROM professor_101
TRUNCATE TABLE professor_101
SELECT * FROM professor_101

-- DML DELETE 명렁어와 차이
--     ROLLBACK, COMMIT이 가능
SELECT * FROM test6
-- 현재 상태가 AUTO COMMIT 상태임. 상태변경
SET autocommit=FALSE
DELETE FROM test6     -- test6의 모든 데이터를 제거
SELECT * FROM test6   -- 조회되는 레코드 없음
ROLLBACK				    -- 실행 취소. 이전 COMMIT 까지만 취소
SELECT * FROM test6   -- DELETE 구문이 취소

-- TRUNCATE 명령어 : 전체 데이터를 제거. 레코드 선택 안됨. ROLLBACK 안됨.
--                   데이터 제거 속도가 빠르다. 대용량 데이터
SET autocommit = FALSE
SELECT * FROM test6
TRUNCATE TABLE test6  -- TRUNCATE 명령어는 ROLLBACK 안됨
ROLLBACK
/*
	TRANSACTION(트랜젝션) : 업무단위
									ROLLBACK
									COMMIT 명령어로 단위 결정
		TCL(TRANSACTION CONTROL LANGUAGE) : ROLLBACK(취소), COMMIT(확정)
*/

/*
	DML : DATA MANIPULATION LANGUAGE : 데이터 조작(처리)어
			데이터를 추가, 변경, 삭제, 조회` 언어.
			CRUD : CREATE, READ, UPDATE, DELETE
			C : 데이터 추가.				INSERT
			R : 데이터 검색, 조회 	 SELECT
			U : 데이터 변경, 수정 	 UPDATE
			D : 데이터 삭제, 제거     DELETE
			
			TRANSACTION 처리 가능 : COMMIT, ROLLBACK 가능
*/
-- 현재 상태가 AUTO COMMIT 상태여부 조회
SHOW VARIABLES LIKE 'autocommit%'
-- 현재 상태를 AUTO COMMIT 상태로 변경
SET autocommit = TRUE  -- 현재상태를 AUTO COMMIT 상태로 변경. COMMIT, ROLLBACK 명령처리 안됨
SET autocommit = FALSE -- 현재상태를 AUTO COMMIT 상태가 아닌걸로 변경. COMMIT, ROLLBACK 명령처리 가능


-- student_1 테이블 조회하기
SELECT * FROM student_1
-- 전공학과 1코드가 202번 학생 정보를 제거하기
DELETE FROM student_1 WHERE mname = '기계공학과'
SELECT * FROM student_1
COMMIT

/*
	INSERT : 데이터(레코드) 새로 추가 명령어
	INSERT INTO 테이블명 [(컬럼명1, 컬럼명2, ...)] values (값1, 값2, ...)
	 => 컬럼명의 갯수와 값의 갯수는 동일해야 한다
	 1개의 레코드 추가
	 컬럼명 1 <- 값1
	 컬럼명 2 <- 값2
	 ...
	 
	 - 컬럼명 부분을 구현하지 않으면 스키마에 정의된 모든 컬럼의 순서대로 값을 입력
	 - 컬럼명을 구현해야 하는경우
	 	1. 모든 컬럼의 값을 입력하지 않는 경우
	 	2. 스키마 순서를 모를 때
	 	3. DB 구조가 자주 변경되므로 컬럼명을 기술하는 것이 안전함.
	 한번에 여러개의 레코드 추가
	 	INSERT INTO 테이블명 [(컬럼명1, 컬럼명2, ...)] VALUES
	 								 (값11, 값12, ...),
	 								 (값21, 값22, ...),
									  ...
									 (값n1, n2, ...  )	 		
	 기존의 테이블의 데이터를 이용하여 레코드추가
	 	INSERT INTO 테이블명 [(컬럼명1, 컬럼명2, ...)]
		SELECT 컬럼명1, 컬럼명2, ... FROM 테이블명
		WHERE 조건문				 
*/
SELECT * FROM depttest1
-- depttest1 테이블에 90번 특판팀 추가하기
INSERT INTO depttest1 (deptno, dname) VALUES(90, '특판팀')
ROLLBACK -- INSERT 구문 취소됨

-- depttest1 테이블에 91번 특판1팀 추가하기
INSERT INTO depttest1 VALUES (91, '특판1팀', NULL)
COMMIT 	-- 트랜젝션 종료. 정상처리
ROLLBACK -- 트랜젝션 종료. 취소처리

SELECT * FROM depttest1
-- depttest1 테이블에 70, 총무부 레코드 추가하기 - 컬럼명 생략하기
INSERT INTO depttest1 VALUES (70, '총무부', NULL)
-- depttest1 테이블에 80, 인사부 레코드 추가하기 - 컬럼명 구현하기
INSERT INTO depttest1 (deptno, dname, loc) VALUES (80, '인사부', NULL)

-- 여러개의 레코드를 한번에 추가하기
SELECT * FROM depttest2
/*
 91, 특판1팀
 50, 운용팀, 울산
 70, 총무부, 울산
 80, 인사부, 서울
 데이터를 한번에 INSERT 하기
*/
INSERT INTO depttest2 (deptno, dname, loc) VALUES (91, '특판1팀', NULL),
																  (50, '운용팀', '울산'),
																  (70, '총무부', '서울'),
																  (80, '인사부', '서울')
SELECT * FROM depttest2

/*
	기존의 테이블을 이용하여 데이터 추가하기
*/
SELECT * FROM depttest3
-- depttest3의 모든 데이터를 제거하기
TRUNCATE TABLE depttest3
-- depttest2 테이블의 내용을 depttest3에 저장하기
INSERT INTO depttest3 SELECT * FROM depttest2
SELECT * FROM depttest3

-- professor_101 : 101번 학과에 속한 교수 정보를 저장
SELECT * FROM professor_101
INSERT INTO professor_101 (NO, NAME, deptno, POSITION, mname) 
SELECT p.no, p.name, p.deptno, p.position, m.name 
FROM professor p, major m
WHERE p.deptno = m.code AND p.deptno = 101

-- 문제
-- test3 테이블에 3학년 학생
-- 테이블에 no : 학번, name: 학생이름, birth : 생일정보를 저장
SELECT * FROM test3
INSERT INTO test3 (NO, NAME, birth)
SELECT studno, NAME, birthday
FROM student
WHERE grade = 3

-- 조회되는 컬럼의 갯수와 기술된 컬럼의 갯수는 같아야 한다.
INSERT INTO test3 (NO, NAME, birth)
SELECT studno + 1000, NAME, NOW() FROM student
WHERE grade = 3
DESC student
DESC test3

/*
	UPDATE : 데이터의 내용을 변경 명령어
	
	UPDATE 테이블명 SET 컬럼명1 = 값1, 컬럼명2 = 값2, ...
	WHERE 조건문 => 없는 경우는 모든 레코드의 값이 변경
					 => 있는 경우는 조건문 만족하는 레코드만 값이 변경
*/
-- emp 테이블에서 사원 직급의 보너스를 10만원 인상하기
-- 보너스가 없는 경우는 0으로 처리한다
SELECT * FROM emp WHERE job = '사원'
UPDATE emp SET bonus = bonus + 10
WHERE job = '사원'
ROLLBACK

UPDATE emp SET bonus=IFNULL(bonus, 0) + 10 -- bonus가 NULL인 경우 0으로 치환
WHERE job = '사원'

-- 문제
-- 이상미 교수와 같은 직급의 교수 중 급여가 350미만인 교수의 급여를 10% 인상하기
SELECT * FROM professor 
WHERE POSITION = (SELECT POSITION FROM professor WHERE NAME = '이상미') 
AND salary < 350
UPDATE professor SET salary = salary * 1.1
WHERE POSITION = (SELECT POSITION FROM professor WHERE NAME = '이상미') 
AND salary < 350

ROLLBACK