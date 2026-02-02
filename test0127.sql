-- 1 학생의 생일이 97년 이후인 학생의 학번, 이름, 생일을 출력하기
SELECT studno, NAME, birthday
FROM student
WHERE YEAR(birthday) >= 1997

-- 2. 학생 테이블을 읽어 
--    '학생이름의 생일은 yyyy-mm-dd  입니다. 축하합니다' 형태로 출력하기
SELECT CONCAT(NAME, "의 생일은 ", birthday, ' 입니다. 축하합니다')
FROM student

-- 3. 학생 테이블에서 학생 이름과키,몸무게, 표준체중을 출력하기
--    표준 체중은 키에서 100을 뺀 값에 0.9를 곱한 값이다.
SELECT NAME, height, weight, (height-100)*0.9 '표준 체중'
FROM student

-- 4. 101 번 학과 학생 중에서 3학년 이상인 학생의 
-- 이름, 아이디, 학년을 출력하기
SELECT NAME, id, grade
FROM student
WHERE major1 = 101 AND grade > 2

-- 5. EMP 테이블에서 급여가 600에서 700 사이인 사원의 
-- 성명, 업무(job), 급여(salary), 부서번호(deptno)를 출력하여라.
SELECT ename, job, salary, deptno
FROM emp
WHERE salary BETWEEN 600 AND 700

-- 6. EMP테이블에서 사원번호(empno)가 2001, 2005, 2008 인 
-- 사원의 사원번호, 성명, 업무(job), 급여, 입사일자(hiredate)를 출력하여라.
SELECT empno, ename, job, salary, hiredate
FROM emp
WHERE empno IN(2001, 2005, 2008)

-- 7. EMP 테이블에서 이름의 첫 글자가 ‘주’인 사원의 이름, 급여를 조회하라.
SELECT ename, salary
FROM emp
WHERE ename LIKE '주%'

-- 8. EMP 테이블에서 급여가 800 이상이고, 담당업무(JOB)이 차장인 
--    사원의 사원번호, 성명, 담당업무, 급여, 입사일자, 부서번호를 출력하여라.
SELECT empno, ename, job, salary, hiredate, deptno
FROM emp
WHERE salary >= 800 AND job = '차장'

-- 9. 교수테이블에서 이메일이 있는 교수의 이름, 직책,   email, emailid 를 출력하기
--  emailid는 @이전의 문자를 말한다.
SELECT NAME, POSITION, email, LEFT(email, INSTR(email, '@') - 1) emailid
FROM professor

-- 10. 101번 학과 학생의 이름 중 두번째 글자만 '#'으로 치환하여 출력하기
SELECT CONCAT(SUBSTR(NAME, 1, 1), '#', SUBSTR(NAME, 3))
FROM student
WHERE major1 = 101

-- 11. 102번 학과 학생의 이름과 전화번호, 전화번호의 국번부분(중간)만#으로 치환하여 출력하기(단 국번은 3자리로 간주함.)
SELECT NAME, tel, REPLACE(tel, SUBSTR(tel, INSTR(tel, ')')+1, 3), '###')
FROM student

-- 12. 교수테이블의의  email 주소의 @다음의 3자리를 ###으로 치환하여 출력하기  교수의 이름, email, #mail을 출력하기
SELECT NAME, email, REPLACE(email, SUBSTR(email, INSTR(email, '@')+1, 3), '###') #mail
FROM professor

-- 13. 교수테이블의  email 주소의 @앞의 3자리를 ###으로 치환하여 출력하기  교수의 이름, email, #mail을 출력하기
SELECT NAME, email, REPLACE(email, SUBSTR(email, INSTR(email, '@')-3, 3), '###') #mail
FROM professor

-- 14. 사원테이블에서 사원이름에 *를 왼쪽에 채운  6자리수 이름과, 업무와 급여를 출력한다.
SELECT LPAD(ename, 6, '*'), job, salary
FROM emp
 
