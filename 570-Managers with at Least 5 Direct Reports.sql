-- The Employee table holds all employees including their managers. Every employee has an Id, and there is also a column for the manager Id.
--
-- +------+----------+-----------+----------+
-- |Id    |Name 	  |Department |ManagerId |
-- +------+----------+-----------+----------+
-- |101   |John 	  |A 	      |null      |
-- |102   |Dan 	  |A 	      |101       |
-- |103   |James 	  |A 	      |101       |
-- |104   |Amy 	  |A 	      |101       |
-- |105   |Anne 	  |A 	      |101       |
-- |106   |Ron 	  |B 	      |101       |
-- +------+----------+-----------+----------+
-- Given the Employee table, write a SQL query that finds out managers with at least 5 direct report. For the above table, your SQL query should return:
--
-- +-------+
-- | Name  |
-- +-------+
-- | John  |
-- +-------+
-- Note:
-- No one would report to himself.
--


# Write your MySQL query statement below

# method 1
SELECT e1.Name FROM Employee e1
LEFT JOIN Employee e2 ON e1.Id = e2.ManagerId
GROUP BY e1.Id
HAVING COUNT(e1.Name) >= 5;

# method 2
select name from employee
where id in
(select managerId from Employee
group by managerId
having count(managerId)>=5)

# # method 3
select name
from Employee e,
(   select ManagerId
    from Employee
    group by ManagerId having count(*)>4
) as m
where e.id = m.ManagerId

# # method 4
SELECT e1.Name FROM Employee AS e1
INNER JOIN Employee AS e2
ON e1.Id = e2.ManagerId
GROUP BY e1.Name
HAVING Count(e1.Name) >= 5


# # method 5, self join
select p2.name from employee p1
join employee p2
on p1.managerid = p2.id
group by p1.managerid
having count(*) >= 5


# # method 6
select Name from Employee where Id in (
select ManagerId from Employee
where ManagerId is not null
group by ManagerId
having count(*)>=5);
