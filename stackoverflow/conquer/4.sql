WITH Candidates AS (
  SELECT
    DISTINCT Comments.CreationDate,
    Comments.UserId as C_UserId,
    Users.Id as UserId,
    Users.DisplayName
  FROM
    Posts,
    Comments,
    Users
  WHERE
    Comments.UserId = Users.Id
    AND Comments.PostId = Posts.Id
    AND Posts.Tags LIKE "%SQL%"
    AND Comments.Score > 5
),
Filter AS (
  SELECT
    C.CreationDate,
    C.C_UserId,
    C.UserId
  FROM
    Candidates C
    JOIN Comments ON C.CreationDate = Comments.CreationDate
    AND C.C_UserId = Comments.UserId
    JOIN Users ON C.UserId = Users.Id
    LEFT OUTER JOIN Posts ON Comments.PostId = Posts.Id
  WHERE
    Comments.UserId = Users.Id
    AND (Posts.Id IS NULL)
  UNION ALL
  SELECT
    C.CreationDate,
    C.C_UserId,
    C.UserId
  FROM
    Candidates C
  GROUP BY
    C.CreationDate,
    C.UserId,
    C.C_UserId
  HAVING
    COUNT(*) > 1
)
SELECT
  DISTINCT UserId,
  DisplayName
FROM
  Candidates C
WHERE
  NOT EXISTS (
    SELECT
      *
    FROM
      Filter F
    WHERE
      C.CreationDate = F.CreationDate
      AND C.UserId = F.UserId
      AND C.C_UserId = F.C_UserId
  )
