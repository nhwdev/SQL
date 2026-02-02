/*
	SUBQUERY : SQL 구문 내부에 SELECT 구문이 존재.
				  WHERE 조건문에 사용되는 SELECT 구문
			
			SUBQUERY 가능
				WHERE 조건문 : SUBQUERY
				FROM			 : INLINE VIEW
				컬럼 부분    : SCALAR SUBQUERY
				HVING        : SUBQUERY
				
	단일행 서브쿼리 : 서브쿼리의 결과가 1개 행인 경우.
		  사용연산자 : 관계연산자 (=, >, >=, <, <= ...)
	복수행 서브쿼리 : 서브쿼리의 결과가 여러개 행인 경우.
		  사용연산자 : IN, > ALL, > ANY, ...
*/
-- emp 테이블에서 김민용 직원보다 많은 급여를 받는 직원의 정보를 조회하기
-- 1. 김민용 직원의 급여 조회하기
SELECT salary FROM emp WHERE ename = '김민용'
-- 2. 550보다 많은 급여를 받는 직원의 정보 조회하기
SELECT * FROM emp WHERE salary > 550
-- 1, 2 동시에 가능
SELECT * FROM emp WHERE salary > (SELECT salary FROM emp WHERE ename = '김민용')

-- 문제
-- 김종연 학생보다 고학년의 이름과, 학년, 전공1학과번호, 학과명 출력하기
SELECT s.NAME, s.grade, s.major1, m.name
FROM student s, major m
WHERE s.major1 = m.code 
  AND s.grade > (SELECT grade FROM student WHERE NAME = '김종연')

-- 사원테이블에서 사원직급의 평균급여보다 적게 받는 직원의 사원번호, 이름, 직급, 급여출력하기
SELECT e.empno, e.ename, e.job, e.salary
FROM emp e
WHERE e.salary < (SELECT AVG(salary) FROM emp WHERE job='사원')

-- 사원테이블에서 사원직급의 최대급여보다 적게 받는 직원의 사원번호, 이름, 직급, 급여출력하기
SELECT e.empno, e.ename, e.job, e.salary
FROM emp e
WHERE e.salary < (SELECT MAX(salary) FROM emp WHERE job='사원')

/*
	복수행 서브쿼리 : 서브쿼리의 결과가 여러개 행인 경우
			 IN : OR
			 > ANY : 서브쿼리의 결과 중 한개만 큰 값인 경우
			 < ANY : 서브쿼리의 결과 중 한개만 작은 값인 경우
			 > ALL : 서브쿼리의 결과 모든 값이 큰 값인 경우
			 < ALL : 서브쿼리의 결과 모든 값이 작은 값인 경우
*/
SELECT e.empno, e.ename, e.job, e.salary
FROM emp e
WHERE e.salary < ANY (SELECT salary FROM emp WHERE job='사원') -- ANY : || 한개만 조건 만족
																					-- ALL : && 모든 조건 만족
																					
-- emp, dept 테이블에서 근무지역이 서울인 사원의 사원번호, 이름, 부서코드, 부서명 조회하기
SELECT * FROM dept

SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND e.deptno IN (10, 20, 30, 40)

SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND e.deptno NOT IN (SELECT deptno FROM dept WHERE loc='서울')

-- 문제
-- 1학년 학생과 같은 키를 가지고 있는 2학년 학생의 이름, 키, 학년 조회하기
SELECT NAME, height, grade
FROM student
WHERE grade = 2 AND height IN (SELECT height FROM student WHERE grade= 1)

-- 사원 직급의 최대 급여보다 급여가 높은 직원의 이름, 직급, 급여 조회하기
SELECT ename, job, salary
FROM emp
WHERE salary > (SELECT MAX(salary) FROM emp WHERE job = '사원')

SELECT ename, job, salary
FROM emp
WHERE salary > ALL (SELECT salary FROM emp WHERE job = '사원')

-- 문제
-- major 테이블에서 컴퓨터정보학부에 소속된 학생의 학번, 이름, 학과번호, 학과명 출력하기
SELECT * FROM major

SELECT s.studno, s.name, s.major1, m.name
FROM student s, major m
WHERE s.major1 = m.code 
  AND s.major1 IN (101, 102, 103)

SELECT s.studno, s.name, s.major1, m.name
FROM student s, major m
WHERE s.major1 = m.code 
  AND s.major1 IN (SELECT CODE FROM major WHERE part = (SELECT CODE FROM major WHERE NAME = '컴퓨터정보학부'))

SELECT s.studno, s.name, s.major1, m.name
FROM student s, major m
WHERE s.major1 = m.code
  AND m.part = (SELECT CODE FROM major WHERE NAME = '컴퓨터정보학부')

SELECT s.studno, s.name, s.major1, m1.name
FROM student s, major m1, major m2
WHERE s.major1 = m1.code
  AND m1.part = m2.code
  AND m2.`name` = '컴퓨터정보학부'
