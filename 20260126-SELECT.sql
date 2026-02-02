-- desc : 테이블의 구조(스키마) 조회.
-- desc 테이블명

DESC dept -- desc 테이블의 구조 조회

-- SQL : Stuctured Query Language : 관계형 데이터베이스에서 데이터처리를 위한 언어
-- 관계형 데이터베이스 : Oracle, MySql, MSSql, PostgreSql, ...
-- select : 데이터를 조회 하기위한 언어.
-- emp 테이블의 모든 데이터를 조회하기
SELECT * -- 모든 컬럼
FROM emp;
-- emp 테이블의 empno,ename,deptno 컬럼의 모든(행) 데이터 조회하기
SELECT empno,ename,deptno
FROM emp;
/*
	SELECT 컬럼목록 | * -- 2번째 실행
	FROM 테이블이름		-- 1번째 실행
*/

-- 리터널(상수)컬럼 사용하기
-- 학생(student) 테이블의 학생이름 뒤에 학생이라는 문자열 붙여서 출력하기
SELECT s.name, '학생'
FROM student s
SELECT s.name, "학생"
FROM student s

-- 문제 1: 교수테이블(professor)의 구조 조회하기
DESC professor
--      2: 교수테이블(professor)에서 교수번호(no), 교수이름(name), '교수' 문자열 컬럼을 붙여서 출력하기
SELECT NO,NAME, '교수'
FROM professor
-- 문자열형 상수(리터널): 작은 따옴표, 큰따옴표 모두 가능
-- 오라클db 에서는 작은따옴표만 가능함

-- 컬럼의 별명(alias) 설정하기
SELECT NO 교수번호, NAME 교수이름, '교수' FROM professor
SELECT NO "교수 번호", NAME "교수 이름", '교수' FROM professor
SELECT NO '교수 번호', NAME '교수 이름', '교수' FROM professor
SELECT NO AS "교수 번호", NAME AS "교수 이름", '교수' FROM professor
/*
	SELECT 컬럼명 [AS] 별명, 컬럼명 [AS] 별명
	FROM 테이블명
*/

-- 컬럼에 연산자 (+, -, *, /) 사용하기
-- 사원테이플(emp)에서 사원이름(ename), 현재급여(salary), 10% 인상급여 출력하기
SELECT ename, salary, salary * 1.1 '10% 인상급여'
FROM emp

-- distinct : 중복을 제거하여 한개만 조회
--            컬럼처음에 한번만 구현
-- 교수테이블(professor)에서 교수가 속한 부서코드(deptno) 조회하기
SELECT distinct deptno FROM professor

-- 문제 1: 교수테이블(professor)에서 교수가 속한 직급(position) 조회하기
SELECT DISTINCT POSITION FROM professor

-- 교수테이블(professor)에서 부서(deptno)별 교수가 속한 직급(position)을 조회하기
SELECT DISTINCT deptno, DISTINCT POSITION FROM professor -- 오류발생. distinct는 처음 한번만 기술
-- 여러개 컬럼앞에 distinct는 기술된 컬럼의 값들이 중복되지 않도록 조회
SELECT DISTINCT deptno, POSITION FROM professor
/*
	SELECT (distinct) 컬럼명(컬럼, 리터널컬럼, 연산된 컬럼, *, 별명)
	FROM 테이블명
	WHERE 레코드(row, 행) 선택 조건 
		WHERE 조건문X: 모든 레코드 선택
		WHERE 조건문O: 조건문의 결과가 참인 레코드만 선택
*/
-- 학생테이블(student)에서 1학년 학생의 모든 정보 조회하기
SELECT * FROM student
WHERE grade = 1 -- = : 등가연산자. 관계연산자. 자반의 == 와 같은 의미

-- 학생테이블(student)에서 3학년(grade) 학생 중 전공1코드(major1)가 101인 학생의
-- 학번(studno), 이름(name), 학년(gradme), 전공1학과코드(major1) 조회하기
-- 논리연산: and, or
SELECT studno, NAME, grade, major1
FROM student
WHERE grade = 3 AND major1 = 101

