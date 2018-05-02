-- Table: Candidate
--
-- +-----+---------+
-- | id  | Name    |
-- +-----+---------+
-- | 1   | A       |
-- | 2   | B       |
-- | 3   | C       |
-- | 4   | D       |
-- | 5   | E       |
-- +-----+---------+
-- Table: Vote
--
-- +-----+--------------+
-- | id  | CandidateId  |
-- +-----+--------------+
-- | 1   |     2        |
-- | 2   |     4        |
-- | 3   |     3        |
-- | 4   |     2        |
-- | 5   |     5        |
-- +-----+--------------+
-- id is the auto-increment primary key,
-- CandidateId is the id appeared in Candidate table.
-- Write a sql to find the name of the winning candidate, the above example will return the winner B.
--
-- +------+
-- | Name |
-- +------+
-- | B    |
-- +------+
-- Notes:
-- You may assume there is no tie, in other words there will be at most one winning candidate.



# Write your MySQL query statement below

select Candidate.Name from Candidate
join Vote
on Candidate.id = Vote.CandidateId
group by Candidate.Name
order by count(*) desc
limit 1


# method 2
SELECT Name FROM Candidate
WHERE id = (
SELECT CandidateId FROM Vote
GROUP BY CandidateId
ORDER BY COUNT(*) DESC LIMIT 1);

# method 3
select Candidate.name from
(select Vote.CandidateId from Vote
 group by Vote.CandidateId
 order by count(*) desc limit 0,1) as c, Candidate
      where c.CandidateId = Candidate.id
