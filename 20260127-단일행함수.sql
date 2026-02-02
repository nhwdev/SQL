/*
	함수
	단일행함수: 함수가 하나의 행(레코드)에서만 영향을 미침.
	그룹함수  : 여러행(레코드)에 관련된 기능을 처리. group by, having
*/
-- 문자관련 단일행 함수
-- 대소문자 변환 함수 : UPPER, LOWER
-- 학생의 전공1학과가 101인 학생의 이름, id, 대문자id, 소문자id 출력하기
SELECT NAME, id, UPPER(id), LOWER(id)
FROM student
WHERE major1 = 101

SELECT UPPER('Abc'), LOWER('Abc')
/*
	문자열 길이 : LENGTH, CHAR_LENGTH
	  LENGTH : 저장에 필요한 바이트 수. 한글 한글자는 3바이트. 오라클(LENGTHB)
	  CHAR_LENGTH : 문자열 길이.                               오라클(LENGTH)
	  
	  영문자, 숫자 : 바이트수와 문자열의 길이가 같음
	  한글 : 문자열 길이 * 3 = 바이트 수
	         한글을 저장하는 컬럼의 VARCHAR 자료형의 크기는 바이트(한글 글자수 * 3)로 설정
*/
-- 학생의 이름, id, 이름 글자수, 이름 바이트수, id 글자수, id 바이트수 출력하기
SELECT NAME, id, CHAR_LENGTH(NAME), LENGTH(NAME), CHAR_LENGTH(id), LENGTH(id)
FROM student

SELECT LENGTH('가나다라마바사아자차카타파하')
SELECT LENGTH('어여오요우유이')

/*
	문자열 연결함수 : CONCAT, 오라클 ||
*/
-- 교수의 이름과 직급을 연결하여 조회하기
SELECT CONCAT(NAME,' ',POSITION) 이름 FROM professor

-- 학생 정보를 홍길동 1학년 150cm 50kg 형태로 학생정보 출력하기
SELECT CONCAT(NAME,' ',grade,'학년 ',height,'cm ',weight,'kg') '학생 정보' 
FROM student
ORDER BY grade

/*
	부분문자열 : SUBSTR, LEFT, RIGTH
	SUBSTR(컬럼명/문자열, 시작인덱스) : 시작인덱스 이후 문자열
	SUBSTR(컬럼명/문자열, 시작인덱스, 글자수) : 시작인덱스 이후 글자수 만큼 부분 문자열
	LEFT(컬럼명/문자열, 글자수) : 왼쪽부터 글자수만큼 부분문자열 리턴
	RIGHT(컬럼명/무낮열, 글자수) : 오른쪽부터 글자수만큼 부분문자열로 리턴
*/
SELECT NAME, LEFT(NAME, 2), RIGHT(NAME,2), SUBSTR(NAME,1,2), SUBSTR(NAME,2)
FROM student

-- 학생의 이름과 주민번호 기준 생일 출력하기
SELECT NAME, jumin, LEFT(jumin, 6), SUBSTR(jumin, 1, 6)
FROM student

-- 문제
-- 1. 학생 중 생일이 3월인 학생의 이름, 생년월일 조회하기
--    생일은 주민번호 기준으로 한다.
SELECT NAME 이름, left(jumin, 6) 생년월일
FROM student
WHERE SUBSTR(jumin, 3, 2) = 03

-- 2. 학생의 이름, 학년, 생년월일 조회하기
--    생일은 주민번호 기준이고 형식을 99년 99월 99일로 한다.
--    월 기준 정렬하여 출력하기
SELECT NAME 이름, grade 학년, concat(LEFT(jumin, 2), '년 ', SUBSTR(jumin, 3, 2), '월 ', SUBSTR(jumin, 5, 2), '일') 생년월일
FROM student
ORDER BY SUBSTR(jumin, 3, 2)

/*
	문자열의 위치인덱스 : INSTR
	INSTR(컬럼/문자열, 문자) : 컬럼에서 문자의 위치인덱스 값을 리턴
*/
-- 학생의 이름, 전화번호, 전화번호에서 )의 위치값을 출력하기
SELECT NAME, tel, INSTR(tel,')'), INSTR('1234', '5') FROM student

-- 문제
-- 1. 학생의 이름, 전화번호, 지역번호 출력하기
--    지역번호 : 02, 031, ...
SELECT NAME 이름, tel 전화번호, LEFT(tel , INSTR(tel,')') - 1) 지역번호
FROM student

