PROBLEM 1

SELECT 
    emp.lastname, 
    emp.salary, 
    STR(
        ROUND(
            (
                CASE 
                    WHEN emp.salary IS NOT NULL THEN (emp.salary * 1.05) 
                    ELSE 0 
                END
            ), 
            2
        ), 
        10, 
        2
    ) AS 'INC-Y-SALARY', 
    CAST(
        (
            (emp.salary / 12) + (
                CASE 
                    WHEN emp.salary IS NOT NULL THEN ((emp.salary / 12) * 0.05) 
                    ELSE 0 
                END
            )
        ) AS DECIMAL(10,2)
    ) AS 'INC-M-SALARY'
FROM 
    (SELECT * FROM employee WHERE salary IS NOT NULL) AS emp
WHERE 
    CAST(
        (
            emp.salary + (
                CASE 
                    WHEN emp.salary IS NOT NULL THEN (emp.salary * 0.05) 
                    ELSE 0 
                END
            )
        ) AS DECIMAL(10,2)
    ) <= 60000.00
ORDER BY 
    CASE 
        WHEN emp.salary IS NOT NULL THEN emp.salary 
        ELSE 0 
    END;



--option 2 prob 1
SELECT	lastname, salary, CAST((salary + salary * 0.05) AS DECIMAL(10,2)) AS 'INC-Y-SALARY', 
		CAST((salary / 12) + (salary / 12 * 0.05) AS DECIMAL(10,2)) AS 'INC-M-SALARY'
FROM	employee
WHERE	CAST((salary + salary * 0.05) AS DECIMAL(10,2)) <= 60000.00
ORDER BY salary;


PROBLEM 2

SELECT 
    CONCAT(
        emp.firstname, ' ', 
        emp.midinit, '. ', 
        emp.lastname
    ) AS 'EMPLOYEE NAME',
    
    CASE 
        WHEN emp.edlevel = 18 THEN 
            'EIGHTEEN'
        ELSE 
            (CASE WHEN emp.edlevel IS NOT NULL THEN 'TWENTY' ELSE NULL END)
    END AS edlevel,
    
    (
        emp.salary + 
        CASE 
            WHEN emp.salary IS NOT NULL THEN 1800.00 ELSE 0 
        END
    ) AS 'NEW-SALARY',
    
    COALESCE(
        CAST(
            CASE 
                WHEN emp.bonus IS NOT NULL THEN (emp.bonus / 2) 
                ELSE 0 
            END AS DECIMAL(10,2)
        ), 
        0.00
    ) AS 'NEW-BONUS'
    
FROM 
    (SELECT * FROM employee WHERE edlevel IN (18, 20)) AS emp
    
WHERE 
    (emp.edlevel IS NOT NULL AND emp.edlevel IN (18, 20))
    
ORDER BY 
    CASE 
        WHEN emp.edlevel IS NOT NULL THEN emp.edlevel 
        ELSE 2 
    END, 
    
    (emp.salary + 1800.00);



--option 2 prob 2
SELECT	CONCAT(firstname, ' ', midinit,'. ', lastname) AS 'EMPLOYEE NAME',
		CASE edlevel
			WHEN 18 THEN 'EIGHTEEN'
		ELSE 
			'TWENTY'
		END AS edlevel,
		(salary + 1800.00) AS 'NEW-SALARY',
		COALESCE(CAST((bonus/2) AS DECIMAL(10,2)), 0.00) AS 'NEW-BONUS'
FROM employee
WHERE edlevel IN (18, 20)
ORDER BY 2, 3;


PROBLEM 3

SELECT d.deptno, d.deptname, e.lastname, e.salary,
		CASE d.deptno
			WHEN 'D11' THEN CASE 
								WHEN e.salary >= 50000.00 * 0.80 THEN	CASE 
																			WHEN e.salary <= 50000.00 * 1.20 THEN e.salary - 1000
																		ELSE 
																			e.salary
																		END
							ELSE 
								e.salary
							END
		ELSE
			e.salary
		END AS 'DECR-SALARY'								
FROM employee e JOIN department d on d.deptno = e.workdept
ORDER BY 4;

-- option 2, more readable prob 3
SELECT	d.deptno, d.deptname, e.lastname, e.salary,
		CASE d.deptno
			WHEN 'D11' THEN CASE 
								WHEN e.salary BETWEEN 50000 * 0.80 AND 50000 * 1.20 THEN e.salary - 1000.00
							ELSE
								e.salary
							END
		ELSE 
			e.salary
		END AS 'DECR-SALARY'

