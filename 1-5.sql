-- Problem 1
SELECT		d.deptno, CONCAT (d.deptname, '-', COUNT(e.empno)) AS "DEPT-EMPLOYEES"
FROM		department d JOIN employee e
	ON		d.deptno = e.workdept
GROUP BY	d.deptno, d.deptname
ORDER BY 	COUNT(e.empno);

-- Problem 2
SELECT		d.deptno, CONCAT(d.deptname, '-', d.mgrno) AS "DEPT-NAME-MGRNO", FORMAT(SUM(e.salary),2) AS "SUM-SALARY-DEPT"
FROM		department d JOIN employee e
	ON		d.deptno = e.workdept
GROUP BY 	d.deptno, e.salary
ORDER BY 	FORMAT(SUM(e.salary),2) DESC;

-- Problem 3
SELECT		d.deptno, d.deptname, COUNT(e.empno) AS "No. EMP", FORMAT(AVG(e.salary + COALESCE(e.bonus, 0) + COALESCE(e.comm, 0)), 2) AS "DEPT-AVG-INCOME" 
FROM		department d JOIN employee e
	ON		d.deptno = e.workdept
GROUP BY	d.deptno, d.deptname
HAVING		COUNT(e.empno) >= 4 
ORDER BY 	4 DESC;

-- Problem 4
SELECT		d.deptno, d.deptname, e.job, COUNT(*) AS "No. Analyst", 
		CASE
			WHEN FORMAT(AVG(e.edlevel), 0) = 12 THEN 'Twelve'
			WHEN FORMAT(AVG(e.edlevel), 0) = 13 THEN 'Thirteen'
			WHEN FORMAT(AVG(e.edlevel), 0) = 14 THEN 'Fourteen'
			WHEN FORMAT(AVG(e.edlevel), 0) = 15 THEN 'Fifteen'
			WHEN FORMAT(AVG(e.edlevel), 0) = 16 THEN 'Sixteen'
			WHEN FORMAT(AVG(e.edlevel), 0) = 17 THEN 'Seventeen'
			WHEN FORMAT(AVG(e.edlevel), 0) = 18 THEN 'Eighteen'
			WHEN FORMAT(AVG(e.edlevel), 0) = 19 THEN 'Nineteen'
		ELSE
			'Twenty'
		END AS "AVG-EDLEVEL",
		FORMAT(AVG(e.salary+e.bonus+e.comm),2) AS "DEPT-AVG-INCOME"
FROM		department d JOIN employee e
	ON		d.deptno = e.workdept
WHERE 		e.job = 'ANALYST'
GROUP BY	d.deptno, d.deptname, e.job;

        
-- Problem 5
 SELECT e.workdept, d.deptname AS "Workdept Name", e.gender AS Gender,
       FORMAT(AVG(e.salary), 'N2') AS "AVG-SALARY",
       FORMAT(AVG(e.bonus), 'N2') AS "AVG-BONUS",
       FORMAT(AVG(e.comm), 'N2') AS "AVG-COMM",
       COUNT(e.empno) AS "No. of EMP"
FROM EMPLOYEE e 
INNER JOIN DEPARTMENT d ON e.workdept = d.deptno
WHERE e.workdept LIKE '_1_'
GROUP BY e.workdept, d.deptname, e.gender
HAVING COUNT(e.empno) >= 3
ORDER BY 3;       