-- 2. 교수테이블에서 교수이름, url, HomePage 출력하기
--    HomePage : url 정보에서 http:// 이후의 문자열을 의미한다.
SELECT NAME 이름, URL "url", SUBSTR(URL, INSTR(URL, '://') + 3) HomePage
-- SELECT NAME 이름, URL "url", SUBSTR(URL, char_length('http//') + 1) HomePage
FROM professor
/*
	문자추가함수 : LPAD, RPAD
		LPAD(컬럼/문자열, 전체자리수, 추가문자) : 컬럼을 전체 자리수로 출력시, 빈자리는 왼쪽에 추가문자로 추가
		RPAD(컬럼/문자열, 전체자리수, 추가문자) : 컬럼을 전체 자리수로 출력시, 빈자리는 오른쪽에 추가문자로 추가
*/
-- 학생의 학번, 이름 출력하기
-- 학번은 10자리로 출력, 빈자리는 오른쪽에 *로 채우기
-- 이름은 10자리로 출력. 빈자리는 왼쪽에 #으로 채우기
SELECT RPAD(studno, 10, '*'), LPAD(NAME, 10, '#')
FROM student

/*
	문자 제거 함수 : TRIM, RTRIM, LTRIM
	TRIM(컬럼/문자열) : 양쪽의 공백 제거
	RTRIM(컬럼/문자열) : 오른쪽의 공백 제거
	LTRIM(컬럼/문자열) : 왼쪽의 공백 제거
	TRIM(LEADING/GRADILING/BOTH 변경할문자열 FROM 문자열)
		LEADING : 왼쪽 문자 제거
		TRAILING : 오른쪽 문자 제거
		BOTH : 양쪽 문자 제거
*/
SELECT CONCAT("***", TRIM("      양쪽 공백 제거      "), "***")
SELECT CONCAT("***", LTRIM("      왼쪽 공백 제거      "), "***")
SELECT CONCAT("***", RTRIM("      오른쪽 공백 제거      "), "***")

SELECT TRIM(LEADING '0' FROM '00123456700001230000')
SELECT TRIM(TRAILING '0' FROM '00123456700001230000')
SELECT TRIM(BOTH '0' FROM '00123456700001230000')

-- 교수테이블에서 교수이름, url, HomePage를 출력하기
-- HomePage는 url에서 http:// 이후를 의미한다.
SELECT NAME, URL, TRIM(LEADING 'http://' FROM URL) HomePage
FROM professor

/*
	문자치환함수 : REPLACE
	REPLACE(컬럼명, '문자1', '문자2') : 컬럼의 값 중 문자1을 문자2로 치환
*/
-- 학생의 이름중 성을 #으로 변경하여 출력하기
SELECT NAME, REPLACE(NAME, LEFT(NAME,1), '#')
FROM student

-- 학생의 이름중 두번째 문자를 #으로 변경하여 출력하기
SELECT NAME, REPLACE(NAME, SUBSTR(NAME, 2, 1), '#')
FROM student

-- 문제
-- 101학과 학생의 이름, 주민번호를 출력하기
-- 주민번호 뒤의 6자리는 ******로 출력하기
SELECT NAME 이름, concat(replace(jumin, RIGHT(jumin, 7), '-'),SUBSTR(jumin,7,1),'******') 주민번호
FROM student
WHERE major1 = 101

/*
	FIND_IN_SET : , 로 이루어진 문자열에서 그룹의 위치 리턴
	FIND_IN_SET(문자열, ',로 나누어진 문자열') : 문자열이 ,로 나누어진 문자열에서 그룹의 위치 리턴
*/
SELECT FIND_IN_SET('여행','독서,여행,요리')
SELECT FIND_IN_SET('등산','독서,여행,요리')

/*
	숫자 관련 함수
*/
/*
	반올림 함수 : ROUND
	 ROUND(숫자) : 소숫점 이하 첫번째 자리에서 반올림하여 정수형으로 출력
	 ROUND(숫자, 자리) : 소숫점 이하 자리수 + 1  에서 반올림하여 소숫점 이하 자릿수로 출력
	 							음수도 가능 : - 1 => 일의자리에서 반올림하여 10의자리까지 출력
*/
SELECT ROUND(12.3456, -1) r1, ROUND(12.3456) r2, ROUND(12.3456, 0) r3,
		 ROUND(12.3456, 1) r4, ROUND(12.3456, 2) r5, ROUND(12.3456, 3) r6
		 
/*
	버림함수 : TRUNCATE
	TRUNCATE(숫자, 자리수) : 숫자에서 자리수까지 출력. 이하는 버림.
*/
SELECT TRUNCATE(12.3456, -1) r1, TRUNCATE(12.3456, 0) r2, TRUNCATE(12.3456, 1) r3,
		 TRUNCATE(12.3456, 2) r4, TRUNCATE(12.3456, 3) r5

