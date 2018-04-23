-- The Employee table holds all employees including their managers. Every employee has an Id, and there is also a column for the manager Id.
--
-- +----+-------+--------+-----------+
-- | Id | Name  | Salary | ManagerId |
-- +----+-------+--------+-----------+
-- | 1  | Joe   | 70000  | 3         |
-- | 2  | Henry | 80000  | 4         |
-- | 3  | Sam   | 60000  | NULL      |
-- | 4  | Max   | 90000  | NULL      |
-- +----+-------+--------+-----------+
-- Given the Employee table, write a SQL query that finds out employees who earn more than their managers. For the above table, Joe is the only employee who earns more than his manager.
--
-- +----------+
-- | Employee |
-- +----------+
-- | Joe      |
-- +----------+


# Write your MySQL query statement below

# method 1
SELECT E1.Name AS Employee
FROM Employee E1
join Employee E2
where E1.ManagerId = E2.Id and E1.Salary > E2.Salary

# method 2
SELECT E1.Name AS Employee
FROM Employee E1, Employee E2
WHERE E1.ManagerId = E2.Id and E1.Salary > E2.Salary

# method 3
select employee.Name as Employee
from Employee employee
join (Employee manager)
on employee.ManagerId = manager.Id
where employee.Salary > manager.Salary
