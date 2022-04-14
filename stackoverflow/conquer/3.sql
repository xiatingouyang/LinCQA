WITH Candidates_Posts AS (
  SELECT
    DISTINCT Posts.Id,
    Users.DisplayName
  FROM
    Posts,
    Users
  WHERE
    Posts.OwnerUserId = Users.Id AND Posts.Tags LIKE "<c++>"
),
Filter_Posts AS (
  SELECT
    C.Id
  FROM
    Candidates_Posts C
    JOIN Posts ON C.Id = Posts.Id
    LEFT OUTER JOIN Users ON Posts.OwnerUserId = Users.Id
  WHERE
    (Users.Id IS NULL)
  UNION ALL
  SELECT
    C.Id
  FROM
    Candidates_Posts C
  GROUP BY
    C.Id
  HAVING
    COUNT(*) > 1
)
SELECT
  DISTINCT DisplayName
FROM
  Candidates_Posts C
WHERE
  NOT EXISTS (
    SELECT
      *
    FROM
      Filter_Posts F
    WHERE
      C.Id = F.Id
  )
