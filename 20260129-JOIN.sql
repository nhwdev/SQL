/*
   단일행 함수
    기타함수
    - 조건함수 : if, case
	      if(조건문,참,거짓) : 중첩가능
	                         오라클 : decode(조건문,참,거짓)
	      case 컬럼명 when 값 then 출력값 ...
			     [else 값] end
	      case when 조건문 then 출력값 ...
			     [else 값] end
   
	그룹함수 : 여러개의 레코드에서 정보 얻어 리턴			     
	group by : 그룹함수 사용시, 그룹화 되는 기준의 컬럼. 
	           group by에서 사용된 컬럼을 select  구문에서 조회해야 함.
	having 조건문 : 그룹함수의 조건문           
	
	  건수 : count(*) => 조회된 레코드의 건수
	         count(컬럼명) => 컬럼의 값이 null이 아닌 레코드의 건수
	  합계 : sum(컬럼명)
	  평균 : avg(컬럼명) => 컬럼의 값이 null이 아닌 경우만 평균의 대상이됨.
	                        ifnull 함수 이용 전체 평균으로 처리
	  가장큰값,작은값 : max(컬럼),min(컬럼)
	  표준편차,분산 : stddev(컬럼),variance(컬럼명)
	
	순위,누계 지정함수
	  - rank() over(정렬방식)
	  - sum(컬럼) over(정렬방식)                        
	
	rollup : 부분결과 출력. 2개의 그룹의 값을 처리할때 앞쪽 그룹컬럼의 부분의 결과도 출력 
	cube   : 부분결과 출력 => mariadb 에서는 불가능
	
	select 구문 구조

5.	select 컬럼명 || * || 상수값 || 연산 || 단일행함수
1.	from 테이블명
2.	where 조건문 => 레코드의 선택
3.	group by => 그룹화의 기준이 되는 컬럼
4.	having 조건문 => 그룹함수 조건문
6.	order by 컬럼명 || 별명 || 조회되는 컬럼의 순서
	
	join : 여러개의 테이블을 연결하여 조회함
	   join된 테이블의 전체 컬럼의 갯수 : 연결된 테이블의  컬럼의 수를 더한 갯수
	   2개테이블의 컬럼이 같은 경우는 테이블명.컬럼명으로 작성함.
	   => 테이블의 별명(alias)를 주어 모든 컬럼은 별명.테이블명으로 작성하는것을 권장함
	   
	   cross join : 두개의 테이블을 연결만함.
	         레코드의 갯수가 : n * m 개의 갯수가 생성됨. 사용시 주의 요망
	   등가조인(equi join) 
		   join 컬럼의 조건이 = 인 조인을 말함. 가장 많이 사용되는 join      
*/

-- 학생테이블과 학과테이블(major)을 사용하여 학생이름, 전공학과번호, 전공학과명 출력하기
-- MariaDB
SELECT s.name, s.major1, m.name
FROM student s, major m
WHERE s.major1 = m.code

SELECT *
FROM student s, major m
WHERE s.major1 = m.code

-- ANSI 방식
SELECT s.name, s.major1, m.name
FROM student s JOIN major m
ON s.major1 = m.code

SELECT *
FROM student s JOIN major m
ON s.major1 = m.code

-- 문제
-- 1. 학생의 이름, 지도교수번호, 지도교수이름 출력하기
-- MariaDB 방식
SELECT s.NAME 이름, s.profno 지도교수번호, p.name 지도교수이름
FROM student s, professor p
WHERE s.profno = p.no
-- ANSI 방식
SELECT s.NAME 이름, s.profno 지도교수번호, p.name 지도교수이름
FROM student s JOIN professor p
ON s.profno = p.no
-- 2. 학생의 학번, 이름, 국어, 수학, 영어, 총점을 출력하기
--    총점의 내림차순으로 정렬하기
-- MariaDB 방식
SELECT s.studno 학번, s.name 이름, c.kor 국어, c.math 수학, c.eng 영어, c.kor+c.math+c.eng 총점
FROM student s, score c
WHERE s.studno = c.studno
ORDER BY 총점 DESC
-- ANSI 방식
SELECT s.studno 학번, s.name 이름, c.kor 국어, c.math 수학, c.eng 영어, c.kor+c.math+c.eng 총점
FROM student s JOIN score c
ON s.studno = c.studno
ORDER BY 총점 DESC

-- 학생의 이름, 학과이름, 지도교수 이름 출력하기
-- MariaDB 방식
SELECT s.name, m.name, p.name
FROM student s, major m, professor p
WHERE s.major1 = m.code AND s.profno = p.no
-- ANSI 방식
SELECT s.name, m.name, p.name
FROM student s JOIN major m
ON s.major1 = m.code JOIN professor p
ON s.profno = p.no