-- 문제1: 학생테이블(student)에서 1학년(grade) 학생 이거나 전공1코드(major1)가 101인 학생의
--        학번(studno), 이름(name), 학년(gradme), 전공1학과코드(major1) 조회하기
SELECT studno, NAME, grade, major1
FROM student
WHERE grade = 1 OR major1 = 101
-- 문제2: 사원 테이블(emp)에서 부서코드 10인 사원의 이름(ename), 급여(salary), 부서코드(deptno)를 출력하기
SELECT ename, salary, deptno
FROM emp
WHERE deptno = 10

-- emp 테이블에서 급여가 800보다 큰사람의 이름과 급여를 출력하기
SELECT ename, salary
FROM emp
WHERE salary > 800

-- WHERE 조건문에서 사용되는 연산자
-- emp 테이블에서 모든 사원의 급여를 10%  인상 예정인 경우, 인상 예정 급여가 1000 이상인 사원
-- 이름(ename), 현재급여(salary), 인상 예정 급여, 부서코드(deptno) 조회
SELECT ename, salary, salary * 1.1 AS '인상 예정 급여', deptno
FROM emp
WHERE salary * 1.1 >= 1000

-- BETWEEN 연산자: 범위 지정 연산자
-- WHERE 컬럼명 BETWEEN A and B => 컬럼명의 값이 A이상, B 이하인 레코드를 선택
-- 학생테이블에서 1, 2 학생의 모든 정보 조회하기
SELECT * FROM student
WHERE grade = 1 OR grade = 2

SELECT * FROM student
WHERE grade >= 1 AND grade <= 2

SELECT * FROM student
WHERE grade BETWEEN 1 AND 2

-- 문제1
-- 1학생 중 몸무게(weight)가 70이상 80이하인 학생
-- 이름(name), 학년(grade), 몸무게(weight), 전공1학과(major1) 조회
SELECT NAME, grade, weight AS '몸무게 70 ~ 80', major1
FROM student
WHERE grade = 1 AND weight >= 70 AND weight <= 80

-- BETWEEN 연산자 이용
SELECT NAME, grade, weight AS '몸무게 70 ~ 80', major1
FROM student
WHERE grade = 1 AND weight BETWEEN 70 AND 80

-- 문제2
-- 학생테이블에서 전공1학과가 101번 학생 중 몸무게가 50이상 80이하
-- 학생의 이름(name), 몸무게(weight), 전공1학과(major1) 조회하기
SELECT NAME, weight, major1
FROM student
WHERE major1 = 101 AND weight >= 50 AND weight <= 80

SELECT NAME, weight, major1
FROM student
WHERE major1 = 101 AND weight BETWEEN 50 AND 80

/*
	WHERE 조건문의 연산자: IN
	WHERE 컬럼명 IN (값1, 값2, ...) => 컬럼 = 값1 or 컬럼 = 값2, ...
*/
-- 학생테이블에서 전공1학과가 101, 201인 학과에 속한 학생의 모든 정보를 조회하기
SELECT *
FROM student
WHERE major1 = 101 OR major1 = 201

SELECT *
FROM student
WHERE major1 IN (101, 201)

-- 교수테이블에서 학과코드(deptno)가 101, 201 학과에 속한 교수
-- 교수이름(name), 학과코드(deptno), 입사일(hiredate) 조회하기
SELECT NAME, deptno, hiredate
FROM professor
WHERE deptno = 101 OR deptno = 201

SELECT NAME, deptno, hiredate
FROM professor
WHERE deptno IN (101, 201)

-- 문제
-- 학생테이블에서 101, 201학과(major1)의 학생 중 키가 170 이상인 학생의
-- 학번(studno), 이름(name), 몸무게(weight), 키(height), 학과코드(major1) 조회
SELECT studno, NAME, weight, height, major1
FROM student
WHERE major1 = 101 or major1 = 201 AND height >= 170

SELECT studno, NAME, weight, height, major1
FROM student
WHERE major1 IN (101, 201) AND height >= 170