-- 교수의 급여를 15% 인상하여 정수로 출력하기
-- 교수의 이름, 현재급여, 반올림된 인상예상급여, 절삭된 인상예상급여 출력하기
SELECT NAME, salary, ROUND(salary*1.15), TRUNCATE(salary * 1.15, 0)
FROM professor

-- 문제
-- 점수테이블 (scroe)에서 학번(studno), 국어(kor), 수학(math), 영어(eng), 총점, 평균을 출력하기
-- 평균은 소수점 이하 2자리로 반올림하여 출력하기
-- 총점의 내림차순으로 정렬하기
SELECT studno 학번, kor 국어, math 수학, eng 영어, kor+math+eng 총점, ROUND((kor+math+eng)/3, 2) 평균
FROM score
ORDER BY kor+math+eng DESC

/*
	근사정수 : CEIL, FLOOR
		CEIL : 큰 근사정수
		FLOOR : 작은 근사정수
*/
SELECT CEIL(12.3456), FLOOR(12.3456), CEIL(-12.3456), FLOOR(-12.3456)

/*
	나머지 함수 : MOD, % 연산자 가능
	제곱함수 : POWER
	제곱근함수 : sqrt
*/
SELECT 21/8, MOD(21,8), 21%8, POWER(3,3), SQRT(9)

/*
	날짜 관련 함수
*/
/*
	현재 날짜
		NOW() : 현재 일시, 오라클 : SYSDATE
		CURDATE, CURRENT_DATE, CURRENT_DATE() : 현재날짜
*/
SELECT NOW(), CURDATE(), CURRENT_DATE, CURRENT_DATE()

-- 내일 날짜
SELECT CURDATE() + 1
-- 언제 날짜
SELECT CURDATE() - 1

/*
	날짜사이의 일수 리턴 : DATEDIFF()
*/
SELECT NOW(), '2026-01-01', DATEDIFF(NOW(), '2026-01-01')
SELECT DATEDIFF('2026-02-01', '2026-01-01')
SELECT DATEDIFF('2026-03-01', '2026-02-01')

-- 학생의 이름, 생일, 생일부터 현재까지의 일수 조회하기
SELECT NAME, birthday, DATEDIFF(NOW(), birthday)
FROM student

-- 문제
-- 학생의 이름, 생일, 현재 개월수, 나이를 출력하기
-- 개월수 : 일수 / 30 계산. 반올림하여 정수로 출력
-- 나이 : 일수 / 365 계산. 반올림하여 정수로 출력
SELECT NAME, birthday, ROUND(DATEDIFF(NOW(), birthday)/30, 0) 개월수,
		 ROUND(DATEDIFF(NOW(), birthday)/365) 나이
FROM student
-- 현웅이의 일수, 개월수
SELECT DATEDIFF(NOW(), '1995-03-08'), TRUNCATE(DATEDIFF(NOW(), '1995-03-08')/30, 0)

-- 날짜 데이터를 yyyy-MM-dd 형태의 문자열로 인식
-- 학생의 이름과 생년을 출력하기
SELECT NAME, SUBSTR(birthday, 1, 4) 생년,
				 SUBSTR(birthday,6,2) 생월,
				 SUBSTR(birthday, 9,2) 생일
FROM student
/*
	YEAR(날짜) : 년도 리턴
	MONTH(날짜) : 월 리턴
	DAY(날짜) : 일 리턴
	WEEKDAY(날짜) : 요일 리턴. 0:월 1:화 ... 6:일
	DAYOFWEEK(날짜) : 요일 리턴. 1:일 2:월 ... 7:토
	WEEK(날짜) : 일년기준 몇번째 주
	LAST_DAY(날짜) : 해당 월의 마지막 일자 리턴
*/
SELECT YEAR(NOW()),
		 MONTH(NOW()),
		 DAY(NOW()),
		 WEEKDAY(NOW()),
		 DAYOFWEEK(NOW()),
		 WEEK(NOW()),
		 LAST_DAY('26-02-01')
		 
-- 교수이름, 입사일(hiredate), 입사년도 휴가 보상일, 올해 휴가 보상일 출력하기
-- 휴가 보상일은 입사월의 마지막 일자
SELECT NAME, hiredate, Last_day(hiredate) "입사년도 휴가 보상일",
		 LAST_DAY(CONCAT(YEAR(NOW()), SUBSTR(hiredate,5))) "올해 휴가 보상일"