SELECT * FROM p_grade
-- 사원의 이름, 직급(job), 현재연봉, 해당직급의 연봉하한, 연봉상한 출력하기
-- 현재연봉 : (급여 * 12 + 보너스) * 10000 으로 한다.
-- MariaDB 방식
SELECT e.ename, e.job, (e.salary * 12 + IFNULL(e.bonus, 0)) * 10000 현재연봉, p.s_pay, p.e_pay
FROM emp e, p_grade p
WHERE e.job = p.position
-- ANSI 방식
SELECT e.ename, e.job, (e.salary * 12 + IFNULL(e.bonus, 0)) * 10000 현재연봉, p.s_pay, p.e_pay
FROM emp e JOIN p_grade p
ON e.job = p.position

-- 장성태 학생의 학번, 이름, 정공1학과코드, 학과이름, 학과위치 출력하기
-- MariaDB 방식
SELECT s.studno, s.name, s.major1, m.name, m.build
FROM student s, major m
WHERE s.major1 = m.code AND s.name = '장성태'
-- ANSI 방식
SELECT s.studno, s.name, s.major1, m.name, m.build
FROM student s join major m
ON s.major1 = m.code 
WHERE s.name = '장성태'

-- 문제
-- 몸무게 80kg 이상인 학생의 학번, 이름, 체중, 학과이름, 학과위치 출력하기
-- MariaDB 방식
SELECT s.studno, s.name, s.weight, m.name, m.build
FROM student s, major m
WHERE s.major1 = m.code AND s.weight >= 80
-- ANSI 방식
SELECT s.studno, s.name, s.weight, m.name, m.build
FROM student s JOIN major m
ON s.major1 = m.code
WHERE s.weight >= 80

-- ========================================================================
/*
	비동기 조인 : NON EQUI JOIN
		조인 컬럼의 조건 = 가 아닌 경우. 범우값으로 조인함.
	
	INNER JOIN : 조건이 맞는 경우만 조회 가능
	OUTER JOIN : 조건이 맞지 않는 경우도 조회가 가능
*/
-- 고객 테이블
SELECT * FROM guest -- no : 고객번호, name : 고객병, point : 포인트값
-- 상품 테이블
SELECT * FROM pointitem -- no : 상품번호, name : 상품명, spoint : 시작포인트, epoint : 종료포인트

-- 고객명, 고객포인트와 포인트로 받을 수 있는 상품명, 시작포인트, 종료포인트 출력하기
-- MariaDB 방식
SELECT g.name, g.point, p.name, p.spoint, p.epoint
FROM  guest g, pointitem p
WHERE g.point BETWEEN p.spoint AND p.epoint
-- ANSI 방식
SELECT g.name, g.point, p.name, p.spoint, p.epoint
FROM guest g, pointitem p
WHERE g.point BETWEEN p.spoint AND p.epoint

-- 낮은 포인트의 상품을 선태할수있다고 할때, 개인별로 가져갈수 있는 상품의 갯수 출력하기
-- 갯수로 정렬하기
-- 그룹화 전의 데이터 조회
SELECT g.name, g.point, p.name, p.spoint, p.epoint
FROM guest g JOIN pointitem p
ON g.point >= p.spoint
-- 그룹화한 후의 데이터 조회
-- MariaDB 방식
SELECT g.name, COUNT(*)
FROM guest g, pointitem p
WHERE g.point >= p.spoint
GROUP BY g.name
ORDER BY COUNT(*)
-- ANSI 방식
SELECT g.name, COUNT(*)
FROM guest g JOIN pointitem p
ON g.point >= p.spoint
GROUP BY g.name
ORDER BY COUNT(*)

-- 문제
-- 낮은포인트의 상품을 선택할 수 있다고 가정할 때 외장하드를 선택할 수 있는 고객의
-- 고객명, 고객포인트, 상품명, 시작포인트, 종료포인트
-- MariaDB 방식
SELECT g.`name`, g.`point`, p.`name`, p.spoint, p.epoint
FROM guest g, pointitem p
WHERE g.point >= p.epoint AND p.name = '외장하드'
-- ANSI 방식
SELECT g.`name`, g.`point`, p.`name`, p.spoint, p.epoint
FROM guest g JOIN pointitem p
ON g.point >= p.epoint
WHERE p.name = '외장하드'

-- 낮은 포인트 상품을 선택할 수 있다고 할 때,
-- 상품을 2개이상 선택할 수 있는 고객이름과 상품갯수를 출력하기
-- MariaDB 방식
SELECT g.`name`, COUNT(*)
FROM guest g, pointitem p
WHERE g.point >= p.spoint
GROUP BY g.name
HAVING COUNT(*) >= 2
ORDER BY COUNT(*), g.name
-- ANSI 방식
SELECT g.`name`, COUNT(*)
FROM guest g JOIN pointitem p
ON g.point >= p.spoint
GROUP BY g.name
HAVING COUNT(*) >= 2
ORDER BY COUNT(*), g.name

