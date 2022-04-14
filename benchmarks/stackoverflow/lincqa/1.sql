WITH Candidates_Posts AS (
  SELECT P.id, P.title, V.CreationDate
  FROM Posts P, Votes V
  WHERE P.Id = V.PostId AND P.OwnerUserId = V.UserId AND BountyAmount > 100
),


Posts_bad_key AS (
  SELECT
    C.Id
  FROM
    Candidates_Posts C
    JOIN Posts ON C.Id = Posts.Id 
    LEFT OUTER JOIN Votes V ON C.Id = V.PostId AND Posts.OwnerUserId = V.UserId AND C.CreationDate = V.CreationDate
  WHERE
    (V.UserId IS NULL OR V.CreationDate IS NULL
  or V.BountyAmount <= 100
  )
   union all

  select Id
  from (
  select distinct Id, Title
  from Candidates_posts
 ) t
  group by Id
  having count(*) > 1 

)


SELECT
  distinct Id, title
FROM
  Candidates_Posts C
WHERE
  NOT EXISTS (
    SELECT
      *
    FROM
      Posts_bad_key F
    WHERE
      C.Id = F.Id

)