-- not in 연산자
-- 101, 201 학과에 속한 학생이 아닌 경우, 키가 170이상인 학생
-- 학번(studno), 이름(name), 몸무게(weight), 키(height), 학과코드(major1)를 조회
SELECT studno, NAME, weight, height, major1
FROM student
WHERE major1 NOT IN (101,201) AND height >= 170

/*
	like 연산자: 일부분 일치
		%: 0개이상 임의의 문자
		_: 1개의 임의의 문자
*/
-- 학생 중 성이 김씨인 학생의 학번, 이름, 학과코드1 을 조회하기
SELECT studno, NAME, major1
FROM student
WHERE NAME LIKE '김%'
-- 학생 이름 중 '진'을 가진 학생의 학번, 이름, 학과코드1을 조회하기
SELECT studno, NAME, major1
FROM student
WHERE NAME LIKE '%진%'

-- 학생 중 이름이 2자인 학생의 학번, 이름, 학과코드1을 조회하기
SELECT studno, NAME, major1
FROM student
WHERE NAME LIKE '__'

-- 문제1
-- 학생 중 이름의 끝자가 훈인 학생의 학번, 이름, 전공1코드 조회하기
SELECT studno, NAME, major1
FROM student
WHERE NAME LIKE '%훈'
-- 문제2
-- 학생 중 전화번호(tel)가 서울지역인(02)인 학생의 학번, 이름, 전화번호 조회하기
SELECT studno, NAME, tel
FROM student
WHERE tel LIKE '02%'

-- 교수테이블(professor)에서 id컬럼 값에 k문자를 가진 교수의 이름(name), id(id), 직급(position)을 조회하기
SELECT NAME, id, POSITION FROM professor
WHERE id LIKE '%k%'

SELECT NAME, id, POSITION FROM professor
WHERE id LIKE '%K%'

-- like 구문에서 대소문자 구분이 없음 (오라클에서는 대소문자 구분함)
-- 대소문자구분이 필요한 경우
SELECT NAME, id, POSITION FROM professor
WHERE id LIKE BINARY '%k%'

SELECT NAME, id, POSITION FROM professor
WHERE id LIKE BINARY '%K%'

-- not like 연산자
-- 학생 중 성이 '이'씨가 아닌 학생의 학번, 이름, 전공1코드를 조회하기
SELECT studno, NAME, major1 FROM student
WHERE NAME NOT LIKE '이%'

-- 문제1
-- 학생의 이름 중 성이 김씨가 아닌 학생의 학번, 이름, 학년, 전공1코드 조회하기
SELECT studno, NAME, major1 
FROM student
WHERE NAME NOT LIKE '김%'
-- 문제2
-- 교수테이블에서 101,201 학과에 속한 교수가 아닌 교수 중 성이 김씨가 아닌 교수의 이름, 학과코드, 직급 조회하기
SELECT NAME, deptno, POSITION 
FROM professor
WHERE deptno NOT IN (101,201) AND NAME NOT LIKE '김%'

/*
	null 의미: 값X 연산X
	컬럼 is null    : 컬럼의 값이 null인 경우 
	컬럼 is not null: 컬럼의 값이 null이 아닌 경우 
*/
-- 교수 테이블에서 보너스가 없는 교수의 이름, 급여 보너스를 조회하기
SELECT NAME, salary, bonus FROM professor
WHERE bonus = NULL; -- => null은 연산X

SELECT NAME, salary, bonus FROM professor
WHERE bonus IS NULL

-- 교수테이블에서 보너스가 있는 교수의 이름, 급여, 보너스를 조회하기
SELECT NAME, salary, bonus FROM professor
WHERE bonus IS NOT NULL

-- 학생 중 지도교수(profno)가 있는 학생의 학번(studno), 이름(name), 전공1코드(major1), 지도교수번호(profno)를 조회하기
SELECT studno, NAME, major1, profno
FROM student
WHERE profno IS NOT NULL

-- 교수테이블(professor)에서 교수의 교수번호(no), 교수이름(name), 현재급여(salary), 보너스(bonus), 통상급여(salary + bonus)를 조회하기
SELECT NO, NAME, salary, bonus, salary+bonus FROM professor
-- null 연산의 대상이 안됨. null값과 연산의 결과는 null

