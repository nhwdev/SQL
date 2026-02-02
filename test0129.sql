/*
1. 1학년 학생의 학번,이름, score 테이블에서 학번에 해당하는 점수를 조회하기
   학번순으로 정렬하여 출력하기
*/
SELECT s1.studno, s1.name, s2.kor, s2.math, s2.eng
FROM student s1, score s2
WHERE s1.studno = s2.studno AND s1.grade = 1
ORDER BY s1.studno
/*
2. 교수의 이름, 입사일,학과코드,학과명을 출력하기 
  입사일 순으로 정렬하여 출력하기
*/
SELECT p.name, p.hiredate, p.deptno, m.name
FROM professor p, major m
WHERE p.deptno = m.code
ORDER BY p.hiredate
/*
3. 4학년 학생의 이름 학과번호, 학과이름 출력하기
*/
SELECT s.name, s.studno, m.name
FROM student s, major m
WHERE s.major1 = m.code AND grade = 4
/*
4. 성이 김씨인 학생들의 이름, 학과이름 학과위치 출력하기
*/
SELECT s.name, m.name, m.build
FROM student s, major m
WHERE s.major1 = m.code AND s.name LIKE '김%'
/*
5. 김태훈 학생의 학번, 이름, 국어,영어,수학 총점을 출력하기
*/
SELECT s1.studno, s1.name, s2.kor, s2.eng, s2.math, s2.kor+s2.eng+s2.math 총점
FROM student s1, score s2
WHERE s1.studno = s2.studno AND s1.name = '김태훈'
/*
6. 학번과 학생이름, 소속학과이름을 학생 이름순으로 정렬하여 출력
*/
SELECT s.studno, s.name, m.name
FROM student s, major m
WHERE s.major1 = m.code
ORDER BY s.name
/*
7.  학과명과 학과별 교수의 급여합계 ,보너스합계 , 급여평균 ,보너스평균 출력하기
   단 보너스가 없는 경우는 0으로 처리함.
   평균 출력시 소숫점2자리로 반올림 하여 출력하기
*/
SELECT m.name 학과명, sum(p.salary) 급여합계, SUM(IFNULL(p.bonus, 0)) 보너스합계, ROUND(AVG(p.salary), 2) 급여평균, ROUND(AVG(IFNULL(p.bonus, 0)), 2) 보너스평균
FROM professor p, major m
WHERE p.deptno = m.code
GROUP BY m.name
/*
8. 지도 교수가 지도하는 지도교수명과, 학생의 인원수를 출력하기.
*/
SELECT p.name, COUNT(*)
FROM professor p, student s
WHERE p.no = s.profno
GROUP BY p.name
/*
9. 지도 교수가 지도하는  학생의 인원수가 2명이상인 지도교수 이름를 출력하기.
*/
SELECT p.name
FROM professor p, student s
WHERE p.no = s.profno
GROUP BY p.name
HAVING COUNT(*) >= 2
/*
10. 지도 교수가 지도하는 학생의 인원수가 2명이상인 지도교수 번호,이름,학과코드,학과명 출력하기.
*/
SELECT p.no, p.name, p.deptno, m.name
FROM professor p, student s, major m
WHERE p.no = s.profno AND m.code = p.deptno
GROUP BY p.name
HAVING COUNT(*) >= 2
/*
11. 사원정보에서 상사의 이름,상사의 직급, 하위직원의 인원수를 출력하기. 하위직원이 많은 사람 순으로 정렬하여 출력하기
*/
SELECT p2.ename, p2.job, COUNT(*)
FROM emp p1, emp p2
WHERE  p1.mgr = p2.empno
GROUP BY p2.ename
ORDER BY COUNT(*) DESC
/*
12. 학생의 이름과 지도교수 이름 조회하기. 
  지도 교수가 없는 학생과 지도 학생이  없는 교수도 조회하기
   단 지도교수가 없는 학생의 지도교수는  '0000' 으로 출력하고
   지도 학생이 없는 교수의 지도학생은 '****' 로 출력하기
*/
SELECT ifnull(s.name, '****'), IFNULL(p.name, '0000')
FROM student s RIGHT OUTER JOIN professor p
ON s.profno = p.no
UNION
SELECT ifnull(s.name, '****'), IFNULL(p.name, '0000')
FROM student s LEFT OUTER JOIN professor p
ON s.profno = p.no
/*
13. 지도 교수가 지도하는 학생의 인원수를 출력하기.
   단 지도학생이 없는 교수의 인원수 0으로 출력하기
   지도교수번호, 지도교수이름, 지도학생인원수를 출력하기
*/
SELECT p.no, p.name, COUNT(s.profno)
FROM professor p LEFT OUTER JOIN student s
on p.no = s.profno
GROUP BY p.name
/*
14.교수 중 지도학생이 없는 교수의 번호,이름, 학과번호, 학과명 출력하기
*/
SELECT p.no, p.name, p.deptno, m.name
FROM professor p LEFT OUTER JOIN student s
ON p.no = s.profno JOIN major m ON p.deptno = m.code
GROUP BY p.name
HAVING COUNT(s.profno) = 0
/*
15. emp 테이블에서 사원번호, 사원명,직급,  상사이름, 상사직급 출력하기
  모든 사원이 출력되어야 한다.
   상사가 없는 사원은 상사이름을 '상사없음'으로  출력하기
*/
SELECT e2.empno 사원번호, e2.ename 사원명, e2.job 직급, IFNULL(e1.ename, '상사') 상사이름, IFNULL(e1.job, '없음') 상사직급
FROM emp e1 Right OUTER JOIN emp e2
ON e1.empno = e2.mgr