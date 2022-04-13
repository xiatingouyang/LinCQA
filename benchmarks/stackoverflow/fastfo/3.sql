WITH sfr AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        u_0.DisplayName AS a0,
        p_1.Id AS a1,
        u_0.Id AS a2
      FROM
        Users u_0,
        Posts p_1
      WHERE
        u_0.Id = p_1.OwnerUserId
	AND p_1.Tags LIKE "<c++>"
    ) t
),
bb_Users AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a0 AS a0,
        s_0.a2 AS a1
      FROM
        sfr s_0
        INNER JOIN Users u_1 ON s_0.a2 = u_1.Id
      WHERE
        u_1.DisplayName != s_0.a0
    ) t
),
yes_Users AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a0 AS a0,
        s_0.a2 AS a1
      FROM
        sfr s_0,
        Users u_1
      WHERE
        s_0.a0 = u_1.DisplayName
        AND s_0.a2 = u_1.Id
        AND NOT EXISTS (
          SELECT
            *
          FROM
            bb_Users neg_b_0
          WHERE
            neg_b_0.a0 = s_0.a0
            AND neg_b_0.a1 = s_0.a2
        )
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
        INNER JOIN Posts p_1 ON s_0.a1 = p_1.Id
        LEFT OUTER JOIN yes_Users y_2 ON s_0.a0 = y_2.a0
        AND p_1.OwnerUserId = y_2.a1
      WHERE
        y_2.a0 IS NULL
        OR y_2.a1 IS NULL
    ) t
)
SELECT
  DISTINCT *
FROM
  (
    SELECT
      s_0.a0 AS a0
    FROM
      sfr s_0,
      Posts p_1
    WHERE
      s_0.a1 = p_1.Id
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

