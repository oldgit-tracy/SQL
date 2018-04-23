-- Several friends at a cinema ticket office would like to reserve consecutive available seats.
-- Can you help to query all the consecutive available seats order by the seat_id using the following cinema table?
-- | seat_id | free |
-- |---------|------|
-- | 1       | 1    |
-- | 2       | 0    |
-- | 3       | 1    |
-- | 4       | 1    |
-- | 5       | 1    |
-- Your query should return the following result for the sample case above.
-- | seat_id |
-- |---------|
-- | 3       |
-- | 4       |
-- | 5       |
-- Note:
-- The seat_id is an auto increment int, and free is bool ('1' means free, and '0' means occupied.).
-- Consecutive available seats are more than 2(inclusive) seats consecutively available.


# Write your MySQL query statement below

# method 1
# SELECT a.seat_id
# FROM cinema a
# join cinema b
# on (a.free = 1 and b.free =1) and abs(a.seat_id - b.seat_id)=1
# order by seat_id


# medthod 2
# SELECT A.seat_id FROM CINEMA A INNER JOIN CINEMA B ON A.seat_id=B.seat_id-1 WHERE A.free=B.free
# UNION
# SELECT A.seat_id FROM CINEMA A INNER JOIN CINEMA B ON A.seat_id=B.seat_id+1 WHERE A.free=B.free


# method 3
SELECT DISTINCT(a.seat_id)
FROM cinema a, cinema b
WHERE (a.free = 1)
AND ( ((a.seat_id = (b.seat_id+1)) AND (b.free = 1)) OR
((a.seat_id = (b.seat_id-1)) AND (b.free = 1)) )
ORDER BY a.seat_id;
