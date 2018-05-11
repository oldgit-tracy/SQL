-- A U.S graduate school has students from Asia, Europe and America. The students' location information are stored in table student as below.
-- | name   | continent |
-- |--------|-----------|
-- | Jack   | America   |
-- | Pascal | Europe    |
-- | Xi     | Asia      |
-- | Jane   | America   |
-- Pivot the continent column in this table so that each name is sorted alphabetically and displayed underneath its corresponding continent. The output headers should be America, Asia and Europe respectively. It is guaranteed that the student number from America is no less than either Asia or Europe.
-- For the sample input, the output is:
-- | America | Asia | Europe |
-- |---------|------|--------|
-- | Jack    | Xi   | Pascal |
-- | Jane    |      |        |
-- Follow-up: If it is unknown which continent has the most students, can you write a query to generate the student report?


# Write your MySQL query statement below


set @a = 0;
set @b = 0;
set @c = 0;

Select America.name as America, Asia.name as Asia, Europe.name as Europe from
(select name, @a := @a + 1 as id from student where continent = 'America' order by name) as America
Left Join
(select name, @b := @b + 1 as id from student where continent = 'Asia' order by name) as Asia on America.id = Asia.id
Left Join
(select name, @c := @c + 1 as id from student where continent = 'Europe' order by name) as Europe on America.id = Europe.id


# method 2
SELECT
    a.Name AS America,
    b.Name AS Asia,
    c.Name AS Europe
FROM (
    SELECT
        Name,
        @r1 := @r1 + 1 AS rowid
    FROM student s, (SELECT @r1 := 0) init
    WHERE continent = 'America'
    ORDER BY Name) a
LEFT JOIN (
    SELECT
        Name,
        @r2 := @r2 + 1 AS rowid
    FROM student s, (SELECT @r2 := 0) init
    WHERE continent = 'Asia'
    ORDER BY Name) b ON a.rowid = b.rowid
LEFT JOIN (
    SELECT
        Name,
        @r3 := @r3 + 1 AS rowid
    FROM student s, (SELECT @r3 := 0) init
    WHERE continent = 'Europe'
    ORDER BY Name) c ON a.rowid = c.rowid


# method 3
set @r1 = 0, @r2 = 0, @r3 = 0;
select min(America) America, min(Asia) Asia, min(Europe) Europe
from (select case when continent='America' then @r1 :=@r1+1
                  when continent='Asia' then @r2 :=@r2+1
                  when continent='Europe' then @r3 :=@r3+1 end RowNum,
             case when continent='America' then name end America,
             case when continent='Asia' then name end Asia,
             case when continent='Europe' then name end Europe
      from student
      order by name) T
group by RowNum

# method 4
select max(america) as america, max(asia) as asia, max(europe) as europe
from (
    select
        if(@pre = @pre := continent, @row := @row + 1, @row := 0) as row_count,
        if(continent = 'America', name, null) as america,
        if(continent = 'Asia', name, null) as asia,
        if(continent = 'Europe', name, null) as europe
    from student, (select @pre := '0', @row := 0) v
    order by continent,name
) t
group by row_count
order by row_count
;


# follow Q
SELECT America,Asia,Europe
FROM
(SELECT name, @m:=@m+1 AS mid
FROM student
WHERE continent =
(SELECT continent
FROM student
GROUP BY continent
ORDER BY COUNT(*) DESC
LIMIT 1)) AS tbl
LEFT JOIN
(SELECT name AS Asia, @asia:=@asia+1 AS sid
FROM student
WHERE continent = 'Asia'
ORDER BY name) AS a
ON mid = sid
LEFT JOIN
(SELECT name AS America, @am:=@am+1 AS aid
FROM student
WHERE continent = 'America'
ORDER BY name) AS am
ON mid=aid
LEFT JOIN
(SELECT name AS Europe, @euro:=@euro+1 AS eid
FROM student
WHERE continent = 'Europe'
ORDER BY name) AS e
ON mid =eid
