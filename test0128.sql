/*
1. score 테이블에서 학번, 국어,영어,수학, 학점, 인정여부 을 출력하기
   학점은 세과목 평균이 95이상이면 A+,90 이상 A0
                       85이상이면 B+,80 이상 B0
                       75이상이면 C+,70 이상 C0
                       65이상이면 D+,60 이상 D0
    인정여부는 평균이 60이상이면 PASS로 미만이면 FAIL로 출력한다.                   
   으로 출력한다.
*/
SELECT *, case when (kor+eng+math)/3 > 94 then 'A+'
			 		when (kor+eng+math)/3 > 89 then 'A0'
			 		when (kor+eng+math)/3 > 84 then 'B+'
			 		when (kor+eng+math)/3 > 79 then 'B0'
			 		when (kor+eng+math)/3 > 74 then 'C+'
			 		when (kor+eng+math)/3 > 69 then 'C0'
			 		when (kor+eng+math)/3 > 64 then 'D+'
			 		when (kor+eng+math)/3 > 59 then 'D0'
			 		END 학점,
		 	 case when (kor+eng+math)/3  > 60 then 'PASS' END 'FAIL' 인정여부
FROM score
/*   
2. 학생 테이블에서 이름, 키, 키의 범위에 따라 A, B, C ,D그룹을 출력하기
     160 미만 : A그룹
     160 ~ 169까지 : B그룹
     170 ~ 179까지 : C그룹
     180이상       : D그룹
*/
SELECT NAME 이름, height 키, case when height < 160 then 'A그룹'
											 when height BETWEEN 160 AND 169 then 'B그룹'
										  	 when height BETWEEN 170 AND 179 then 'C그룹'
								  			 when height >= 180 then 'D그룹' END '키그룹'
FROM student								  
								  
/*      
3. 교수테이블에서 교수의 급여액수를 기준으로 200이하는 4급, 201~300 : 3급, 301~400:2급
    401 이상은 1급으로 표시한다. 교수의 이름, 급여, 등급을 출력하기
    단 등급의 오름차순으로 정렬하기
*/
SELECT NAME 이름, salary 급여, case when salary <= 200 then '4급'
												when salary BETWEEN 201 AND 300 then '3급'
												when salary BETWEEN 301 AND 400 then '2급'
												when salary > 400 then '1급' END 등급
FROM professor
ORDER BY 등급
/*
4. 교수 중 부서별 급여를 최대급여, 최소급여, 최대보너스, 최소보너스 출력하기
보너스가 없는 경우는 0으로 처리한다
*/
SELECT deptno, MAX(salary) 최대급여, MIN(salary) 최소급여, IFNULL(MAX(bonus), 0) 최대보너스, IFNULL(MIN(bonus), 0) 최소보너스
FROM professor
GROUP BY deptno
/*
5. 학생의 학년별 키와 몸무게 평균 출력하기.
  학년별로 정렬하기. 
  평균은 소숫점2자리 반올림하여 출력하기
*/
SELECT grade 학년, ROUND(AVG(height), 2) 키평균, ROUND(AVG(weight), 2) 몸무게평균
FROM student
GROUP BY grade
ORDER BY grade
/*
6. 평균키가 170이상인  전공1학과의 
   가장 키가 큰키와, 가장 작은키, 키의 평균을 구하기 
*/ 
SELECT major1 전공코드, MAX(height) 큰키, MIN(height) 작은키, AVG(height) 키평균
FROM student
GROUP BY major1
HAVING AVG(height) >= 170
/*
7.  사원의 직급(job)별로 평균 급여를 출력하고, 
    평균 급여가 1000이상이면 '우수', 작으면 '보통'을 출력하여라
*/
SELECT job 직급, AVG(salary) '평균급여',if(AVG(salary) >= 1000, '우수', '보통') 등급
FROM emp
GROUP BY job
/*
8. 학과별로 학생의 평균 몸무게와 학생수를 출력하되 
   평균 몸무게의 내림차순으로 정렬하여 출력하기
*/
SELECT major1, AVG(weight), COUNT(*)
FROM student
GROUP BY major1
ORDER BY AVG(weight) DESC
/*
9. 학과별 교수의 수가 2명 이하인 학과번호, 인원수를 출력하기
*/
SELECT deptno, COUNT(*)
FROM professor
GROUP BY deptno
HAVING COUNT(deptno) <= 2
/*
10. 전화번호의 지역번호가 02서울 031 경기, 051 부산, 052 경남, 나머지 그외지역
    학생의 인원수를 조회하기
*/
SELECT COUNT(*), case (LEFT(tel, INSTR(tel, ')')-1))  when 02 then '서울'
																		when 031 then '경기'
																		when 051 then '부산'
																		when 052 then '경남'
																		ELSE '기타' END 지역번호