/*
	다중 컬럼 서브쿼리 : 비교대상이 되는 컬럼이 2개이상인 경우
*/
-- 학년별로 최대키를 가진 학생의 학번, 이름, 학년, 키 조회하기
-- 최대키 학생정보 아님
SELECT studno, NAME, grade, height, MAX(height)
FROM student
GROUP BY grade

SELECT studno, NAME, grade, height
FROM student
WHERE height IN (SELECT MAX(height) FROM student WHERE grade = 1) AND grade =1
UNION
SELECT studno, NAME, grade, height
FROM student
WHERE height IN (SELECT MAX(height) FROM student WHERE grade = 2) AND grade =2
UNION
SELECT studno, NAME, grade, height
FROM student
WHERE height IN (SELECT MAX(height) FROM student WHERE grade = 3) AND grade =3
UNION
SELECT studno, NAME, grade, height
FROM student
WHERE height IN (SELECT MAX(height) FROM student WHERE grade = 4) AND grade = 4

-- 다중컬럼 서브쿼리로 구현
SELECT studno, NAME, grade, height 
FROM student
WHERE (grade, height) IN (SELECT grade, MAX(height) FROM student GROUP BY grade)

-- 문제
-- emp 테이블에서 직급(job)별 해당직급에서 최대급여를 받는 직원의 정보 조회하기
SELECT DISTINCT job FROM emp

SELECT * FROM emp
WHERE (job, salary) IN (SELECT job, MAX(salary) FROM emp GROUP BY job)

SELECT * FROM emp
WHERE salary = (SELECT MAX(salary) FROM emp WHERE job = '과장')
 AND job = '과장'

-- 문제
-- 학과별 입사일 가장 오래된 교수의 교수번호, 이름, 입사일, 학과코드, 학과명 출력하기
SELECT p.no, p.name, p.hiredate, p.deptno, m.name
FROM professor p, major m
WHERE p.deptno = m.code
  AND (p.deptno, p.hiredate) IN (SELECT deptno, MIN(hiredate) FROM professor GROUP BY deptno)
ORDER BY p.deptno

/*
	상호연관 서브쿼리 : 외부 쿼리의 컬럼이 SUBQUERY에 영향을 주는 쿼리문
							  성능이 안좋다.
*/
-- emp 테이블에서 직원의 직급의 평균급여이상의 급여를 받는 직원의 정보를 조회하기
SELECT * FROM emp
WHERE job = '과장'
AND salary >= (SELECT AVG(salary) FROM emp WHERE job = '과장')

SELECT * FROM emp
WHERE job = '사원'
AND salary >= (SELECT AVG(salary) FROM emp WHERE job = '사원')

SELECT * FROM emp e1
WHERE salary >= (SELECT AVG(salary) FROM emp e2 WHERE e2.job = e1.job)
ORDER BY job

-- 문제
-- 교수테이블에서 교수 본인 직급(position)의 평균급여 이상을 받는 교수의 이름, 직급, 급여 조회하기
SELECT p.name, p.position, p.salary
FROM professor p
WHERE p.salary > (SELECT AVG(salary) FROM professor WHERE position = p.position)

SELECT p.name, p.position, p.salary
FROM professor p
WHERE p.salary > (SELECT AVG(salary) FROM professor WHERE position = '정교수')
UNION
SELECT p.name, p.position, p.salary
FROM professor p
WHERE p.salary > (SELECT AVG(salary) FROM professor WHERE position = '조교수')
UNION
SELECT p.name, p.position, p.salary
FROM professor p
WHERE p.salary > (SELECT AVG(salary) FROM professor WHERE position = '시간강사')

-- emp 테이블에서 사원이름, 직급, 부서코드, 부서명 출력하기
SELECT e.ename, e.job, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno

-- JOIN 없이 SUBQUERY로 구현하기
-- SCALAR SUBQUERY : SELECT 구문에 서브쿼리를 사용. 컬럼부분을 서브쿼리로 사용 가능
SELECT ename, job, deptno, (SELECT dname FROM dept d WHERE d.deptno = e.deptno) dname
FROM emp e

-- FROM 구문에 사용되는 INLINE VIEW SUBQUERY
/*
	Inline view : VIEW는 가상테이블
					  FROM에 구현된 서브쿼리
					  반드시 별명 설정
*/
-- 학년별 평균체중이 가장 적은 학년의 학년과 평균체중 출력하기
SELECT grade, AVG(weight) FROM student GROUP BY grade

SELECT * 
FROM (SELECT grade, AVG(weight) avg FROM student GROUP BY grade) a
WHERE AVG = (SELECT MIN(AVG) FROM (SELECT grade, AVG(weight) avg FROM student GROUP BY grade) a)

