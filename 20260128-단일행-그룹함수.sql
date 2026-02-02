/*
  1. 집합연산자
      UNION    : 합집합. 중복되지 않는다
      UNION ALL: 중복됨. 두개의 쿼리의 결과를 연결하여 조회
      => 두개의 SELECT에서 조회되는 컬럼의 수가 같아야 한다
      INTERSECT : 교집합. AND 조건문으로 대부분 가능
      EXCEPT : 차집합.

   2. 함수 : 단일행 함수 : 하나의 레코드에서만 처리되는 함수. WHERE 조건문에서 사용 가능함
             그룹함수 : 여러개의 레코드에서 처리되는 함수. HAVING 조건문에서 사용 가능함
             
   3. 문자열 관련 함수
	   - 대소문자 변경 : UPPER, LOWER
		- 문자열의 길이 : LENGTH(바이트수), CHAR_LENGTH(문자열의길이)
		- 부문문자열    : SUBSTR(문자열,시작인덱스,[갯수]),LEFT(문자열,갯수),RIGTH(문자열,갯수)
		- 문자연결함수  : CONCAT
		- 문자의 위치   : INSTR(문자열,문자) => 문자열에서 문자의 위치 인덱스 리턴. 인덱스는 1부터 시작
		- 문자 추가 : LPAD(문자열,전체자리수,채울문자),RPAD(문자열,전체자리수,채울문자)
		- 문자제거  : TRIM(문자열) : 양쪽 공백을 제거
		              LTRIM(문자열): 왼쪽 공백을 제거
		              RTRIM(문자열): 오른쪽 공백을 제거
		              TRIM(LEADING|TRAILING|BOTH 제거할문자 FROM 문자열 ) : 지정한 문자를 제거
		                    왼쪽  | 오른쪽 | 양쪽
		- 문자치환 : REPLACE(문자열,문자1,문자2)=> 문자열에서 문자1을 문자2로 치환
		- 그룹의 위치 : FIND_IN_SET(문자,문자열) => ,를 가진 문자열에서 문자가 몇번째 위치인지 리턴
	4. 숫자 관련 함수
	   - 반올림 : ROUND(숫자,[소숫점이하자리수])	자리수 생략시 정수로 출력
	   - 버림 : TRUNCATE(숫자,소숫점이하자리수)
	   - 나머지 : MOD, %연산자 가능
	   - 제곱 : POWER(숫자1,숫자2) : 숫자1을 숫자2만큼 곱하기
	   - 근사정수 : CELI  : 큰근사정수
	                FLOOR : 작은 근사정수
	   - 제곱근 : SQRT(숫자)             
	5. 날짜 관련 함수
	   - 현재일시 : NOW(). 오라클:SYSDATE
		- 현재일자 : CURDATE(),CURRENT_DATE,CURRENT_DATE()
		- 년월일 : YEAR,MONTH,DAY,WEEKDAY(0(월)),DAYOFWEEK(1(일)),LAST_DAY(해당월의 마지막날짜)
		- 이전/이후 : DATE_ADD/DATE_SUB(날짜, interval 숫자 [YEAR|MONTH|DAY|HOUR|MINUTE|SECOND]) 
		- 날짜 변환 함수 : DATE_FORMAT : 날짜 => 문자열   오라클: TO_CHAR()
		                   STR_TO_DATE : 문자열 => 날짜   오라클: TO_DATE()        
		   %Y,%m,%d,......    
   6. 기타함수
    - IFNULL(컬럼,기본값) : 컬럼의 값이 NULL인 경우 기본값으로 치환
                            오라클 : NVL(컬럼,기본값)
    - 조건함수 : IF, CASE
	      IF(조건문,참,거짓) : 중첩가능
	                         오라클 : DECODE(조건문,참,거짓)
*/
/*
	if 함수 : 조건식에서 in 연산자 사용이 가능함
*/
-- 학생의 주민번호의 7번째 자리가 1, 3인 경우 남자, 2, 4인 경우 여자로 출력하기
-- 그외는 주민번호 오류로 출력하기
SELECT NAME, jumin,
		 if(SUBSTR(jumin, 7, 1) = '1', '남자',
		 	if(SUBSTR(jumin, 7, 1) = '2', '여자',
		 		if(SUBSTR(jumin, 7, 1) = '3', '남자',
		 			if(SUBSTR(jumin, 7, 1) = '4', '여자', '오류')))) 성별
