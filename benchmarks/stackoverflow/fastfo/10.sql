WITH sfr AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        p_0.Id AS a0,
        p_0.Title AS a1,
        p_0.OwnerUserId AS a2,
        v_1.CreationDate AS a3
      FROM
        Posts p_0,
        Votes v_1
      WHERE
        p_0.Id = v_1.PostId
        AND p_0.OwnerUserId = v_1.UserId
	    AND v_1.BountyAmount > 100
    ) t
),
yes_Votes AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a0 AS a0,
        s_0.a2 AS a1
      FROM
        sfr s_0,
        Votes v_1
      WHERE
        s_0.a0 = v_1.PostId
        AND s_0.a2 = v_1.UserId
        AND s_0.a3 = v_1.CreationDate
    ) t
),
bb_Posts AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a0 AS a0,
        s_0.a1 AS a1
      FROM
        sfr s_0
        INNER JOIN Posts p_1 ON s_0.a0 = p_1.Id
        LEFT OUTER JOIN yes_Votes y_2 ON s_0.a0 = p_1.Id
        AND p_1.Id = y_2.a0
        AND p_1.OwnerUserId = y_2.a1
      WHERE
        p_1.Id IS NULL
        OR y_2.a0 IS NULL
        OR y_2.a1 IS NULL
        OR p_1.Title != s_0.a1
    ) t
)
SELECT
  DISTINCT *
FROM
  (
    SELECT
      s_0.a0 AS a0,
      s_0.a1 AS a1
    FROM
      sfr s_0,
      Posts p_1
    WHERE
      s_0.a0 = p_1.Id
      AND s_0.a1 = p_1.Title
      AND s_0.a2 = p_1.OwnerUserId
      AND NOT EXISTS (
        SELECT
          *
        FROM
          bb_Posts neg_b_0
        WHERE
          neg_b_0.a0 = s_0.a0
          AND neg_b_0.a1 = s_0.a1
      )
  ) t;