-- 15. 교수들의 근무 개월 수를 현재 일을 기준으로  계산하되,  
-- 근무 개월 순으로 정렬하여 출력하기.  
-- 단, 개월 수의 소수점 이하 버린다
SELECT TRUNCATE(DATEDIFF(NOW(), hiredate)/30, 0) '근무 개월 수'
FROM professor
ORDER BY 1

-- 16. 사용자 아이디에서 문자열의 길이가 7이상인   학생의 이름과 
-- 사용자 아이디를 출력 하여라
SELECT NAME, id
FROM student
WHERE CHAR_LENGTH(id) >= 7

-- 17. 교수테이블에서 이름과, 교수가 사용하는 email  서버의 이름을   
--  출력하라.  이메일 서버는 @이후의 문자를 말한다.
SELECT NAME, SUBSTR(email, INSTR(email, '@') + 1)
FROM professor
 

-- 18. 101번학과, 201번, 301번 학과 교수의 이름과  id를 출력하는데, id는 오른쪽을 $로 채운 후 
--      20자리로 출력하고 동일한 학과의 학생의 이름과 id를 출력하는데, 학생의 id는 왼쪽#으로 채운 후 20자리로 출력하라.
SELECT NAME, RPAD(id, 20, '$')
FROM professor
WHERE deptno IN (101, 201, 301)
UNION ALL
SELECT NAME, LPAD(id, 20, '#')
FROM student
WHERE major1 IN (101, 201, 301)

-- 19. 2026년 1월 10일 부터 2026년 5월 20일까지 개월수를 반올림해서 정수 출력하기
SELECT ROUND(DATEDIFF('2026-05-20', '2026-01-10')/30)

-- 20. EMP 테이블에서 10번 부서원의 현재까지의 근무 월수를 계산하여  
-- 출력하여라.  
-- 근무월수 : 근무일수/30 반올림하여 정수로 출력하기
SELECT ROUND(DATEDIFF(NOW(), hiredate)/30) '근무 월수'
FROM emp
WHERE deptno = 10

-- 21. 학생의 이름과 지도교수번호 조회하기
--   지도교수가 없는 경우 지도교수배정안됨 출력하기
SELECT NAME, IFNULL(profno, '지도교수배정안됨')
FROM student

-- 22. major 테이블에서 코드, 코드명, build 조회하기
--   build 값이 없는 경우 '단독 건물 없음' 출력하기
SELECT CODE, name, IFNULL(build, '단독 건물 없음')
FROM major

-- 23. 학생의 이름, 전화번호, 지역명 조회하기
-- 지역명 : 지역번호가 02 : 서울, 031:경기, 032:인천 그외 기타지역
SELECT NAME, tel, if(LEFT(tel, INSTR(tel, ')') - 1) = 02, 
		 CONCAT(LEFT(tel, INSTR(tel, ')') - 1), ' : 서울'), if(LEFT(tel, INSTR(tel, ')') - 1) = 031,
		 CONCAT(LEFT(tel, INSTR(tel, ')') - 1), ' : 경기'), if(LEFT(tel, INSTR(tel, ')') - 1) = 032,
		 CONCAT(LEFT(tel, INSTR(tel, ')') - 1), ' : 인천'), '그 외 기타지역')))  지역명
FROM student
 

-- 24. 학생의 이름, 전화번호, 지역명 조회하기
-- 지역명 : 지역번호가 02,031,032: 수도권, 그외 기타지역
SELECT NAME, tel, if(LEFT(tel, INSTR(tel, ')') - 1) IN (02, 031, 032), 
		 CONCAT(LEFT(tel, INSTR(tel, ')') - 1), ' : 수도권'), '그 외 기타지역') 지역명
FROM student
 

-- 25. 학생을 3개 팀으로 분류하기 위해 학번을 3으로 나누어 
--   나머지가 0이면 'A팀', 
--   1이면 'B팀', 
--   2이면 'C팀'으로 
--   분류하여 학생번호, 이름, 학과번호, 팀 이름을 출력하여라
SELECT studno 학생번호, NAME 이름, major1 학과번호, if(studno%3=0, 'A팀', if(studno%3=1, 'B팀', 'C팀')) '팀 이름'
FROM student