FROM student

SELECT NAME, jumin,
		 if(SUBSTR(jumin, 7, 1) IN (1,3), '남자',
			if(SUBSTR(jumin, 7, 1) IN (2,4), '여자', '오류')) 성별
FROM student
/*
	case 조건문
		case 컬럼명 when 값1 then 문자열
						when 값2 then 문자열
						...
						ELSE 문자열 END
						
		case when 조건식1 then 문자열
			  when 조건식2 then 문자열
			  ...
			  ELSE 문자열 END
*/
-- 교수이름, 학과코드, 학과명 출력하기
-- 학과명: 101학과는 컴퓨터공학 그외는 공란 출력하기
SELECT NAME, deptno, 
		 case deptno when 101 then '컴퓨터공학'
		             ELSE '' END 학과명
FROM professor

-- 교수이름, 학과코드, 학과명 출력하기
-- 학과명: 101학과는 컴퓨터공학 그외는 그외학과 출력하기
SELECT NAME, deptno,
		 case deptno when 101 then '컴퓨터공학'
		 				 ELSE '그외학과' END 학과명
FROM professor

-- 교수이름, 학과코드, 학과명 출력하기
-- 학과명: 101학과: 컴퓨터공학, 102학과:멀티미디어공학, 201: 기계공학 그외는 그외학과 출력하기
SELECT NAME, deptno,
       case deptno when 101 then '컴퓨터공학'
       				 when 102 then '멀티미디어공학'
       				 when 201 then '기계공학'
       				 ELSE '그외공학' END 학과명
FROM professor       		

-- 교수이름, 학과번호, 대학명 출력하기
-- 대학명: 101, 102, 201 = 공과대학, 그외는 그외대학으로 출력하기
SELECT NAME, deptno, 
		 if(deptno IN (101, 102, 201), '공과대학', '그외대학')
FROM professor

-- case 함수 => 오류발생
SELECT NAME, deptno
		 case deptno when 101, 102, 201 then '공과대학'
		 				 ELSE '기타대학' END
FROM professor

-- case 함수 => 정상
SELECT NAME, deptno,
		 case when deptno IN (101, 102, 201) then '공과대학'
		 		ELSE '기타대학' END 대학명
FROM professor

-- 문제
-- 학생의 이름, 주민번호, 출생분기 출력하기
--	출생분기 : 주민번호 기준 1 ~ 3 월 : 1분기
--									 4 ~ 6 월 : 2분기
--               				 7 ~ 9 월 : 3분기
-- 								 10 ~ 12 월 : 4분기
SELECT NAME, jumin, 
		 case when SUBSTR(jumin, 3, 2) >= 01 AND SUBSTR(jumin, 3, 2) <= 03 then '1분기'
				when SUBSTR(jumin, 3, 2) BETWEEN 04 AND 06 then '2분기'
				when SUBSTR(jumin, 3, 2) BETWEEN 07 AND 09 then '3분기'
				when SUBSTR(jumin, 3, 2) BETWEEN 10 AND 12 then '4분기'
				ELSE '오류' END 출생분기
FROM student

