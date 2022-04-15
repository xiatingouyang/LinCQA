WITH sfr AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        c_1.CreationDate AS a0,
        c_1.UserId AS a1,
        p_2.CreationDate AS a2,
        p_2.UserId AS a3,
        p_0.Id AS a4,
        p_0.Title AS a5,
        v_3.UserId AS a6,
        v_3.CreationDate AS a7
      FROM
        Posts p_0,
        Comments c_1,
        PostHistory p_2,
        Votes v_3
      WHERE
        p_0.Id = c_1.PostId
        AND c_1.PostId = p_2.PostId
        AND p_2.PostId = v_3.PostId
        AND p_0.Tags LIKE "%SQL%"
        AND c_1.Score = 0
        AND p_2.PostHistoryTypeId = 2
        AND v_3.BountyAmount > 100
    ) t
),
bb_Posts AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a4 AS a0,
        s_0.a5 AS a1
      FROM
        sfr s_0
        INNER JOIN Posts p_1 ON s_0.a4 = p_1.Id
      WHERE
        p_1.Tags IS NULL OR p_1.Tags NOT LIKE "%SQL%"
        OR p_1.Title != s_0.a5
    ) t
),
yes_Posts AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a4 AS a0,
        s_0.a5 AS a1
      FROM
        sfr s_0,
        Posts p_1
      WHERE
        s_0.a4 = p_1.Id
        AND s_0.a5 = p_1.Title
        AND p_1.Tags = 111
        AND NOT EXISTS (
          SELECT
            *
          FROM
            bb_Posts neg_b_0
          WHERE
            neg_b_0.a0 = s_0.a4
            AND neg_b_0.a1 = s_0.a5
        )
    ) t
),
bb_Votes AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a4 AS a0,
        s_0.a5 AS a1,
        s_0.a6 AS a2,
        s_0.a7 AS a3
      FROM
        sfr s_0
        INNER JOIN Votes v_1 ON s_0.a4 = v_1.PostId
        AND s_0.a6 = v_1.UserId
        AND s_0.a7 = v_1.CreationDate
        LEFT OUTER JOIN yes_Posts y_2 ON s_0.a4 = v_1.PostId
        AND v_1.PostId = y_2.a0
        AND s_0.a5 = y_2.a1
      WHERE
        v_1.PostId IS NULL
        OR y_2.a0 IS NULL
        OR y_2.a1 IS NULL
        OR v_1.BountyAmount <= 100
    ) t
),
yes_Votes AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a4 AS a0,
        s_0.a4 AS a1,
        s_0.a5 AS a2
      FROM
        sfr s_0,
        Votes v_1
      WHERE
        s_0.a4 = v_1.PostId
        AND s_0.a6 = v_1.UserId
        AND s_0.a7 = v_1.CreationDate
        AND v_1.BountyAmount > 100
        AND NOT EXISTS (
          SELECT
            *
          FROM
            bb_Votes neg_b_0
          WHERE
            neg_b_0.a0 = s_0.a4
            AND neg_b_0.a1 = s_0.a5
            AND neg_b_0.a2 = s_0.a6
            AND neg_b_0.a3 = s_0.a7
        )
    ) t
),
bb_PostHistory AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        2 AS a0,
        s_0.a2 AS a1,
        s_0.a3 AS a2,
        s_0.a4 AS a3,
        s_0.a5 AS a4
      FROM
        sfr s_0
        INNER JOIN PostHistory p_1 ON s_0.a2 = p_1.CreationDate
        AND s_0.a3 = p_1.UserId
        AND s_0.a4 = p_1.PostId
        LEFT OUTER JOIN yes_Votes y_2 ON s_0.a4 = p_1.PostId
        AND p_1.PostId = y_2.a0
        AND y_2.a0 = y_2.a1
        AND s_0.a5 = y_2.a2
      WHERE
        p_1.PostId IS NULL
        OR y_2.a0 IS NULL
        OR y_2.a1 IS NULL
        OR y_2.a2 IS NULL
    ) t
),
yes_PostHistory AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a4 AS a0,
        s_0.a4 AS a1,
        s_0.a4 AS a2,
        s_0.a5 AS a3
      FROM
        sfr s_0,
        PostHistory p_1
      WHERE
        s_0.a2 = p_1.CreationDate
        AND s_0.a3 = p_1.UserId
        AND s_0.a4 = p_1.PostId
        AND p_1.PostHistoryTypeId = 2
        AND NOT EXISTS (
          SELECT
            *
          FROM
            bb_PostHistory neg_b_0
          WHERE
            neg_b_0.a0 = 2
            AND neg_b_0.a1 = s_0.a2
            AND neg_b_0.a2 = s_0.a3
            AND neg_b_0.a3 = s_0.a4
            AND neg_b_0.a4 = s_0.a5
        )
    ) t
),
bb_Comments AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a0 AS a0,
        s_0.a1 AS a1,
        s_0.a5 AS a2
      FROM
        sfr s_0
        INNER JOIN Comments c_1 ON s_0.a0 = c_1.CreationDate
        AND s_0.a1 = c_1.UserId
        LEFT OUTER JOIN yes_PostHistory y_2 ON s_0.a5 = y_2.a3
        AND c_1.PostId = y_2.a0
        AND y_2.a0 = y_2.a1
        AND y_2.a1 = y_2.a2
      WHERE
        y_2.a3 IS NULL
        OR y_2.a0 IS NULL
        OR y_2.a1 IS NULL
        OR y_2.a2 IS NULL
        OR c_1.Score != 0
    ) t
)
SELECT
  DISTINCT *
FROM
  (
    SELECT
      s_0.a5 AS a0
    FROM
      sfr s_0,
      Comments c_1
    WHERE
      s_0.a0 = c_1.CreationDate
      AND s_0.a1 = c_1.UserId
      AND s_0.a4 = c_1.PostId
      AND c_1.Score = 0
      AND NOT EXISTS (
        SELECT
          *
        FROM
          bb_Comments neg_b_0
        WHERE
          neg_b_0.a0 = s_0.a0
          AND neg_b_0.a1 = s_0.a1
          AND neg_b_0.a2 = s_0.a5
      )
  ) t;

