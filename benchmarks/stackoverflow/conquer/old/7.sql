WITH Candidates_Comments AS (
  SELECT
    DISTINCT Comments.CreationDate,
    Comments.UserId,
    Posts.Id
  FROM
    Posts,
    Users,
    Comments,
    PostHistory,
    Votes
  WHERE
    PostHistory.PostId = PostHistory.PostId
    AND PostHistory.PostId = Posts.Id
    AND PostHistory.PostId = Posts.Id
    AND PostHistory.PostId = Votes.PostId
    AND PostHistory.PostId = Votes.PostId
    AND Posts.OwnerUserId = Users.Id
    AND Comments.PostId = Posts.Id
    AND Comments.PostId = PostHistory.PostId
    AND Comments.PostId = Votes.PostId
    AND Users.reputation > 100
    AND Votes.BountyAmount > 100
    AND PostHistory.PostHistoryTypeId = 2
    AND C.score = 0
),
Filter_Comments AS (
  SELECT
    C.CreationDate,
    C.UserId
  FROM
    Candidates_Comments C
    JOIN Comments ON C.CreationDate = Comments.CreationDate
    AND C.UserId = Comments.UserId
    LEFT OUTER JOIN Posts ON Comments.PostId = Posts.Id
    LEFT OUTER JOIN PostHistory ON Comments.PostId = PostHistory.PostId
    LEFT OUTER JOIN Votes ON Comments.PostId = Votes.PostId
    LEFT OUTER JOIN Users ON Posts.OwnerUserId = Users.Id
  WHERE
    PostHistory.PostId = PostHistory.PostId
    AND PostHistory.PostId = Posts.Id
    AND PostHistory.PostId = Posts.Id
    AND PostHistory.PostId = Votes.PostId
    AND PostHistory.PostId = Votes.PostId
    AND (
      Posts.Id IS NULL
      OR Users.Id IS NULL
      OR PostHistory.PostHistoryTypeId IS NULL
      OR PostHistory.PostId IS NULL
      OR PostHistory.CreationDate IS NULL
      OR PostHistory.UserId IS NULL
      OR Votes.PostId IS NULL
      OR Votes.UserId IS NULL
      OR Votes.CreationDate IS NULL
    )
  UNION ALL
  SELECT
    C.CreationDate,
    C.UserId
  FROM
    Candidates_Comments C
  GROUP BY
    C.CreationDate,
    C.UserId
  HAVING
    COUNT(*) > 1
)
SELECT
  DISTINCT Id
FROM
  Candidates_Comments C
WHERE
  NOT EXISTS (
    SELECT
      *
    FROM
      Filter_Comments F
    WHERE
      C.CreationDate = F.CreationDate
      AND C.UserId = F.UserId
  )