-- ==================================================================================
/*
	그룹함수 : 여러개의 행의 정보를 이용하여 결과 리턴
	
	SELECT 컬럼명| *
	FROM 테이블명
	[WHERE 조건문] => 레코드 선택 조건
	[GROUP BY 컬럼명] => 레코드들을 그룹화 하기 위한 기준컬럼 설정
							=> GROUP BY 구문이 없는 경우 모든 레코드를 하나의 그룹으로 처리
	[HAVING 조건문] => 그룹 선택 조건문
	[ORDER BY 컬럼명|별명|순서] => 정렬 기준 선택
*/
/*
	COUNT(*|컬럼명) : 조회된 레코드의 갯수 리턴. 컬럼명의 값이 NULL인 경우 갯수 포함X
*/
-- 교수의 전체 인원수와 보너스를 받는 인원수 조회하기
-- COUNT(*) : 조회된 레코드 갯수
-- COUNT(bonus) : bonus 컬럼의 값이 NULL 아닌 레코드의 갯수
SELECT COUNT(*), COUNT(bonus) FROM professor

-- 문제 : 학생의 전체 인원수와 지도교수를 배정 받은 학생의 인원수를 출력하기
SELECT COUNT(*), COUNT(profno) FROM student

-- 학생 중 101번 전공1학과의 속한 학생의 인원수 출력하기
SELECT COUNT(*) FROM student
WHERE major1 = 101

-- 1학년 학생의 전체 인원수와 지도교수를 배정받은 학생의 인원수를 출력하기
SELECT COUNT(*), COUNT(profno) FROM student
WHERE grade = 1
-- 2학년 학생의 전체 인원수와 지도교수를 배정받은 학생의 인원수를 출력하기
SELECT COUNT(*), COUNT(profno) FROM student
WHERE grade = 2
-- 3학년 학생의 전체 인원수와 지도교수를 배정받은 학생의 인원수를 출력하기
SELECT COUNT(*), COUNT(profno) FROM student
WHERE grade = 3
-- 4학년 학생의 전체 인원수와 지도교수를 배정받은 학생의 인원수를 출력하기
SELECT COUNT(*), COUNT(profno) FROM student
WHERE grade = 4
-- 학년별 인원수와 지도교수를 배정받은 인원수 출력하기
SELECT grade, COUNT(*), COUNT(profno) FROM student
GROUP BY grade

-- 전공 1학과별로 인원수와 지도교수를 배정받은 인원수 출력하기
SELECT major1, COUNT(*), COUNT(profno) FROM student
GROUP BY major1

-- 지도교수가 배정되지 않은 학년의 전체 인원수를 출력하기
SELECT grade, COUNT(*), COUNT(profno) FROM student
GROUP BY grade
HAVING COUNT(profno) = 0 -- 그룹함수의 조건시 사용되는 구문

SELECT grade, COUNT(*), COUNT(profno) FROM student
WHERE COUNT(profno) = 0 -- WHERE 조건문에서는 그룹함수의 조건 사용 불가
GROUP BY grade

/*
	합계 : SUM
	평균 : AVG
*/
-- 교수들의 급여합계와 보너스 합계 출력하기
SELECT SUM(salary), SUM(bonus) FROM professor
-- 교수들의 인원수, 급여합계와 보너스 합계, 급여 평균, 보너스 평균 출력하기
-- AVG(bonus) : 보너스를 받는 교수의 평균값 리턴
SELECT COUNT(*), SUM(salary), SUM(bonus), AVG(salary), AVG(bonus)
FROM professor

-- 교수드르이 인원수, 급여합계와 보너스 합계, 급여평균,
-- 보너스가 없는 교수도 포함한 보너스 평균 출력하기
-- AVG(IFNULL(bonus, 0)) : bonus가 없는 경우 0으로 환산하여 평균 리턴
SELECT COUNT(*), SUM(salary), SUM(bonus), AVG(salary), TRUNCATE(AVG(IFNULL(bonus,0)),0)
FROM professor

