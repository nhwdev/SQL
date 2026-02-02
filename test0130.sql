/*
1. 학생 테이블에서 전체 학생 중 4학년학생의 최소 체중보다 적은 학생의 이름과 몸무게 출력하기
*/
SELECT NAME, weight
FROM student
WHERE weight < (SELECT MIN(weight) FROM student WHERE grade = 4) 
/*
2. 교수 테이블에서 평균 연봉보다 많이 받는 교수들의 교수번호 이름, 연봉을 연봉이 높은 순으로 정렬. 
보너스가 없으면 0으로 계산함. 단 연봉은 (급여+보너스) *12 한 값이다.
*/
SELECT NO, NAME, salary + IFNULL(bonus, 0) * 12 연봉
FROM professor
WHERE (salary + IFNULL(bonus, 0) * 12) > (SELECT AVG(salary + IFNULL(bonus, 0) * 12) FROM professor)
ORDER BY 연봉 DESC
/*
3. 학년의 평균 몸무게가 70보다 큰 학년의 학년와 평균 몸무게 출력하기
*/
SELECT grade, AVG(weight)
FROM student
GROUP BY grade 
HAVING AVG(weight) > 70
/*
4. 학년별로 평균체중이 가장 적은 학년의 학년과 평균 체중을 출력하기
*/
SELECT grade, AVG(weight)
FROM student
GROUP BY grade
HAVING AVG(weight) = 
(SELECT MIN(avg_weight), grade FROM 
(SELECT grade, AVG(weight) avg_weight FROM student GROUP BY grade) a)

/*
5. 전공테이블(major)에서 공과대학(deptno=10)에 소속된  학과이름을 출력하기
*/
SELECT m1.name
FROM major m1, major m2
WHERE m1.part = m2.code AND m2.name = '공과대학'
/*
6. 공과대학에 소속된 모든 학생의 학번,이름, 학과번호, 학과명 출력하기
*/
SELECT s.studno,
       s.name,
       s.major1,
       c.name AS college_name
FROM student s
JOIN major m ON s.major1 = m.code
JOIN major c ON m.part = c.code
WHERE c.name = '공과대학';

/*
7 자신의 학과 학생들의 평균 몸무게 보다 몸무게가 적은   학생의 학번과,이름과, 학과번호, 몸무게를 출력하기
*/ 
/*
8 학번이 220212학생과 학년이 같고 키는  210115학생보다  큰 학생의 이름, 학년, 키를 출력하기
*/
/*
9 4학년학생 중 키가 제일 작은 학생보다  키가 큰 학생의 학번,이름,키를 출력하기
*/
/*
10학생 중에서 생년월일이 가장 빠른 학생의  학번, 이름, 생년월일을 출력하기
*/
/*
11 학년별  생년월일이 가장 빠른 학생의 학번, 이름, 생년월일,학과명을 출력하기
*/
/*
12 학과별 입사일 가장 오래된 교수의 교수번호,이름,입사일,학과명 조회하기
*/

/*
13 학년별로 평균키가 가장 적은 학년의  학년과 평균키를 출력하기
*/
/*
14 학생의 학번,이름,학년,키,몸무게,해당 학년의 최대키, 최대몸무게 조회하기
*/

/*
15. 교수번호,이름,부서코드,부서명,자기부서의 평균급여, 평균보너스 조회하기
 보너스가 없으면 0으로 처리한다.
*/

/*
16. 학년별 총점이 가장 큰 학생의 학번, 이름,학과코드,학과명,총점을 출력하기
*/