-- 교수 중 보너스가 있는 경우, 교수번호, 이름, 현재급여, 보너스, 통상급여 조회하기
SELECT NO, NAME, salary, bonus, salary+bonus FROM professor
WHERE bonus IS NOT NULL

-- 교수 중 보너스가 없는 경우, 교수번호, 이름, 현재급여, 보너스, 통상급여 조회하기
-- 통상급여는 현재급여
SELECT NO, NAME, salary, bonus, salary 통상급여 FROM professor
WHERE bonus IS NULL

-- 문제1
-- 교수 중 보너스가 있는 경우, 교수의 이름, 급여, 보너스, 연봉을 조회하기
-- 연봉 = 급여 * 12 + bonus
SELECT NAME, salary, bonus, salary * 12 + bonus AS '연봉'
FROM professor
WHERE bonus IS NOT NULL
-- 문제2
-- 교수 중 보너스가 없는 경우, 교수의 이름, 급여, 보너스, 연봉을 조회하기
-- 연봉 = 급여 * 12
SELECT NAME, salary, bonus, salary * 12 AS '연봉'
FROM professor
WHERE bonus IS NULL
/*
	정리=================================================           실행 순서
	SELECT (distinct) 컬럼명 (*, 리터널, 별명)                      --3
	FROM 테이블명                                                   --1
	[WHERE 조건문]                                                  --2
			WHERE 조건문이 생략되면 모든 레코드 선택
			WHERE 조건문이 구현되면 조건문의 결과가 참인 레코드 선택
	[ORDER BY 컬럼명|조회된컬럼의순서|별명|asc|desc]                --END. SELECT 구문의 마지막에 구현
	
	OREDER BY: 정렬관련 구문
		오름차순정렬: asc. 작은값부터 큰값 순으로 정렬. 기본정렬방식. asc 생략 가능
		내림차순정렬: desc. 큰값부터 작은값 순으로 정렬. desc 생략 불가능
*/
-- 1학년 학생의 이름, 키가 큰순으로 조회하기
-- 컬럼명으로 정렬하기
SELECT NAME, height
FROM student
WHERE grade = 1
ORDER BY height DESC
-- 조회된 컬럼의 순으로 정렬하기
SELECT NAME, height
FROM student
WHERE grade = 1
ORDER BY 2 DESC
-- 별명 순으로 정렬하기
SELECT NAME AS '이름', height AS '키'
FROM student
WHERE grade = 1
ORDER BY 키 DESC
-- 조회되지 않은 컬럼으로 정렬하기
SELECT NAME, height
FROM student
ORDER BY grade DESC

-- 학생의 이름, 학년, 키조회하기. 학년순, 키가 큰순으로 조회하기
SELECT NAME, grade, height FROM student
ORDER BY grade ASC, height DESC

SELECT NAME, grade, height FROM student
ORDER BY 2 ASC, 3 DESC

SELECT NAME AS '이름', grade '학년', height 키 FROM student
ORDER BY 학년, 키 DESC

-- 컬럼의 순서로 정렬시는 반드시 조회된 컬럼만 가능
-- 컬럼명으로 정렬시는 조회된 컬럼이 아니어도 정렬컬럼으로 사용 가능
-- 별명으로 정렬시 반드시 조회된 컬럼만 가능

-- 문제
-- 1. 교수테이블에서 교수번호, 교수이름, 학과코드, 급여, 예상급여(10%인상) 을 조회하기
--	   단 학과코드 순으로 예상급여의 내림차순으로 정렬하여 출력하기
SELECT NO, NAME, deptno, salary, salary*1.1 AS 예상급여
FROM professor
ORDER BY deptno, salary * 1.1 DESC

SELECT NO, NAME, deptno, salary, salary * 1.1 AS '예상급여'
FROM professor
ORDER BY 3, 5 DESC

SELECT NO, NAME, deptno, salary, salary * 1.1 예상급여
FROM professor
ORDER BY deptno, 예상급여 DESC 
-- 2. 학생테이블에서 지도교수번호(profno)가 배정되지 않은 학생의 학번, 이름, 지도교수번호, 전공1코드 조회하기.
--    단 학과코드 순으로 정렬하여 출력하기
SELECT studno, NAME, profno, major1
FROM student
WHERE profno IS NULL
ORDER BY major1