-- 문제
-- 1. 교수의 부서코드, 부서별 인원수, 급여 합계, 보너스 합계, 급여 평균, 보너스 평균을 출력하기
--    단 보너스가 없는 교수도 평균에 포함되도록 하기
SELECT deptno, COUNT(*), SUM(salary), SUM(bonus), AVG(salary), AVG(IFNULL(bonus, 0))
FROM professor
GROUP BY deptno
-- 2. 학년별 학생의 인원수, 키와 몸무게 평균을 출력하기
--    학년 순으로 정렬하기
SELECT grade ,COUNT(*), AVG(height), AVG(weight)
FROM student
GROUP BY grade
ORDER BY grade
-- 3. 부서별 교수의 급여 합, 보너스 합, 연봉 합, 급여 평균, 보너스 평균, 연봉 평균 출력하기
--    연봉 : 급여 * 12 + 보너스
--    보너스가 없는 경우는 0 으로 처리함
--    평균 출력시 소숫점 이하 2자리로 반올림하여 출력하기
SELECT deptno, SUM(salary) '총 급여',
 		 SUM(IFNULL(bonus, 0)) '총 보너스',
 		 SUM(salary * 12 + IFNULL(bonus, 0)) '총 연봉',
  		 ROUND(AVG(salary), 2) '급여 평균',
		 ROUND(AVG(IFNULL(bonus, 0)), 2) '보너스 평균',
	    ROUND(AVG(salary * 12 + IFNULL(bonus, 0)), 2) '연봉 평균'
FROM professor
GROUP BY deptno
-- 4. 부서별 교수의 급여 합, 보너스 합, 연봉 합, 급여 평균, 보너스 평균, 연봉 평균 출력하기
--    연봉 : 급여 * 12 + 보너스
--    보너스가 없는 경우는 0 으로 처리함
--    평균 출력시 소숫점 이하 2자리로 반올림하여 출력하기
--    보너스 평균이 60이상인 부서만 출력하기
SELECT deptno, SUM(salary) '총 급여',
 		 SUM(IFNULL(bonus, 0)) '총 보너스',
 		 SUM(salary * 12 + IFNULL(bonus, 0)) '총 연봉',
  		 ROUND(AVG(salary), 2) '급여 평균',
		 ROUND(AVG(IFNULL(bonus, 0)), 2) '보너스 평균',
	    ROUND(AVG(salary * 12 + IFNULL(bonus, 0)), 2) '연봉 평균'
FROM professor
GROUP BY deptno
HAVING ROUND(AVG(IFNULL(bonus, 0)), 2) >= 60
/*
	최대값, 최소값 : max, min
*/
-- 전공1학과별 가장 키가 큰 학생의 큰 키값, 작은 키값을 출력하기
SELECT major1, MAX(height), MIN(height)
FROM student
GROUP BY major1

-- 전공1학과별 가장 키가 큰 학생의 큰 키값, 작은 키값을 출력하기
-- 최대 키가 180 이상인 학과정보만 출력하기
SELECT major1, MAX(height), MIN(height)
FROM student
GROUP BY major1
HAVING Max(height) >= 180

-- 교수의 직급별 가장 최대 급여와 최소 급여 출력하기
SELECT POSITION, MAX(salary), MIN(salary)
FROM professor
GROUP BY POSITION

/*
	표준편차 : STDDEV
	분산     : VARIANCE
*/
-- 학생 점수테이블(score)에서 합계, 평균, 표준편차, 분산 조회하기
SELECT SUM(kor+math+eng),SUM(kor),SUM(math),SUM(eng),
		 AVG(kor+math+eng), AVG(kor), AVG(math), AVG(eng),
		 STDDEV(kor+math+eng), STDDEV(kor), STDDEV(math), STDDEV(eng),
		 VARIANCE(kor+math+eng), VARIANCE(kor), VARIANCE(math), VARIANCE(eng)
FROM score

