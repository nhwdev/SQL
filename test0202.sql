/*
1. 학생 테이블에서 1학년 학생들만 student1 테이블로 생성하기
필요컬럼 : 학번,이름,전공1학과코드, 학과명
*/
CREATE TABLE student1 
AS 
SELECT s.studno, s.NAME, s.major1, m.name code
FROM student s, major m
WHERE s.major1 = m.code AND s.grade = 1

SELECT * FROM student1
/*
2. test11 테이블 생성하기
컬럼 : seq : 숫자,기본키,자동증가
       name : 문자형 20문자
       birthday : 날짜만
*/
CREATE TABLE test11 (
seq INT PRIMARY KEY AUTO_INCREMENT,
NAME VARCHAR(20),
birthday DATE
)

DESC test11
/*
3. 테이블 test12를 생성하기. 
   컬럼은 정수형인 no 가 기본키로 
   name 문자형 20자리
   tel 문자형 20 자리
  addr 문자형 100자리로 기본값을 서울시 금천구로 설정하기
*/
CREATE TABLE test12 (
NO INT PRIMARY KEY,
NAME VARCHAR(20),
tel VARCHAR(20),
addr VARCHAR(100) DEFAULT '서울시 금천구'
)

DESC test12
/*
4. 교수 테이블로 부터 102 학과 교수들의 
번호, 이름, 학과코드, 급여, 보너스, 직급만을 컬럼으로
가지는 professor_102 테이블을 생성하기
*/
CREATE TABLE professor_102
AS
SELECT NO, NAME, deptno, salary, bonus, POSITION
FROM professor
WHERE deptno = 102

SELECT * FROM professor_102
/*
5.  2학년 학생의 학번,이름, 국어,영어,수학 값을 가지는 score2 테이블 생성하기
*/
CREATE TABLE score2
AS
SELECT s1.studno, s1.NAME, s2.kor, s2.eng, s2.math
FROM student s1, score s2
WHERE s1.studno = s2.studno AND s1.grade = 2
/*
6.교수번호,교수이름,직급, 학과코드,학과명 컬럼을 가진 테이블 professor_201을 생성하여
    201학과에 속한 교수들의 정보를 저장하기
*/
CREATE TABLE professor_201
AS
SELECT p.NO, p.NAME, p.POSITION, p.deptno, m.name code
FROM professor p, major m
WHERE p.deptno = m.code AND p.deptno = 201

SELECT * FROM professor_201
/*

create table address (
  id varchar(10),
  addr varchar(100),
  email varchar(100)
);
desc address

7. 주소록테이블에 날짜 타입을 가지는 birth 컬럼을 추가하라

8. 주소록 테이블에 문자 타입을 가지는 comments컬럼을 추가하라
단 기본값은 'no Comment'로 설정하라


9. 주소록 테이블에서 comments컬럼을 삭제하라
*/
-- 7
ALTER TABLE address ADD birth DATE
DESC address
-- 8
ALTER TABLE address ADD comments VARCHAR(50) DEFAULT 'no Comment'
-- 9
ALTER TABLE address DROP comments
/*
create table member(
 USERID varchar(10),
 USERNAME varchar(10),
 PASSWD varchar(10),
 PHONE varchar(13),
 ADDRESS varchar(20),
 REGDATE datetime);


10. 회원테이블에 email 컬럼을 추가하라 단 email 컬럼의 타입은 varchar(50) 이다

11. 회원 테이블에 국적을 나타내는 country 칼럼을 추가하고 기본값은 'Korea'로 지정하여라

12. 회원 테이블에서 email 칼럼을 삭제하여라

13. 회원 테이블의 address 칼럼의 데이터 크기를 30으로 증가시켜라

14. member 테이블의 userid를 기본키로 등록하기

15. member 테이블의 userid에 등록된 회원만 address 테이블의  id 컬럼에 등록되도록 제약 조건을 등록하기

16. member테이블과 address 에 등록된 제약조건을 조회하기
*/​
-- 10
ALTER TABLE MEMBER ADD email VARCHAR(50)
-- 11
ALTER TABLE MEMBER ADD country VARCHAR(50) DEFAULT 'korea'
-- 12
ALTER TABLE MEMBER DROP email
-- 13
ALTER TABLE MEMBER MODIFY address VARCHAR(30)
-- 14
ALTER TABLE MEMBER ADD CONSTRAINT PRIMARY KEY (userid)
-- 15
ALTER TABLE address ADD CONSTRAINT FOREIGN KEY (id) REFERENCES MEMBER(userid)
-- 16
USE information_schema
SELECT * FROM Table_CONSTRAINTS
WHERE TABLE_NAME = 'address'
SELECT * FROM TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'MEMBER'

/*
17. 사원테이블에 사원번호:3001, 이름:홍길동, 직책:사외이사, 
  급여:100, 부서:10, 입사일:오늘인 레코드 등록하기 -> 컬럼명 지정
*/
INSERT INTO emp (empno, ename, job, salary, deptno, hiredate) VALUES (3001, '홍길동', '사외이사', 100, 10, NOW())
/*
18. 사원테이블에 사원번호:3002, 이름:홍길동, 직책:사외이사, 
  급여:100, 부서:10, 입사일:오늘인 레코드 등록하기 -> 컬럼명 지정안함
*/
SELECT * FROM emp
INSERT INTO emp VALUES (3002, '홍길동', '사외이사', NULL, NULL, NOW(), 100, NULL,  10)
/*
19. student 테이블과 같은 컬럼을 가진 테이블 stud_male 테이블 생성하기.
    student 데이터 중 남학생 정보만 stud_male 테이블에 저장하기
   성별은 주민번호를 기준으로 한다.
*/
CREATE TABLE stud_male 
AS
SELECT *
FROM student
WHERE SUBSTR(jumin,7,1) IN (1, 3) 

SELECT * FROM stud_male
/*
20. 박인숙 교수와 같은 조건으로 오늘 입사한 이몽룡 교수 추가하기
   교수번호 : 6003,이름:이몽룡,입사일:오늘,id:monglee
   나머지 부분은 박인숙 교수 정보와 같다.
*/
INSERT INTO professor (NO, NAME, id, POSITION, salary, hiredate, bonus, deptno, email, URL)
SELECT 6003, '이몽룡', 'mongLee', POSITION, salary, NOW(), bonus, deptno, email, URL
FROM professor
WHERE NAME = '박인숙'
/*
21. major 테이블에서  major_10 테이블에 공과대학에 속한 학과 정보만 추가하기
*/
CREATE TABLE major_10
AS
SELECT m2.*
FROM major m1, major m2
WHERE m1.code = m2.part AND m1.`name` = '공과대학'

SELECT * FROM major_10