SELECT studno, NAME, profno, major1
FROM student
WHERE profno IS NULL
ORDER BY 4
-- 3. 1학년 학생의 이름, 키, 몸무게를 출력하기
--    키는 작은순으로 몸무게는 큰순으로 정렬하여 출력하기
SELECT NAME, height, weight
FROM student
WHERE grade = 1
ORDER BY height ASC, weight DESC

SELECT NAME, height, weight
FROM student
WHERE grade = 1
ORDER BY 2, 3 DESC

/*
	합집합: UNION, UNION ALL
	UNION : 합집합. 중복을 제거하여 조회
	UNION ALL : 두개 쿼리구문의 실행 결과를 합하여 출력. 중복 제거 안됨
	
	=> 2개의 SELECT 구문의 조회되는 컬럼의 갯수가 같아야 함.
	=> 별명은 첫번째 SELECT의 별명으로 처리됨.
*/
-- 교수테이블에서 교수이름, 학과코드, 급여, 연봉을 조회하기
-- 보너스가 있는 경우의 연봉: salary * 12 + bonus
-- 보너스가 없는 경우의 연봉: salary * 12
SELECT NAME, deptno, salary, salary * 12 + bonus AS '연봉' FROM professor
WHERE bonus IS NOT NULL
UNION
SELECT NAME, deptno, salary, salary * 12 + bonus FROM professor
WHERE bonus IS NULL

SELECT NAME, deptno, salary, salary * 12 + bonus AS '연봉' FROM professor
WHERE bonus IS NOT NULL
UNION ALL
SELECT NAME, deptno, salary, salary * 12 + bonus 연봉 FROM professor
WHERE bonus IS NULL

-- 학생 테이블에서 전공1학과가 202번 학과이거나, 전공2하곽가 101 학과인 학생
-- 학번, 이름, 전공1, 전공2 조회하기
SELECT studno, NAME, major1, major2
FROM student
WHERE major1 = 202 OR major2 =101

SELECT studno, NAME, major1, major2
FROM student
WHERE major1 = 202
UNION
SELECT studno, NAME, major1, major2
FROM student
WHERE major2 = 101

SELECT studno, NAME, major1, major2
FROM student
WHERE major1 = 202
UNION ALL
SELECT studno, NAME, major1, major2
FROM student
WHERE major2 = 101

-- 2개의 SELECT 구문의 조회되는 컬럼의 갯수는 같아야 함
SELECT studno, NAME, major1
FROM student
WHERE major1 = 202
UNION
SELECT studno, NAME, major2
FROM student
WHERE major2 = 101

-- UNION에서 정렬하기
-- 이름순으로 정렬하기
SELECT NAME, deptno, salary, salary * 12 + bonus 연봉 FROM professor
WHERE bonus IS NOT NULL
UNION
SELECT NAME, deptno, salary, salary * 12 FROM professor
WHERE bonus IS NULL
ORDER BY NAME DESC

-- 문제
-- 1. 교수 중 급여가 450 이상인 경우 5% 인상 예정이고, 450미만인 경우 10% 인상 예정
--    교수번호, 교수이름, 현재급여, 인상예정급여 조회하기
--    인상 예정 급여가 큰순으로 정렬하기
SELECT NO, NAME, salary, salary * 1.1 '인상예정급여'
FROM professor
WHERE salary <= 450
UNION
SELECT NO, NAME, salary, salary * 1.05
FROM professor
WHERE salary > 450
ORDER BY 4 DESC -- ODER BY 인상예정급여 DESC

-- 2. 교수 중 보너스가 있는 교수의 연봉은 급여 * 12 + 보너스 이고,
--    보너스가 없는 교수의 연봉은 급여 * 12 로 한다.
--    교수번호, 교수이름, 급여, 보너스, 연봉을 조회하기
--    단 연봉이 높은 순으로 정렬하기
SELECT NO, NAME, salary, bonus, salary * 12 + bonus AS '연봉'
FROM professor
WHERE bonus IS NOT NULL
UNION
SELECT NO, NAME, salary, bonus, salary * 12
FROM professor
WHERE bonus IS NULL
ORDER BY salary DESC

