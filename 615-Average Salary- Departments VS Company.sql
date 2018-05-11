-- Given two tables as below, write a query to display the comparison result (higher/lower/same) of the average salary of employees in a department to the company's average salary.
-- Table: salary
-- | id | employee_id | amount | pay_date   |
-- |----|-------------|--------|------------|
-- | 1  | 1           | 9000   | 2017-03-31 |
-- | 2  | 2           | 6000   | 2017-03-31 |
-- | 3  | 3           | 10000  | 2017-03-31 |
-- | 4  | 1           | 7000   | 2017-02-28 |
-- | 5  | 2           | 6000   | 2017-02-28 |
-- | 6  | 3           | 8000   | 2017-02-28 |
-- The employee_id column refers to the employee_id in the following table employee.
-- | employee_id | department_id |
-- |-------------|---------------|
-- | 1           | 1             |
-- | 2           | 2             |
-- | 3           | 2             |
-- So for the sample data above, the result is:
-- | pay_month | department_id | comparison  |
-- |-----------|---------------|-------------|
-- | 2017-03   | 1             | higher      |
-- | 2017-03   | 2             | lower       |
-- | 2017-02   | 1             | same        |
-- | 2017-02   | 2             | same        |
-- Explanation
-- In March, the company's average salary is (9000+6000+10000)/3 = 8333.33...
-- The average salary for department '1' is 9000, which is the salary of employee_id '1' since there is only one employee in this department. So the comparison result is 'higher' since 9000 > 8333.33 obviously.
-- The average salary of department '2' is (6000 + 10000)/2 = 8000, which is the average of employee_id '2' and '3'. So the comparison result is 'lower' since 8000 < 8333.33.
-- With he same formula for the average salary comparison in February, the result is 'same' since both the department '1' and '2' have the same average salary with the company, which is 7000.


# Write your MySQL query statement below

# method 1
SELECT
  LEFT(s.pay_date, 7) as pay_month,
  e.department_id,
  CASE
    WHEN (ROUND(AVG(s.amount), 4) > sub.cavg ) THEN 'higher'
    WHEN (ROUND(AVG(s.amount), 4) < sub.cavg ) THEN 'lower'
    ELSE 'same'
  END as comparison
FROM salary s
LEFT JOIN employee e ON s.employee_id = e.employee_id
LEFT JOIN (
    SELECT
      LEFT(pay_date, 7) as mon,
      ROUND(AVG(amount), 4) as cavg
    FROM salary
    GROUP BY mon
) sub ON LEFT(s.pay_date, 7) = sub.mon
GROUP BY pay_month, e.department_id
ORDER BY pay_month DESC, e.department_id


# method 2
# The idea is straightforward but need carefulness: first create two derived tables: one is (month, company_average) and the other is (month, dept, dept_average). Then, we join these two tables on month, and make selection base on our needs. It is super fast and beats 100%.
select group_average.pay_month, group_average.department_id, if(group_average.group_avg > company_average.comp_avg, "higher",
                                                        if(group_average.group_avg < company_average.comp_avg, "lower", "same"))
                                                        as comparison
from
(select pay_month, avg(amount) as comp_avg
from (select id, employee_id, amount, date_format(pay_date, "%Y-%m") as pay_month from salary) as tmp
group by pay_month) as company_average,
(select pay_month, department_id, avg(amount) as group_avg
from (select id, employee_id, amount, date_format(pay_date, "%Y-%m") as pay_month from salary) as s join employee e on s.employee_id = e.employee_id
group by pay_month, department_id) as group_average
where company_average.pay_month = group_average.pay_month


# method 3
SELECT d1.pay_month, d1.department_id,
CASE WHEN d1.department_avg > c1.company_avg THEN 'higher'
     WHEN d1.department_avg < c1.company_avg THEN 'lower'
     ELSE 'same'
END AS 'comparison'
FROM ((SELECT LEFT(s1.pay_date, 7) pay_month, e1.department_id, AVG(s1.amount) department_avg
FROM salary s1
JOIN employee e1 ON s1.employee_id = e1.employee_id
GROUP BY pay_month, e1.department_id) d1
LEFT JOIN (SELECT LEFT(pay_date, 7) pay_month, AVG(amount) company_avg
FROM salary
GROUP BY pay_month) c1 ON d1.pay_month = c1.pay_month)
ORDER BY pay_month DESC, department_id;


# method 4
select A.pay_m pay_month, A.department_id,IF(A.amt=B.amt,'same',if(A.amt>b.amt,'higher','lower') ) comparison from
(select pay_m, department_id, avg(amount) amt from (select *,left(pay_date,7) pay_m from
salary) S join employee E on S.employee_id = E.employee_id group by pay_m, department_id)   A
join
(select pay_m, avg(amount) amt from (select *,left(pay_date,7) pay_m from salary) T1 group by pay_m) B
on A.pay_m = B.pay_m
