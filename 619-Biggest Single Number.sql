-- Table number contains many numbers in column num including duplicated ones.
-- Can you write a SQL query to find the biggest number, which only appears once.
-- +---+
-- |num|
-- +---+
-- | 8 |
-- | 8 |
-- | 3 |
-- | 3 |
-- | 1 |
-- | 4 |
-- | 5 |
-- | 6 |
-- For the sample data above, your query should return the following result:
-- +---+
-- |num|
-- +---+
-- | 6 |
-- Note:
-- If there is no such number, just output null.


# Write your MySQL query statement below

# method 1: use groupby and max
select max(sub.num) as num
from (select distinct num, count(num) as Sum from number group by num) as sub
where Sum = 1


# method 2: use groupby with order by limit
select(
  select num
  from number
  group by num
  having count(*) = 1
  order by num desc limit 1
) as num;


# method 3: no groupby with max
Select
    max(n.num) as num
from
    number n
where
    (Select count(num) from number where num = n.num) = 1;


# method 4: no groupby with order by limit
select(
        select * from number a
	where (select count(b.num) from number b where b.num=a.num) = 1
	order by a.num desc limit 0,1
) as num