-- 학생의 학번, 이름, 국어, 수학, 영어, 총점, 평균, 학점, 출력하기
SELECT * FROM scorebase
-- MariaDB 방식
SELECT s1.studno, s1.`name`, s3.kor, s3.math, s3.eng, s3.kor+s3.math+s3.eng 총점, 
		 ROUND((s3.kor+s3.math+s3.eng)/3) 평균, s2.grade 학점
FROM student s1, scorebase s2, score s3
WHERE s1.studno = s3.studno 
		AND ROUND((s3.kor+s3.math+s3.eng)/3) BETWEEN min_point AND max_point
ORDER BY 학점
-- ANSI 방식
SELECT s1.studno, s1.`name`, s3.kor, s3.math, s3.eng, s3.kor+s3.math+s3.eng 총점, 
		 ROUND((s3.kor+s3.math+s3.eng)/3) 평균, s2.grade 학점
FROM student s1 JOIN score s3
	  ON s1.studno = s3.studno JOIN scorebase s2
	  ON ROUND((s3.kor+s3.math+s3.eng)/3) BETWEEN min_point AND max_point
ORDER BY 학점

/*
	SELF JOIN : 같은 테이블의 다른컬럼을 조인컬럼으로 사용
					반드시 테이블의 별명 설정
					반드시 모든컬럼 출력시 테이블의 별명을 사용필수
*/
SELECT * FROM emp
-- 사원테이블에서 사원이름, 사원직급, 상사이름, 상사직급 출력하기
-- Maria DB 방식
SELECT e1.ename, e1.job, e2.ename, e2.job
FROM emp e1, emp e2
WHERE e1.mgr = e2.empno
-- ANSI 방식
SELECT e1.ename, e1.job, e2.ename, e2.job
FROM emp e1 JOIN emp e2
on e1.mgr = e2.empno
SELECT * FROM major -- code : 학과코드, part : 상위학부코드
-- major  테이블에서 학과코드, 학과명, 상위학과코드, 상위학과명 출력하기
-- MariaDB 방식
SELECT m1.code, m1.name, m2.code, m2.name
FROM major m1, major m2
WHERE m1.code = m2.part
-- ANSI 방식
SELECT m1.code, m1.name, m2.code, m2.name
FROM major m1 JOIN major m2
ON m1.code = m2.part

-- 교수번호, 이름, 입사일이 빠른 사람이름 조회하기
-- MariaDB 방식
SELECT p1.no, p1.name, p1.hiredate, p2.name, p2.hiredate
FROM professor p1, professor p2
WHERE p1.hiredate > p2.hiredate
ORDER BY p1.hiredate DESC
-- ANSI 방식
SELECT p1.no, p1.name, p1.hiredate, p2.name, p2.hiredate
FROM professor p1 JOIN professor p2
ON p1.hiredate > p2.hiredate
ORDER BY p1.hiredate DESC

-- 교수번호, 이름, 입사일이 같은 사람의 이름과 입사일 조회하기
SELECT p1.no, p1.hiredate, p1.`name`,  p2.`name` 
FROM professor p1, professor p2
WHERE p1.hiredate = p2.hiredate

-- 문제
-- 1. 교수번호, 이름, 학과명, 입사일이 같은 사람의 인원수 조회하기
-- MariaDB 방식
SELECT p1.no, p1.name, m.`name`, COUNT(p1.hiredate)
FROM professor p1, professor p2, major m
WHERE m.code = p1.deptno AND p1.hiredate = p2.hiredate
GROUP BY p1.name
ORDER BY COUNT(*) DESC, p1.name
-- ANSI 방식
SELECT p1.no, p1.name, m.`name`, COUNT(p1.hiredate)
FROM professor p1 JOIN professor p2 ON p1.hiredate = p2.hiredate
JOIN major m ON m.code = p1.deptno
GROUP BY p1.name
ORDER BY COUNT(*) DESC, p1.name
-- 2. 교수번호, 이름, 학과명, 입사일이 빠름 사람의 인원수 조회하기
-- MariaDB 방식
SELECT p1.no, p1.name, m.`name`, COUNT(p1.hiredate)
FROM professor p1, professor p2, major m
WHERE m.code = p1.deptno AND p1.hiredate > p2.hiredate
GROUP BY p1.name
ORDER BY COUNT(*) DESC, p1.name
-- ANSI 방식
SELECT p1.no, p1.name, m.`name`, COUNT(p1.hiredate)
FROM professor p1 JOIN professor p2 ON p1.hiredate > p2.hiredate 
JOIN major m ON m.code = p1.deptno
GROUP BY p1.name
ORDER BY COUNT(*) DESC, p1.name
/*
	INNER JOIN : 조인컬럼의 조건이 맞는 레코드만 조회
		EQUI JOIN : 등가조인
		NON EQUI JOIN : 비등가조인
		SELF JOIN : 같은 테이블을 조인
*/
/*
	OUTER JOIN : 조인컬럼의 조건이 맞지 않아도 한쪽, 또는 양쪽 레코드 조회
		LEFT OUTER JOIN : 왼쪽 테이블의 모든 레코드를 조회
		RIGHT OUTER JOIN : 오른쪽 테이블의 모든 레코드를 조회
		FULL OUTER JOIN : 양쪽 테이블의 모든 레코드를 조회. MariaDB 구현X. UNION 방식으로 구현
*/
-- 학생의 이름과 지도교수이름 출력하기
SELECT s.name, p.name
FROM student s, professor p
WHERE s.profno = p.no
-- 지도교수가 없는 학생은 조회되지 않음. 지도교수번호와 교수번호가 일치하는 데이터 없음
-- 지도교수가 없는 학생도 조회하기
SELECT s.name, p.name
FROM student s LEFT OUTER JOIN professor p
ON s.profno = p.no -- ORACLE : p.no(+)