FROM professor

-- 교수 중 입사월의 1 ~ 3월인 교수의 급여를 15% 인상 예정임
-- 교수 이름, 현재 급여, 반올림 인상 급여, 급여 소급일 출력하기
-- 급여 소급일 : 올해 입사월의 마지막 일자
-- 인상 예정 교수만 출력하기
SELECT NAME '이름', salary '급여', ROUND(salary * 1.15) '인상 급여', LAST_DAY(CONCAT(YEAR(NOW()), SUBSTR(hiredate, 5))) '급여 소급일'
FROM professor
WHERE MONTH(hiredate) BETWEEN 1 AND 3
-- WHERE SUBSTR(hiredate,6,2) BETWEEN '01' AND '03'

/*
	DATE_ADD(날짜, 옵션) : 날짜 기준 이후
	DATE_SUB(날짜, 옵션) : 날짜 기준 이전
	옵션
	 YEAR : 년도
	 MONTH : 월
	 DAY : 일자
	 HOUR : 시간
	 MINUTE : 분
	 SECOND : 초
*/
-- 현재 시간 기준 1일 이후 날짜
SELECT NOW(), DATE_ADD(NOW(),INTERVAL 1 DAY)
-- 현재 시간 기준 1일 이전 날짜
SELECT NOW(), DATE_SUB(NOW(),INTERVAL 1 DAY)
-- 현재 시간 기준 1시간 이후 날짜
SELECT NOW(), DATE_ADD(NOW(),INTERVAL 1 HOUR)
-- 현재 시간 기준 1분 이후 날짜
SELECT NOW(), DATE_ADD(NOW(), INTERVAL 1 MINUTE)
-- 현재 시간 기준 1초 이후 날짜
SELECT NOW(), DATE_ADD(NOW(),INTERVAL 1 SECOND)
-- 현재 시간 기준 1달 이후 날짜
SELECT NOW(), DATE_ADD(NOW(), INTERVAL 1 MONTH)
-- 현재 시간 기준 1년 이후 날짜
SELECT NOW(), DATE_ADD(NOW(), INTERVAL 1 YEAR)

-- 현재기준 10일 이후의 일자와, 10일 이후의 일자의 해당월의 마지막 날짜 출력하기
SELECT NOW() '현재 날짜', DATE_ADD(NOW(), INTERVAL 10 DAY) '10일 이후 날짜' ,
		 LAST_DAY(DATE_ADD(NOW(), INTERVAL 10 DAY)) '10일 이후의 마지막 일자'

-- 교수번호, 이름, 입사일, 정식입사일 출력하기
-- 정식입사일 : 입사일 기준 3개월 이후로 한다.
SELECT NO, NAME, hiredate, DATE_ADD(hiredate, INTERVAL 3 MONTH) '정식 입사일'
FROM professor

-- 문제
-- emp 테이블에서 정식입사일은 입사일의 2개월 이후 다음달 1일로 한다.
-- 사원 번호, 이름, 입사일, 정식 입사일, 출력하기
SELECT empno, ename, hiredate, DATE_ADD(LAST_DAY(DATE_ADD(hiredate, INTERVAL 2 MONTH)), INTERVAL 1 DAY) '정식 입사일'
FROM emp

/*
	날짜관련 변환함수
	DATE_FORMAT : 날짜를 지정된 형식의 문자열로 변환
		DATE_FORMAT(날짜, pattern) => 날짜를 pattern에 맞는 문자열로 변환
	STR_TO_DATE : 지정된 형식의 문자열을 날짜형으로 변환
		STR_TO_DATE(형식화된 문자열, pattern) => 형식화 문자열을 pattern에 맞도록 인식해서 날짜로 변환
	
	사용되는 형식 문자
	%Y : 4자리 년도
	%y : 2자리 년도
	%M : 월 문자
	%m : 2자리 월
	%d : 2자리 일
	%H : 0 ~ 23시
	%h : 1 ~ 12시
	%i : 분
	%s : 초
	%p : AM / PM
	%W : 요일
	%a : 요일. 약자표시
*/
SELECT NOW(), DATE_FORMAT(NOW(), '%Y년 %m월 %d일 %H:%i:%s'), YEAR(NOW()) 년도1,
		 DATE_FORMAT(NOW(), '%Y') 년도2