-- 오라클에서 사용불가
SELECT grade, MIN(AVG) FROM
(SELECT grade, AVG(weight) AVG FROM student GROUP BY grade ORDER BY 2) a

-- 오라클에서 사용불가
-- LIMIT 0, 1 : 처음부터, 1개의 레코드만 조회
-- LIMIT 0부터 시작하는 행의 인덱스, 갯수 : 처음부터, 1개의 레코드만 조회
SELECT grade, AVG(weight) AVG FROM student GROUP BY grade ORDER BY 2 LIMIT 0, 1
SELECT grade, AVG(weight) AVG FROM student GROUP BY grade ORDER BY 2 LIMIT 1, 1

-- 학년별 평균 몸무게를 구해서, 몸무게가 작은 2개의 학년 정보 조회
SELECT grade, AVG(weight) AVG FROM student GROUP BY grade ORDER BY 2 LIMIT 0, 2

-- 문제
-- 교수테이블에서 부서별 가장 작은 급여평균을 가진 부서와 급여평균 출력
-- 1 : 오라클에서도 가능
SELECT * FROM (SELECT deptno , AVG(salary) avg FROM professor GROUP BY deptno) a
WHERE AVG = (SELECT MIN(AVG) FROM (SELECT deptno , AVG(salary) avg FROM professor GROUP BY deptno) a)

-- 2
SELECT deptno, MIN(AVG)
FROM (SELECT deptno, AVG(salary) AVG FROM professor GROUP BY deptno ORDER BY avg) a
-- 3 LIMIT 예약어는 MariaDB에서만 사용 가능
--   오라클에서는 ROWNUM 예약어를 사용. 사용법이 틀림
SELECT deptno, AVG(salary) AVG FROM professor GROUP BY deptno ORDER BY AVG LIMIT 0, 1
/*
	ROWNUM : 오라클의 예약어
				레코드 조회시 ROWNUM 예약어를 가짐. 레코드의 조회 순서. 정렬전의 순서
				첫번째 레코드만 조회
				SELECT ROWNUM FROM DUAL
				WHERE ROWNUM = 1
				-- ROWNUM 은 첫번째 레코드를 조회해야 2번째 레코드 조회가능
				WHERE ROWNUM BETWEEN 2 AND 5 => 조회불가
				SELECT ROWNUM FROM DUAL
				WHERE ROWNUM BETWEEN 1 AND 5 -> 조회가능
*/
/*
	CREATE : TABLE 생성 명령어
*/
-- 정수형 컬럼 NO, 문자형 컬럼 NAME, 날짜컬럼 BIRTH 컬럼을 가진 test1 테이블 생성하기
CREATE TABLE test1 (
	NO INT,
	NAME VARCHAR(20),
	birth DATETIME
)
DESC test1
/*
	기본키 : PRIMARY KEY. 각각의 레코드를 구분할 수 있는 데이터
				중복X. 유일한 값을 가지고 있는 컬럼 선택. 학번, 교수번호, 사원번호, ...
				NULL 값X. UNIQUE, NOT NULL의 특징을 가짐
*/
-- 정수형컬럼 no, 문자형컬럼 NAME, 날짜컬럼 BIRTH 컬럼을 가진 test2 테이블 생성하기
-- 이때 no 컬럼을 기본키로 설정한다.
CREATE TABLE test2 (
	NO INT PRIMARY KEY, -- 컬럼 한개만 기본키로 설정
	NAME VARCHAR(20),
	birth DATETIME
)
CREATE TABLE test3 (
	NO INT,
	NAME VARCHAR(20),
	birth DATETIME,
	PRIMARY KEY (NO)   -- 컬럼 여러개를 기본키로 설정 가능
)

DESC test2
DESC test3

-- 기본키를 여러개 컬럼으로 설정하기
CREATE TABLE test4 (
	NO INT,
	seq INT,
	NAME VARCHAR(20),
	birth DATETIME,
	PRIMARY KEY (NO, seq)
)
/*
	기본키는 테이블당 한개만 가능함. 한개의 기본키에 여러 컬럼은 가능
	기본키는 중복불가. NOT NULL의 특징을 가짐
*/
/*
	test3 : NO 컬럼이기본키
	no
	 1
	 2
	 3
	 1 => 중복됨. 추가 불가
	 NULL -> 키에 NULL값 불가
	 
	 test4 : NO, seq 컬럼이 기본키. 중복키
	 no  seq
	  1    1
	  1    2
	  2    1
	  2    2
	  1    2 => 중복됨. 추가 불가
	  1    NULL => 키에 NULL값 불가
	  NULL 3 => 키에 NULL 값 불가
	  
	  => 기본키는 테이블당 1개만 가능. 한개의 기본키에 여러개의 컬럼은 가능
	     여러개의 컬럼으로 이루어진 기본키의 중복데이터는 2개 컬럼의 값으로 결정
*/
