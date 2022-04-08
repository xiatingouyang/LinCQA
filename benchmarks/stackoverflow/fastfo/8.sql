WITH sfr AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        c_1.CreationDate AS a0,
        u_0.DisplayName AS a1,
        c_1.PostId AS a2,
        u_0.Id AS a3
      FROM
        Users u_0,
        Comments c_1,
        Posts p_2
      WHERE
        u_0.Id = c_1.UserId
        AND c_1.PostId = p_2.Id
        AND p_2.Tags LIKE "%SQL%"
        AND c_1.Score > 5
    ) t
),
yes_Posts AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a2 AS a0
      FROM
        sfr s_0,
        Posts p_1
      WHERE
        s_0.a2 = p_1.Id
        AND NOT EXISTS (
          SELECT
            p_2.Id
          FROM
            Posts p_2
          WHERE
      p_1.Id = p_2.Id
            AND (p_2.Tags IS NULL
            OR p_2.Tags NOT LIKE "%SQL%")
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
        s_0.a3 AS a1
      FROM
        sfr s_0
        INNER JOIN Comments c_1 ON s_0.a0 = c_1.CreationDate
        AND s_0.a3 = c_1.UserId
        LEFT OUTER JOIN yes_Posts y_2 ON c_1.PostId = y_2.a0
      WHERE
        y_2.a0 IS NULL
      UNION
      SELECT
        c_0.CreationDate,
        c_0.UserId
      FROM
        Comments c_0
      WHERE
        c_0.Score <= 5
    ) t
),
yes_Comments AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a3 AS a0
      FROM
        sfr s_0,
        Comments c_1
      WHERE
        s_0.a0 = c_1.CreationDate
        AND s_0.a2 = c_1.PostId
        AND s_0.a3 = c_1.UserId
        AND NOT EXISTS (
          SELECT
            *
          FROM
            bb_Comments neg_b_0
          WHERE
            neg_b_0.a0 = s_0.a0
            AND neg_b_0.a1 = s_0.a3
        )
    ) t
),
bb_Users AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a1 AS a0,
        s_0.a3 AS a1
      FROM
        sfr s_0
        INNER JOIN Users u_1 ON s_0.a3 = u_1.Id
        LEFT OUTER JOIN yes_Comments y_2 ON s_0.a3 = u_1.Id
        AND u_1.Id = y_2.a0
      WHERE
        u_1.Id IS NULL
        OR y_2.a0 IS NULL
        OR u_1.DisplayName != s_0.a1
    ) t
)
SELECT
  DISTINCT *
FROM
  (
    SELECT
      s_0.a3 AS a0,
      s_0.a1 AS a1
    FROM
      sfr s_0,
      Users u_1
    WHERE
      s_0.a1 = u_1.DisplayName
      AND s_0.a3 = u_1.Id
      AND NOT EXISTS (
        SELECT
          *
        FROM
          bb_Users neg_b_0
        WHERE
          neg_b_0.a0 = s_0.a1
          AND neg_b_0.a1 = s_0.a3
      )
  ) t;