FROM student
GROUP BY 지역번호
/*
11. 전화번호의 지역번호가 02서울 031 경기, 051 부산, 052 경남, 나머지 그외지역
    학생의 인원수를 조회하기. 가로출력
*/
SELECT COUNT(if((LEFT(tel, INSTR(tel, ')')-1)) = 02, '서울', NULL))'서울',
		 COUNT(if((LEFT(tel, INSTR(tel, ')')-1)) = 031, '경기', NULL))'경기',
		 COUNT(if((LEFT(tel, INSTR(tel, ')')-1)) = 051, '부산', NULL))'부산',
		 COUNT(if((LEFT(tel, INSTR(tel, ')')-1)) = 052, '경남', null)) 경남,
		 COUNT(if((LEFT(tel, INSTR(tel, ')')-1)) NOT IN (02, 031 , 051, 052), '기타', NULL)) 그외지역
FROM student
/*
12. 교수들의 번호,이름,급여,보너스, 총급여(급여+보너스)
    급여많은순위,보너스많은순위,총급여많은 순위 조회하기
    총급여순위로 정렬하여 출력하기. 보너스없는 경우 0으로 함
*/
SELECT NO 번호, NAME 이름, salary 급여, IFNULL(bonus, 0) 보너스, salary+IFNULL(bonus, 0) 총급여, RANK() OVER(ORDER BY salary DESC) 급여순위, RANK() OVER(ORDER BY IFNULL(bonus, 0) DESC) 보너스순위, RANK() OVER(ORDER BY salary + IFNULL(bonus, 0) DESC) 총급여순위
FROM professor
ORDER BY 총급여순위
/*
13.  교수의 직급,직급별 인원수,급여합계,보너스합계,급여평균,보너스평균 출력하기
   단 보너스가 없는 교수도 평균에 포함되도록 한다.
   급여평균이 높은순으로 정렬하기
*/
SELECT POSITION 직급, COUNT(*) 인원수, SUM(salary) 급여합계, SUM(IFNULL(bonus, 0)) 보너스합계, AVG(salary) 급여평균, AVG(IFNULL(bonus, 0))
FROM professor
GROUP BY POSITION
ORDER BY 급여평균 DESC
/*
14. 1학년 학생의 인원수,키와 몸무게의 평균 출력하기
*/
SELECT COUNT(*)인원수, AVG(height) 키평균, AVG(weight) 몸무게평균
FROM student
WHERE grade = 1
GROUP BY grade
/*
15. 학생의 점수테이블(score)에서 수학 평균,수학표준편차,수학분산 조회하기
*/
SELECT AVG(math) 수학평균, STDDEV(math) 수학표준편차, VARIANCE(math) 수학분산
FROM score
/*
16. 교수의 전체 인원수와 월별 입사 인원수를 출력하기
*/
SELECT COUNT(*) '전체 인원수' ,CONCAT(MONTH(hiredate), '월') '월별 입사 인원수'
FROM professor
GROUP BY 2 WITH ROLLUP