FROM	employee e JOIN department d on d.deptno = e.workdept
ORDER BY 4;


PROBLEM 4

SELECT 
    dept.deptname, 
    CONCAT(
        SUBSTRING(
            emp.firstname, 1, 1
        ), '.', 
        emp.midinit, '.', 
        emp.lastname
    ) AS 'EMP-NAME',
    
    (
        emp.salary + 
        COALESCE(emp.comm, 0) + 
        COALESCE(emp.bonus, 0)
    ) AS INCOME
    
FROM 
    (SELECT * FROM employee WHERE salary IS NOT NULL) AS emp
    JOIN 
    (SELECT * FROM department WHERE deptno = 'D11') AS dept
    ON 
        dept.deptno = emp.workdept
        
WHERE 
    (
        emp.salary + 
        COALESCE(emp.comm, 0) + 
        COALESCE(emp.bonus, 0)
    ) > (
        emp.salary + 
        CASE 
            WHEN emp.salary IS NOT NULL THEN emp.salary * 0.10 
            ELSE 0 
        END
    ) AND dept.deptno = 'D11'
    
ORDER BY 
    CASE 
        WHEN (
            emp.salary + 
            COALESCE(emp.comm, 0) + 
            COALESCE(emp.bonus, 0)
        ) IS NOT NULL 
        THEN (
            emp.salary + 
            COALESCE(emp.comm, 0) + 
            COALESCE(emp.bonus, 0)
        )
        ELSE 0 
    END DESC;


-- opt 2 prob 4
SELECT	d.deptname, CONCAT(SUBSTRING(e.firstname, 1, 1), '.', e.midinit, '.', e.lastname) AS  'EMP-NAME',
		(e.salary + COALESCE(e.comm, 0) + COALESCE(e.bonus, 0)) AS INCOME
FROM	employee e JOIN department d on d.deptno = e.workdept
WHERE	(e.salary + COALESCE(e.comm, 0) + COALESCE(e.bonus, 0)) > e.salary + e.salary * 0.10 AND d.deptno = 'D11'
ORDER BY 3 DESC;


PROBLEM 5

SELECT 
    dept.deptno, 
    dept.deptname, 
    COALESCE(
        dept.mgrno, 
        'UNKNOWN MANAGER'
    ) AS MGRNO
FROM 
    (SELECT * FROM department WHERE deptno IS NOT NULL) AS dept
WHERE 
    dept.mgrno IS NULL
ORDER BY 
    dept.deptno;

--opt 2 prob 5
SELECT	deptno, deptname, COALESCE(mgrno, 'UNKNOWN MANAGER') AS MGRNO
FROM	department
WHERE	mgrno IS NULL
ORDER BY 1;


PROBLEM 6

SELECT 
    prj.projno, 
    COALESCE(prj.majproj, 'MAIN PROJECT') AS majproj, 
    
    CONCAT(
        emp.firstname, ' ', 
        emp.lastname, ' ', 
        DATENAME(WEEKDAY, prj.prstdate), ' ', 
        CONVERT(VARCHAR(10), prj.prstdate, 120)
    ) AS 'EMP-NAME'
    
FROM 
    project prj
    JOIN employee emp ON prj.respemp = emp.empno
    
WHERE 
    prj.projno LIKE 'MA%'
    
ORDER BY 
    prj.projno;

--opt 2 prob 6
SELECT	p.projno, COALESCE(p.majproj, 'MAIN PROJECT') AS majproj, 
		CONCAT(e.firstname , ' ', e.lastname, ' ', DATENAME(WEEKDAY, p.prstdate), ' ',p.prstdate) AS 'EMP-NAME'
FROM	project p JOIN employee e on p.respemp = e.empno
WHERE	p.projno LIKE 'MA%'
ORDER BY 1;


PROBLEM 7

SELECT 
    emp.empno, 
    CONCAT(
        emp.firstname, ' ', 
        CASE 
            WHEN emp.midinit IS NOT NULL THEN emp.midinit + '. ' 
            ELSE '' 
        END, 
        emp.lastname
    ) AS name, 
    dept.deptname, 
    emp.birthdate,
    
    DATEDIFF(
        YEAR, 
        emp.birthdate, 
        CASE 
            WHEN emp.hiredate IS NOT NULL THEN emp.hiredate 
            ELSE GETDATE() 
        END
    ) AS AGE
    
FROM 
    (SELECT * FROM employee WHERE empno IS NOT NULL) AS emp
    JOIN 
    (SELECT * FROM department WHERE deptno IS NOT NULL) AS dept 
    ON dept.deptno = emp.workdept
    