-- 현재 일시 요일 출력하기
SELECT NOW(), DATE_FORMAT(NOW(), '%Y년 %m월 %d일 %H:%i:%s %W')
SELECT NOW(), DATE_FORMAT(NOW(), '%Y년 %m월 %d일 %H:%i:%s %a')
SELECT NOW(), DATE_FORMAT(NOW(), '%Y년 %m월 %d일 %h:%i:%s %a %p')
-- 한국어로 설정
SET lc_time_names = 'ko_KR' -- 한국에 맞도록 문자열 출력
SET lc_time_names = 'en_US'
SELECT NOW(), DATE_FORMAT(NOW(), '%Y년 %m월 %d일 %H:%i:%s %W')
SELECT NOW(), DATE_FORMAT(NOW(), '%y년 %M %d일 %h:%i:%s %a %p')

-- 문제
-- 2026-12-25일의 요일 출력하기
SELECT DATE_FORMAT(STR_TO_DATE('2026년 12월 25일','%Y년 %m월 %d일'), '%W'), 
		 STR_TO_DATE('2026년 12월 25일','%Y년 %m월 %d일')

-- 문제
-- 교수의 이름, 직책, 입사일, 정식입사일 출력하기
-- 정식 입사일은 입사일의 3개월 후.
-- 입사일, 정식입사일은 yyyy년 mm월 dd일의 형식으로 출력하기
SELECT NAME 이름, POSITION 직책, DATE_FORMAT(hiredate, '%Y년 %m월 %d일') 입사일, DATE_FORMAT(DATE_ADD(hiredate, INTERVAL 3 MONTH), '%Y년 %m월 %d일') '정식 입사일'
FROM professor
/*
	기타함수
	IFNULL(컬럼, 기본값) : 컬럼의 값이 NULL인 경우 기본값으로 대체.
*/
-- 교수의 이름, 직급, 급여, 보너스, 급여 + 보너스 출력하기
SELECT NAME, POSITION, salary, bonus, salary + bonus
FROM professor
-- => bonus가 NULL 인 경우 연사의 결과가 NULL임. 앞에서 UNION으로 처리
SELECT NAME, POSITION, salary, bonus, salary + bonus
FROM professor
WHERE bonus IS NOT NULL
UNION
SELECT NAME, POSITION, salary, bonus, salary
FROM professor
WHERE bonus IS NULL
-- IFNULL 함수로 구현하기
-- IFNULL(salary + bonus, salary) : salary + bonus의 결과가 NULL인 경우 salary 출력
SELECT NAME, POSITION, salary, IFNULL(bonus, 0), IFNULL(salary + bonus, salary)
FROM professor
SELECT NAME, POSITION, salary, IFNULL(bonus, 0), salary + IFNULL(bonus, 0)
FROM professor

-- 문제
-- 교수의 이름, 직급, 급여, 보너스를 출력하기
-- 단 보너스가 없는 경우 '보너스 없음' 으로 출력하기
SELECT NAME, POSITION, salary, IFNULL(bonus, '보너스 없음') bonus
FROM professor

/*
	조건 함수 : if, case
	  if(조건문, 참, 거짓) : 조건문의 결과가 참인경우 참, 거짓인 경우 거짓 실행
*/
-- 교수의 이름, 학과 번호, 학과명 출력하기
-- 학과명은 학과번호가 101이면, 컴퓨터 공학으로 나머지는 공란으로 출력하기
SELECT NAME, deptno, if(deptno = 101, '컴퓨터 공학', '') 학과명
FROM professor

-- 학과명은 학과번호가 101이면, 컴퓨터공학으로 나머지는 그외학과로 출력하기
SELECT NAME, deptno, if(deptno = 101, '컴퓨터 공학', '그 외 학과') 학과명
FROM professor

-- 학생의 주민번호 7번째 한자리의 값이 1인경우 남자, 2인 경우 여자로 성별을 출력하기
SELECT NAME, if(SUBSTR(jumin, 7, 1) = 1, '남자', '여자') 성별
FROM student

-- 학생의 주민번호 7번째 한자리의 값이 1인경우 남자, 2인 경우 여자로, 그외는 주빈번호 오류로 성별을 출력하기
SELECT NAME, if(SUBSTR(jumin, 7, 1) IN(1, 3), '남자', if(SUBSTR(jumin, 1) IN (2, 4), '여자', '주민번호 오류')) 성별
FROM student

-- 문제
-- 교수 이름, 학과 번호, 학과명 출력하기
-- 학과명 : 101 = 컴퓨터 공학, 102 = 멀티미디어 공학, 201 = 기계공학, 그외 : 그 외 학과
SELECT NAME, deptno, if(deptno = 101, '컴퓨터 공학', if(deptno=102, '멀티미디어 공학', if(deptno=201, '기계 공학', '그 외 학과'))) 학과명
FROM professor