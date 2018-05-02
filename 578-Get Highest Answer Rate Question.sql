-- Get the highest answer rate question from a table survey_log with these columns: uid, action, question_id, answer_id, q_num, timestamp.
--
-- uid means user id; action has these kind of values: "show", "answer", "skip"; answer_id is not null when action column is "answer", while is null for "show" and "skip"; q_num is the numeral order of the question in current session.
--
-- Write a sql query to identify the question which has the highest answer rate.
--
-- Example:
-- Input:
-- +------+-----------+--------------+------------+-----------+------------+
-- | uid  | action    | question_id  | answer_id  | q_num     | timestamp  |
-- +------+-----------+--------------+------------+-----------+------------+
-- | 5    | show      | 285          | null       | 1         | 123        |
-- | 5    | answer    | 285          | 124124     | 1         | 124        |
-- | 5    | show      | 369          | null       | 2         | 125        |
-- | 5    | skip      | 369          | null       | 2         | 126        |
-- +------+-----------+--------------+------------+-----------+------------+
-- Output:
-- +-------------+
-- | survey_log  |
-- +-------------+
-- |    285      |
-- +-------------+
-- Explanation:
-- question 285 has answer rate 1/1, while question 369 has 0/1 answer rate, so output 285.
-- Note: The highest answer rate meaning is: answer number's ratio in show number in the same question.
--


# Write your MySQL query statement below

# method 1
select question_id as survey_log from survey_log
group by question_id
order by sum(if(answer_id is not null, 1,0))/count(*) desc
limit 1


# method 2
SELECT question_id AS survey_log
FROM survey_log
GROUP BY question_id
ORDER BY SUM(IF(action = 'answer', 1, 0)) / COUNT(*) DESC LIMIT 1

# method 3
select question_id as 'survey_log'
from survey_log
group by question_id
order by (count(answer_id)/count(q_num)) desc
limit 1

# method 4
SELECT sub.survey_log AS survey_log
FROM
(SELECT question_id AS survey_log,
       COUNT(answer_id)/COUNT(DISTINCT question_id) AS answer_rate
FROM survey_log
GROUP BY question_id
ORDER BY 2 DESC
LIMIT 1) sub
