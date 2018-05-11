-- The Employee table holds all employees. The employee table has three columns: Employee Id, Company Name, and Salary.
--
-- +-----+------------+--------+
-- |Id   | Company    | Salary |
-- +-----+------------+--------+
-- |1    | A          | 2341   |
-- |2    | A          | 341    |
-- |3    | A          | 15     |
-- |4    | A          | 15314  |
-- |5    | A          | 451    |
-- |6    | A          | 513    |
-- |7    | B          | 15     |
-- |8    | B          | 13     |
-- |9    | B          | 1154   |
-- |10   | B          | 1345   |
-- |11   | B          | 1221   |
-- |12   | B          | 234    |
-- |13   | C          | 2345   |
-- |14   | C          | 2645   |
-- |15   | C          | 2645   |
-- |16   | C          | 2652   |
-- |17   | C          | 65     |
-- +-----+------------+--------+
-- Write a SQL query to find the median salary of each company. Bonus points if you can solve it without using any built-in SQL functions.
--
-- +-----+------------+--------+
-- |Id   | Company    | Salary |
-- +-----+------------+--------+
-- |5    | A          | 451    |
-- |6    | A          | 513    |
-- |12   | B          | 234    |
-- |9    | B          | 1154   |
-- |14   | C          | 2645   |
-- +-----+------------+--------+


# Write your MySQL query statement below

#method 1
SET @A = 0;
SET @B = 0;
SELECT MIN(T1.ID) AS ID, T1.COMPANY AS COMPANY, T1.SALARY
FROM (SELECT ID, COMPANY, SALARY, @A := @A + 1 AS VID FROM EMPLOYEE ORDER BY COMPANY ASC, SALARY ASC) T1,
     (SELECT ID, COMPANY, SALARY, @B := @B + 1 AS VID FROM EMPLOYEE ORDER BY COMPANY ASC, SALARY DESC) T2
WHERE (T1.VID = T2.VID OR T1.VID = T2.VID -1 OR T1.VID = T2.VID + 1) AND T1.ID = T2.ID
GROUP BY T1.COMPANY, T1.SALARY


# method 2
select t1.Id as Id, t1.Company, t1.Salary
from Employee as t1 inner join Employee as t2
on t1.Company = t2.Company
group by t1.Id
having abs(sum(CASE when t2.Salary<t1.Salary then 1
                  when t2.Salary>t1.Salary then -1
                  when t2.Salary=t1.Salary and t2.Id<t1.Id then 1
                  when t2.Salary=t1.Salary and t2.Id>t1.Id then -1
                  else 0 end)) <= 1
order by t1.Company, t1.Salary, t1.Id


# method 3
SELECT
  id,
  Company,
  Salary
FROM Employee e
WHERE 1 >= ABS((SELECT COUNT(*) FROM Employee e1 WHERE e.company = e1.company AND e.Salary >= e1.Salary) -
           (SELECT COUNT(*) FROM Employee e2 WHERE e.company = e2.company AND e.Salary <= e2.Salary))
GROUP BY Company, Salary


# method 4
SELECT
  sub.Id,
  sub.Company,
  sub.Salary
FROM (
    SELECT
        @rank := IF(@lastCompany = e.Company, @rank + 1, 1) as Rank,
        e.id,
        e.company,
        e.salary,
        fre.tot,
        @lastCompany := e.company
    FROM (SELECT @rank := 0, @lastCompany := 'A') SQLvars, Employee e
    LEFT JOIN ( SELECT e1.company, count(*) as tot FROM Employee e1 GROUP BY e1.company ) fre ON fre.company = e.company
    ORDER BY e.Company, e.Salary
) sub
WHERE sub.rank = sub.tot DIV 2 + 1 OR (sub.tot % 2 = 0 AND sub.rank = sub.tot DIV 2)


# method 5
select min(id) id, company, salary from (select a.id, a.company, a.salary from employee a, employee b
where a.company = b.company
group by a.company, a.salary,a.id having sum(sign(1-sign(a.salary-b.salary))) = floor((count(*)+1)/2) or sum(sign(1-sign(a.salary-b.salary))) = ceil((count(*)+1)/2) ) m group by company, salary
