-- HR DB 資料查詢
-- 查詢每個部門高於平均部門薪資的員工 (結果依部門平均薪資降冪排序)

-- 查詢每個部門平均薪資
-- FLOOR 去掉小數點
WITH DEP_AVG AS (
	SELECT DEPARTMENT_ID, FLOOR(AVG(SALARY)) "DEP_AVG_SALARY"
	FROM EMPLOYEES
	GROUP BY DEPARTMENT_ID
),
EMP AS(
	SELECT E.*,D.DEP_AVG_SALARY
    FROM EMPLOYEES AS E, DEP_AVG AS D
    WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID
    AND E.SALARY > D.DEP_AVG_SALARY
)
SELECT EMP.EMPLOYEE_ID,EMP.FIRST_NAME,EMP.SALARY,
	EMP.DEPARTMENT_ID,D.DEPARTMENT_NAME, EMP.DEP_AVG_SALARY
FROM EMP, DEPARTMENTS AS D
WHERE EMP.DEPARTMENT_ID=D.DEPARTMENT_ID
ORDER BY EMP.DEP_AVG_SALARY DESC, EMP.SALARY DESC;
	