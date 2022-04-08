WITH Candidates AS (
  SELECT
    DISTINCT Comments.CreationDate as C_CreationDate,
    Comments.UserId,
    Posts.Id as PostId,
    Votes.UserId as V_UserId,
    Votes.CreationDate as V_CreationDate,
    PostHistory.PostHistoryTypeId,
    PostHistory.CreationDate as PH_CreationDate,
    Posts.Title
  FROM
    Comments,
    Posts,
    PostHistory,
    Votes
  WHERE
    PostHistory.PostId = Posts.Id
    AND Votes.PostId = Posts.Id
    AND Comments.PostId = Posts.Id
    AND Posts.Tags LIKE "%SQL%"
    AND Votes.BountyAmount > 100
    AND PostHistoryTypeId = 2
    AND Comments.score = 0
),
Filter AS (  
  SELECT
    C_CreationDate,
    UserId,
    PostId,
    V_UserId,
    V_CreationDate,
    PostHistoryTypeId,
    PH_CreationDate
  FROM
    Candidates C
  GROUP BY
    C_CreationDate,
    UserId,
    PostId,
    V_UserId,
    V_CreationDate,
    PostHistoryTypeId,
    PH_CreationDate
  HAVING
    COUNT(*) > 1
)
SELECT
  DISTINCT PostId,
  Title
FROM
  Candidates C
WHERE
  NOT EXISTS (
    SELECT
      *
    FROM
      Filter F
    WHERE
      C.C_CreationDate = F.C_CreationDate
      AND C.UserId = F.UserId
      AND C.PostId = F.PostId
      AND C.V_UserId = F.V_UserId
      AND C.V_CreationDate = F.V_CreationDate
      AND C.PostHistoryTypeId = F.PostHistoryTypeId
      AND C.PH_CreationDate = F.PH_CreationDate
  )