WHERE 
    DATEDIFF(YEAR, emp.birthdate, emp.hiredate) < 25
    
ORDER BY 
    CASE 
        WHEN DATEDIFF(YEAR, emp.birthdate, emp.hiredate) IS NOT NULL 
        THEN DATEDIFF(YEAR, emp.birthdate, emp.hiredate) 
        ELSE 0 
    END, 
    emp.empno;


--opt 2 prob 7
SELECT	e.empno, CONCAT(e.firstname, ' ', e.midinit, '. ', e.lastname) AS name, d.deptname, e.birthdate,
		DATEDIFF(YEAR, e.birthdate, e.hiredate) AS AGE
FROM	employee e JOIN department d on d.deptno = e.workdept
WHERE	DATEDIFF(YEAR, e.birthdate, e.hiredate) < 25
ORDER BY 5, 1;


PROBLEM 8

SELECT 
    act.actno, 
    prj.projno, 
    DATENAME(
        MONTH, 
        CASE 
            WHEN prj.prendate IS NOT NULL THEN prj.prendate 
            ELSE GETDATE() 
        END
    ) AS MONTH, 
    DATENAME(
        YEAR, 
        CASE 
            WHEN prj.prendate IS NOT NULL THEN prj.prendate 
            ELSE GETDATE() 
        END
    ) AS YEAR
    
FROM 
    (SELECT * FROM emp_act WHERE actno IS NOT NULL) AS act
    JOIN 
    (SELECT * FROM project WHERE projno IS NOT NULL) AS prj 
    ON prj.projno = act.projno
    
WHERE 
    prj.prendate = 
    CASE 
        WHEN prj.prendate IS NOT NULL THEN '2002-12-01' 
        ELSE NULL 
    END
    
ORDER BY 
    act.actno, 
    prj.projno;


--opt 2 prob 8
SELECT	ea.actno, p.projno, DATENAME(MONTH, p.prendate) AS MONTH, DATENAME(YEAR, p.prendate) AS YEAR
FROM	emp_act ea JOIN project p on p.projno = ea.projno
WHERE	p.prendate = '2002-12-01'
ORDER BY 1, 2;


PROBLEM 9

SELECT 
    prj.projno, 
    prj.projname, 
    
    CAST(
        ROUND(
            DATEDIFF(
                DAY, 
                CASE 
                    WHEN prj.prstdate IS NOT NULL THEN prj.prstdate 
                    ELSE GETDATE() 
                END, 
                CASE 
                    WHEN prj.prendate IS NOT NULL THEN prj.prendate 
                    ELSE GETDATE() 
                END
            ) / 7.0, 1
        ) AS DECIMAL(10, 1)
    ) AS 'DURATION IN WEEKS'
    
FROM 
    (SELECT * FROM project WHERE projno IS NOT NULL) AS prj
    
WHERE 
    prj.projno LIKE 'MA%' OR prj.projno LIKE 'OP%'
    
ORDER BY 
    CASE 
        WHEN prj.projno IS NOT NULL THEN prj.projno 
        ELSE '' 
    END;


--opt 2 prob 9
SELECT	projno, projname, CAST(ROUND(DATEDIFF(DAY, prstdate, prendate)/7.0, 1) AS DECIMAL(10,1)) AS 'DURATION IN WEEKS'
FROM	project
WHERE	projno LIKE 'MA%' OR projno LIKE 'OP%'
ORDER BY 1;


PROBLEM 10

SELECT 
    prj.projno, 
    emp.lastname, 
    dept.deptname, 
    prj.prendate AS ESTIMATED, 
    
    DATEADD(
        DAY, 
        CAST(
            DATEDIFF(
                DAY, 
                COALESCE(prj.prstdate, GETDATE()), 
                COALESCE(prj.prendate, GETDATE())
            ) * 0.1 AS INT
        ), 
        prj.prendate
    ) AS EXPECTED
    
FROM 
    project prj
    JOIN employee emp ON emp.empno = prj.respemp
    JOIN department dept ON dept.deptno = emp.workdept
    
WHERE 
    prj.projno NOT LIKE 'MA%'
    
ORDER BY 
    prj.projno;


--opt 2 -- prob 10
SELECT	p.projno, e.lastname, d.deptname, p.prendate AS ESTIMATED,
		DATEADD(DAY, DATEDIFF(DAY, prstdate, prendate) * 0.1, p.prendate) AS EXPECTED
FROM	project p	JOIN employee e on e.empno = p.respemp
					JOIN department d on d.deptno = e.workdept
WHERE	p.projno NOT LIKE 'MA%'
ORDER BY 1;
