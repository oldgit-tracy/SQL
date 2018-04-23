-- Write a SQL query to find all duplicate emails in a table named Person.
--
-- +----+---------+
-- | Id | Email   |
-- +----+---------+
-- | 1  | a@b.com |
-- | 2  | c@d.com |
-- | 3  | a@b.com |
-- +----+---------+
-- For example, your query should return the following for the above table:
--
-- +---------+
-- | Email   |
-- +---------+
-- | a@b.com |
-- +---------+
-- Note: All emails are in lowercase.


# Write your MySQL query statement below

# method 1
SELECT Email
FROM Person
group by Email
having count(*)>1


# method 2
SELECT distinct a.Email from Person a
join Person b
on a.Email = b.Email
where a.Id != b.Id
