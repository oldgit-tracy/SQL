-- The Employee table holds the salary information in a year.
--
-- Write a SQL to get the cumulative sum of an employee's salary over a period of 3 months but exclude the most recent month.
--
-- The result should be displayed by 'Id' ascending, and then by 'Month' descending.
--
-- Example
-- Input
--
-- | Id | Month | Salary |
-- |----|-------|--------|
-- | 1  | 1     | 20     |
-- | 2  | 1     | 20     |
-- | 1  | 2     | 30     |
-- | 2  | 2     | 30     |
-- | 3  | 2     | 40     |
-- | 1  | 3     | 40     |
-- | 3  | 3     | 60     |
-- | 1  | 4     | 60     |
-- | 3  | 4     | 70     |
-- Output
--
-- | Id | Month | Salary |
-- |----|-------|--------|
-- | 1  | 3     | 90     |
-- | 1  | 2     | 50     |
-- | 1  | 1     | 20     |
-- | 2  | 1     | 20     |
-- | 3  | 3     | 100    |
-- | 3  | 2     | 40     |
-- Explanation
-- Employee '1' has 3 salary records for the following 3 months except the most recent month '4': salary 40 for month '3', 30 for month '2' and 20 for month '1'
-- So the cumulative sum of salary of this employee over 3 months is 90(40+30+20), 50(30+20) and 20 respectively.
--
-- | Id | Month | Salary |
-- |----|-------|--------|
-- | 1  | 3     | 90     |
-- | 1  | 2     | 50     |
-- | 1  | 1     | 20     |
-- Employee '2' only has one salary record (month '1') except its most recent month '2'.
-- | Id | Month | Salary |
-- |----|-------|--------|
-- | 2  | 1     | 20     |
-- Employ '3' has two salary records except its most recent pay month '4': month '3' with 60 and month '2' with 40. So the cumulative salary is as following.
-- | Id | Month | Salary |
-- |----|-------|--------|
-- | 3  | 3     | 100    |
-- | 3  | 2     | 40     |

# Write your MySQL query statement below

# method 1
select E1.id, E1.month, (ifnull(E1.salary,0) +ifnull(E2.salary,0) + ifnull(E3.salary,0)) as Salary  from
(Select id,max(month) as month from Employee group by id having count(*) > 1) as maxmonth
left Join Employee E1 on (maxmonth.id = E1.id and maxmonth.month > E1.month)
left Join Employee E2 on (E1.id = E2.id and E1.month = E2.month + 1)
left Join Employee E3 on (E1.id = E3.id and E1.month = E3.month + 2)
Order by id ASC, month DESC


# method 2
select e1.id as Id, e1.month as Month, sum(if(e2.month in (e1.month, e1.month - 1, e1.month - 2), e2.salary, 0)) as Salary
from employee e1, employee e2, (select id, max(month) as maxmonth from employee group by id) as mm
where e1.id = e2.id and e1.id = mm.id and e1.month != mm.maxmonth
group by e1.id, e1.month
order by id asc, month desc

# method 3
SELECT f1.Id Id, f1.month Month, IFNULL(f1.salary, 0) + IFNULL(f2.salary, 0) + IFNULL(f3.salary, 0) as Salary
FROM Employee f1 LEFT JOIN Employee f2 ON f1.month-1 = f2.month AND f1.Id = f2.Id
                 LEFT JOIN Employee f3 ON f1.month -2 = f3.month AND f1.Id = f3.Id
WHERE (f1.Id, f1.month) NOT IN (select Id, max(month)
                              from Employee
                              group by Id)
ORDER BY Id, Month DESC;