SELECT NO, NAME, salary, bonus, salary * 12 + bonus AS '연봉'
FROM professor
WHERE bonus IS NOT NULL
UNION
SELECT NO, NAME, salary, bonus, salary * 12
FROM professor
WHERE bonus IS NULL
ORDER BY 5 DESC

SELECT NO, NAME, salary, bonus, salary * 12 + bonus AS '연봉'
FROM professor
WHERE bonus IS NOT NULL
UNION
SELECT NO, NAME, salary, bonus, salary * 12
FROM professor
WHERE bonus IS NULL
ORDER BY 연봉 DESC

/*
	교집합 : INTERSECT
				and 조건 연산자를 이용하는 경우가 많다.
*/
-- 학생 중 성이 김씨인 학생의 경우 이름끝자가 훈인 학생의 이름, 전공1코드 조회하기
SELECT NAME, major1 FROM student
WHERE NAME LIKE '김%' AND NAME LIKE '%훈'

SELECT NAME, major1 FROM student
WHERE NAME LIKE '김%'
INTERSECT
SELECT NAME, major1 FROM student
where NAME LIKE '%훈'

-- 문제
-- 전공1학과가 202번학과고, 전공2학과가 101인 학과인 학생의
-- 학번, 이름, 전공1코드, 전공2코드를 조회하기
SELECT studno, NAME, major1, major2
FROM student
WHERE major1 = 202 AND major2 = 101

SELECT studno, NAME, major1, major2
FROM student
WHERE major1 = 202
INTERSECT
SELECT studno, NAME, major1, major2
FROM student
WHERE major2 = 101

/*
	차집합 : EXCEPT
				첫번째 SELECT 구문의 결과에서 두번째 SELECT 구문의 결과를 뺸 결과
				오라클: MINUS, EXCEPT 모두 가능
*/
-- 전공1학과가 200번인 학생 중 전공2학과가 101번이 아닌 학생의 학번, 이름, 전공1코드, 전공2코드를 조회하기
SELECT studno, NAME, major1, major2
FROM student
WHERE major1 = 202
EXCEPT
SELECT studno, NAME, major1, major2
FROM student
WHERE major2 = 101

/*
	정리==============================================================
	DESC: 테이블 구조 조회
		DESC 테이블명
	SELECT : 테이블의 내용 조회
		SELECT * | 컬럼명
		FROM 테이블명
		[WHERE 조건문]
		[ORDER BY 컬럼명 | 조회컬럼순서 | 별명]
		
	 - 컬럼에서 사용
	    * : 모든 컬럼
	    컬럼명목록: 조회되는 컬럼만 ,로 구분 구현
	    리터널컬럼: 상수값
	    컬럼연산가능: *, +, -, /
	    별명(alias): 컬럼 별명, 특수문자 사용시 "", '' 사용
	    distinct: 중복없이 조회. 컬럼명 앞쪽에 한번만 사용 가능
	 - WHERE 조건문에서 사용
	    관계연산자: =, >, <, >=, <=, !=, <>
	    논리연산자: AND, OR
	    btween A and B : A 이상, B 이하
	    IN (값 1, 값2, ...) : 값1 또는 값2 또는 ...
	    NOT IN (...)
	    LIKE : 부분적으로 일치하는 문자열 찾기
				  % : 0개이상 임의의 문자
				  _ : 1개의 임의의 문자
			BINARY : 대소문자 구분.
		 NOT LIKE
		 
		 IS NULL : NULL 인지 여부 판단.
		 IS NOT NULL
	 - ORDER BY : 정렬 관련 문자
	    컬럼명, 조회된순서, 별명
	    정렬방식: ASC(기본 생략 가능), DESC
	 - 집합관련
	    합집합 : UNION, UNION ALL
		 교집합 : INTERSECT
		 차집합 : EXCEPT (오라클 = MINUS) 
*/