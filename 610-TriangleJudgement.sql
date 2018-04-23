-- A pupil Tim gets homework to identify whether three line segments could possibly form a triangle.
-- However, this assignment is very heavy because there are hundreds of records to calculate.
-- Could you help Tim by writing a query to judge whether these three sides can form a triangle, assuming table triangle holds the length of the three sides x, y and z.
-- | x  | y  | z  |
-- |----|----|----|
-- | 13 | 15 | 30 |
-- | 10 | 20 | 15 |
-- For the sample data above, your query should return the follow result:
-- | x  | y  | z  | triangle |
-- |----|----|----|----------|
-- | 13 | 15 | 30 | No       |
-- | 10 | 20 | 15 | Yes      |


# Write your MySQL query statement below

# method 1
SELECT *,
CASE WHEN x+y<=z
          or x+z<=y
          or y+z<=x
    then 'No'
    else 'Yes'
END as triangle
FROM triangle


# method 2
SELECT *,
IF(x+y<=z or x+z<=y or y+z<=x, 'No', 'Yes') as triangle
FROM triangle