-- 문제
-- 1. 학생테이블에서 학과별 최대키, 최소키, 평균키를 출력하기
--    평균키가 170 이상인 학과정보만 출력하기
SELECT major1, MAX(height), MIN(height), AVG(height)
FROM student
GROUP BY major1
HAVING AVG(height) >= 170
-- 2. 교수테이블에서 학과별 평균 급여가 350 이상인 부서의
--    급여평균, 보너스평균, 급여표준편차를 출력하기
SELECT deptno, AVG(salary), AVG(bonus), STDDEV(salary)
FROM professor
GROUP BY deptno
HAVING AVG(salary) >= 350
-- 3. 주민번호 기준으로 남, 여학생의 최대키, 최소키, 평균키를 출력하기
SELECT if(SUBSTR(jumin, 7, 1) IN (1, 3), '남학생', '여학생') 성별, MAX(height), MIN(height), AVG(height)
FROM student
GROUP BY 성별

SELECT if(SUBSTR(jumin, 7, 1) IN (1, 3), '남학생', '여학생') 성별, MAX(height), MIN(height), AVG(height)
FROM student
GROUP BY f(SUBSTR(jumin, 7, 1) IN (1, 3), '남학생', '여학생')

-- 학생의 생일(birthday)의 월별 인원수 출력하기
SELECT CONCAT(MONTH(birthday),'월') 월, COUNT(*) 인원수 FROM student
GROUP BY MONTH(birthday)

-- 학생의 생일(jumin)의 월별 인원수 출력하기
SELECT CONCAT(SUBSTR(jumin, 3, 2), '월') 월별, COUNT(*) 인원수 FROM student
GROUP BY SUBSTR(jumin, 3, 2)

-- 그룹화 하기전의 데이터 조회
SELECT CONCAT(SUBSTR(jumin,3,2), '월') 월별, jumin FROM student
ORDER BY 월별

SELECT CONCAT(MONTH(STR_TO_DATE(SUBSTR(jumin, 3, 2), '%m'))+,'월') 월, COUNT(*) 인원수 FROM student
GROUP BY 월

-- 생일의 월별 인원수 출력하기. 가로 출력
SELECT CONCAT(COUNT(*)+"", '명') 전체,
		 COUNT(if(MONTH(birthday)=1, 1, NULL)) 1월,
		 COUNT(if(MONTH(birthday)=2, 1, NULL)) 2월,
		 COUNT(if(MONTH(birthday)=3, 1, NULL)) 3월,
		 COUNT(if(MONTH(birthday)=4, 1, NULL)) 4월,
		 COUNT(if(MONTH(birthday)=5, 1, NULL)) 5월,
		 COUNT(if(MONTH(birthday)=6, 1, NULL)) 6월,
		 COUNT(if(MONTH(birthday)=7, 1, NULL)) 7월,
		 COUNT(if(MONTH(birthday)=8, 1, NULL)) 8월,
		 COUNT(if(MONTH(birthday)=9, 1, NULL)) 9월,
		 COUNT(if(MONTH(birthday)=10, 1, NULL)) 10월,
		 COUNT(if(MONTH(birthday)=11, 1, NULL)) 11월,
		 COUNT(if(MONTH(birthday)=12, 1, NULL)) 12월
FROM student
/*
	95-01-02
	95-03-04
	95-02-01
	95-01-01
	1월   2월   3월  ...12월
	1     NULL  NULL    NULL
	NULL  NULL  1       NULL
	NULL  1     NULL    NULL
	1     NULL  NULL    NULL
	
count 함수
	1월   2월   3월
   2     1     1
*/
-- 그룹화 하지않은 데이터로 출력하기
SELECT
		 if(MONTH(birthday)=1, 1, NULL) 1월,
		 if(MONTH(birthday)=2, 1, NULL) 2월,
		 if(MONTH(birthday)=3, 1, NULL) 3월,
		 if(MONTH(birthday)=4, 1, NULL) 4월,
		 if(MONTH(birthday)=5, 1, NULL) 5월,
		 if(MONTH(birthday)=6, 1, NULL) 6월,
		 if(MONTH(birthday)=7, 1, NULL) 7월,
		 if(MONTH(birthday)=8, 1, NULL) 8월,
		 if(MONTH(birthday)=9, 1, NULL) 9월,
		 if(MONTH(birthday)=10, 1, NULL) 10월,
		 if(MONTH(birthday)=11, 1, NULL) 11월,
		 if(MONTH(birthday)=12, 1, NULL) 12월
