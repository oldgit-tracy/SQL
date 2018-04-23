-- Write a SQL query to get the second highest salary from the Employee table.
--
-- +----+--------+
-- | Id | Salary |
-- +----+--------+
-- | 1  | 100    |
-- | 2  | 200    |
-- | 3  | 300    |
-- +----+--------+
-- For example, given the above Employee table, the query should return 200 as the second highest salary. If there is no second highest salary, then the query should return null.
--
-- +---------------------+
-- | SecondHighestSalary |
-- +---------------------+
-- | 200                 |
-- +---------------------+


# Write your MySQL query statement below

# method 1
# Select MAX(a.Salary) as SecondHighestSalary from Employee a
# where Salary < (Select MAX(b.Salary) from Employee b)

Select MAX(Salary) as SecondHighestSalary from Employee
where Salary < (Select MAX(Salary) from Employee)


# method 2
SELECT
    (SELECT DISTINCT
            Salary
        FROM
            Employee
        ORDER BY Salary DESC
        LIMIT 1 OFFSET 1)    # Change the number after ‘offset’ gives n-th highest salary
AS SecondHighestSalary

# method 3
select max(Salary) as SecondHighestSalary from Employee
where Salary < (select max(Salary) from Employee) order by Salary desc;

# method 4
SELECT distinct(Salary) as SecondHighestSalary FROM Employee UNION SELECT NULL ORDER BY SecondHighestSalary DESC LIMIT 1,1;

# method 5
SELECT Salary FROM Employee GROUP BY Salary
UNION ALL (SELECT null AS Salary)
ORDER BY Salary DESC LIMIT 1 OFFSET 1

# method 6
SELECT a.Salary AS SecondHighestSalary
FROM Employee a
WHERE 1 = (SELECT COUNT(*)
            FROM Employee b
            WHERE b.Salary > a.Salary)
UNION  ALL
SELECT NULL
LIMIT 1