-- 문제
-- 학생의 학번, 이름, 지도교수 번호, 지도교수 이름을 출력하기
-- 지도교수가 없는 학생은 지도교수 없음으로 출력하기
SELECT s.studno, s.name, IFNULL(p.no, '없음'), IFNULL(p.name, '없음')
FROM student s LEFT OUTER JOIN professor p -- LEFT OUTER JOIN : 왼쪽에 있는 학생 정보 전체 출력
ON s.profno = p.no

-- 학생의 학번, 이름, 지도교수번호, 지도교수이름 출력하기
-- 지도학생이 없는 교수도 출력되도록 하기
-- 지도학생없는 교수는 지도학생 없음을 출력
SELECT IFNULL(s.studno, '없음'), s.name, s.profno, p.name
FROM student s RIGHT OUTER JOIN professor p
ON s.profno = p.no

/*
	full outer join : 양쪽테이블의 모든데이터를 조회
	                => MariaDB에서 구현X
*/
-- 학생이름, 지도교수이름을 조회하기
-- 지도교수가 없는 학생은 지도교수 없음 출력
-- 지도학생이 없는 교수는 지도학생 없음 출력

SELECT s.name 학생이름, IFNULL(p.name, '지도교수없음') 교수이름
FROM student s LEFT OUTER JOIN professor p
ON s.profno = p.no
UNION
SELECT IFNULL(s.name, '지도학생없음'), p.name
FROM student s RIGHT OUTER JOIN professor p
ON s.profno = p.no

-- 문제
-- 1. emp, p_grade 테이블을 조인하여, 사원이름, 직급, 현재연봉, 해당직급의 연봉하한, 연봉상한을 조회
--    모든사원을 출력하기
--    연봉 : 급여 * 12 + 보너스 (*보너스가 없는 경우는 0)
SELECT e.ename, e.job, e.salary * 12 + IFNULL(e.bonus, '0') 연봉, p.s_pay, p.e_pay
FROM emp e LEFT OUTER JOIN p_grade p
ON e.job = p.position
-- 2. emp, p_grade 테이블을 조인하여, 사원이름, 입사일, 근속년도, 현재직급, 근속년도 예상직급 조회
--    근속년도 : 오늘을 기준으로 일자/365 소숫점 이하는 버림
--    모든사원을 출력하기
--    DATEDIFF(날짜1, 날짜2) : 날짜1 ~ 날짜2 일수
--		TRUNCATE(숫자, 0) : 내림
SELECT e.ename, e.hiredate, TRUNCATE((DATEDIFF(NOW(), e.hiredate)/365), 0) 근속년도,
		 e.job, p.position
FROM emp e LEFT OUTER JOIN p_grade pprofessorprofessordept
ON TRUNCATE((DATEDIFF(NOW(), e.hiredate)/365), 0) BETWEEN p.s_year AND p.e_year
ORDER BY 근속년도

-- 2. emp, p_grade 테이블을 조인하여, 사원이름, 생일, 나이, 현재직급, 생일기준예상직급 조회
--    나이 : 오늘을 기준으로 일자/365 소숫점 이하는 버림
--    모든사원을 출력하기
SELECT e.ename, e.birthday, TRUNCATE(DATEDIFF(NOW(),e.birthday) / 365, 0) 나이, e.job, p.position
FROM emp e LEFT OUTER JOIN  p_grade p
ON TRUNCATE(DATEDIFF(NOW(),e.birthday) / 365, 0) BETWEEN p.s_age AND p.e_age