FROM student

-- SUM 함수 이용
SELECT CONCAT(COUNT(*)+"", '명') 전체,
		 SUM(if(MONTH(birthday)=1, 1, 0)) 1월,
		 SUM(if(MONTH(birthday)=2, 1, 0)) 2월,
		 SUM(if(MONTH(birthday)=3, 1, 0)) 3월,
		 SUM(if(MONTH(birthday)=4, 1, 0)) 4월,
		 SUM(if(MONTH(birthday)=5, 1, 0)) 5월,
		 SUM(if(MONTH(birthday)=6, 1, 0)) 6월,
		 SUM(if(MONTH(birthday)=7, 1, 0)) 7월,
		 SUM(if(MONTH(birthday)=8, 1, 0)) 8월,
		 SUM(if(MONTH(birthday)=9, 1, 0)) 9월,
		 SUM(if(MONTH(birthday)=10, 1, 0)) 10월,
		 SUM(if(MONTH(birthday)=11, 1, 0)) 11월,
		 SUM(if(MONTH(birthday)=12, 1, 0)) 12월
FROM student

/*
	순위지정함수 : RANK() OVER(정렬방식)
*/
-- 교수의 번호, 이름, 급여, 급여순위 출력하기
SELECT NO, NAME, salary, RANK() OVER(ORDER BY salary DESC) 급여순위
FROM professor
-- 교수의 번호, 이름, 급여, 적게 받는 순서로 급여순위 출력하기
SELECT NO, NAME, salary, RANK() OVER(ORDER BY salary ASC) 급여순위
FROM professor

-- score 테이블에서 학번, 국어, 수학, 영어, 총점, 총점기준 순위 출력하기
SELECT *, kor+math+eng 총점, RANK() OVER(ORDER BY 총점 DESC) 순위
FROM score

-- score 테이블에서 학번, 국어, 수학, 영어, 총점, 국어등수, 수학등수, 영어등수, 총점등수 출력하기
SELECT *, kor+math+eng 총점, 
RANK() OVER(ORDER BY kor DESC) 국어등수,
RANK() OVER(ORDER BY math DESC) 수학등수,
RANK() OVER(ORDER BY eng DESC) 영어등수,
RANK() OVER(ORDER BY 총점 DESC) 총점등수
FROM score
ORDER BY 국어등수
/*
	누계 : SUM(컬럼명) OVER(정렬방식)
*/
-- 교수의 이름, 급여, 보너스, 급여누계 출력하기
SELECT NAME, salary, bonus, SUM(salary) OVER(ORDER BY salary DESC) 급여누계
FROM professor

-- score 테이블에서 학번, 국어, 수학, 영어, 총점, 총점등수, 총점누계 출력하기
SELECT *, (kor+math+eng) 총점, RANK() OVER(ORDER BY (kor+math+eng) DESC) 총점등수,
		 SUM(kor+math+eng) OVER(ORDER BY (kor+math+eng) DESC) 총점누계
FROM score

/*
	부분결과 : ROLLUP
				  GROUP BY 컬럼1, 컬럼2 WITH ROLLUP
				
				  두개의 컬럼을 기준으로 그룹화 가능.
			     컬럼1로도 결과를 출력
	mariaDB 에서는 구현X. 오라클은 가능
	   cube  : 컬럼1로 부분결과 출력, 컬럼2로도 부분결과가 출력
*/
-- score 테이블에서, 국어, 수학, 합계의 합을 출력하기
SELECT kor, math, sum(kor + math), COUNT(*)
FROM score
GROUP BY kor, math

