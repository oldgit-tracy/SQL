-- Given a Weather table, write a SQL query to find all dates' Ids with higher temperature compared to its previous (yesterday's) dates.
--
-- +---------+------------------+------------------+
-- | Id(INT) | RecordDate(DATE) | Temperature(INT) |
-- +---------+------------------+------------------+
-- |       1 |       2015-01-01 |               10 |
-- |       2 |       2015-01-02 |               25 |
-- |       3 |       2015-01-03 |               20 |
-- |       4 |       2015-01-04 |               30 |
-- +---------+------------------+------------------+
-- For example, return the following Ids for the above Weather table:
--
-- +----+
-- | Id |
-- +----+
-- |  2 |
-- |  4 |
-- +----+


# Write your MySQL query statement below

# method 1
select b.Id from Weather b
left join Weather a
ON TO_DAYS(b.Date) = TO_DAYS(a.Date) + 1
WHERE b.Temperature > a.Temperature

# method 2
select b.Id from Weather b, Weather a
where b.Temperature > a.Temperature
and DATEDIFF(b.Date, a.Date)=1