SELECT kor, math, sum(kor + math), COUNT(*)
FROM score
GROUP BY kor, math WITH ROLLUP

-- 학년별, 지역별, 몸무게 평균, 키평균 조회하기
SELECT grade, SUBSTR(tel, 1, INSTR(tel, ')')-1) 지역, AVG(weight), AVG(height)
FROM student
GROUP BY grade, 지역

SELECT grade, SUBSTR(tel, 1, INSTR(tel, ')')-1) 지역, AVG(weight), AVG(height)
FROM student
GROUP BY grade, 지역 WITH ROLLUP

SELECT grade 학년, AVG(weight) 몸무게평균, AVG(height) 키평균
FROM student
GROUP BY grade

SELECT SUBSTR(tel, 1, INSTR(tel, ')')-1) 지역,grade , AVG(weight), AVG(height)
FROM student
GROUP BY 지역, grade

SELECT SUBSTR(tel, 1, INSTR(tel, ')')-1) 지역,grade , AVG(weight), AVG(height)
FROM student
GROUP BY 지역, grade WITH ROLLUP

-- 문제
-- 학년별, 성별, 몸무게평균, 키평균 조회하기. 학년별로도 평균 출력하기
SELECT grade, if(SUBSTR(jumin,7,1)=1,'남','여') 성별, AVG(weight), AVG(height)
FROM student
GROUP BY grade, if(SUBSTR(jumin,7,1)=1,'남','여') WITH ROLLUP

-- =======================================================================
/*
	JOIN : 여러개의 테이블을 연결하여 조회
*/
/*
	CROSS JOIN(교차조인) : 두개의 테이블을 조인.
		a, b 테이블을 조인
			컬럼의 갯수 : a 컬럼의 수 + b 컬럼의 수
			레코드의 갯수 : a 레코드 갯수 * b 테이블의 레코드 갯수
		m * n 개의 레코드가 생성됨. 사용시 주의가 필요
*/

SELECT * FROM emp -- 14개의 레코드, 9개의 컬럼
SELECT * FROM dept -- 5개의 레코드, 3개의 컬럼
-- MariaDB 방식으로 JOIN
SELECT * FROM emp, dept -- 9 + 3 = 12개의 컬럼, 14 * 5 = 70 개의 레코드
-- ansi 방식으로 JOIN
SELECT * FROM emp CROSS JOIN dept

-- 사원번호 (empno), 사원명(ename), 직책(job), 부서코드(deptno), 부서명(dname) 출력하기
-- 중복된 컬럼은 테이블명.컬럼명으로 반드시 표현.
-- 중복되지 않은 컬럼은 컬럼명으로 표현 선택. 테이블명.컬럼명도 가능
SELECT emp.empno, emp.ename, emp.job, emp.deptno, dept.dname
FROM emp, dept
-- 테이블명에 별명(alias)를 설정해서 많이 사용함
SELECT e.empno, e.ename, e.job, e.deptno, d.dname
FROM emp e, dept d -- 테이블에 별명 설정 

-- ansi 방식으로 JOIN
SELECT e.empno, e.ename, e.job, e.deptno, d.deptno, d.dname
FROM emp e CROSS JOIN dept d

/*
	등가조인(EQUI JOIN)
		조인컬럼을 이용하여 필요한 레코드 조회.
		조인 컬럼의 방식이 = 연산자로 필요한 레코드 선택 방식
*/
-- 사원번호, 사원명, 직책, 부서코드, 부서명 출력하기
-- MariaDB 방식
SELECT e.empno, e.ename, e.job, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno -- 조인 컬럼
-- ansi 방식
SELECT e.empno, e.ename, e.job, e.deptno, d.dname
FROM emp e JOIN dept d
ON e.deptno = d.deptno    -- 조인 컬럼