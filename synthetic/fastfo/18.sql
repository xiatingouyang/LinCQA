WITH sfr AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        r_2.A73 AS a0,
        r_1.A22 AS a1,
        r_0.A11 AS a2,
        r_0.A12 AS a3,
        r_0.A13 AS a4
      FROM
        r_1 r_0,
        r_2 r_1,
        r_7 r_2
      WHERE
        r_0.A12 = r_1.A21
        AND r_1.A22 = r_2.A71
    ) t
),
bb_r_7 AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a0 AS a0,
        s_0.a1 AS a1
      FROM
        sfr s_0
        INNER JOIN r_7 r_1 ON s_0.a1 = r_1.A71
      WHERE
        r_1.A73 != s_0.a0
    ) t
),
yes_r_7 AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a0 AS a0,
        s_0.a1 AS a1
      FROM
        sfr s_0,
        r_7 r_1
      WHERE
        s_0.a0 = r_1.A73
        AND s_0.a1 = r_1.A71
        AND NOT EXISTS (
          SELECT
            *
          FROM
            bb_r_7 neg_b_0
          WHERE
            neg_b_0.a0 = s_0.a0
            AND neg_b_0.a1 = s_0.a1
        )
    ) t
),
bb_r_2 AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a0 AS a0,
        s_0.a3 AS a1
      FROM
        sfr s_0
        INNER JOIN r_2 r_1 ON s_0.a3 = r_1.A21
        LEFT OUTER JOIN yes_r_7 y_2 ON s_0.a0 = y_2.a0
        AND r_1.A22 = y_2.a1
      WHERE
        y_2.a0 IS NULL
        OR y_2.a1 IS NULL
    ) t
),
yes_r_2 AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a0 AS a0,
        s_0.a3 AS a1
      FROM
        sfr s_0,
        r_2 r_1
      WHERE
        s_0.a1 = r_1.A22
        AND s_0.a3 = r_1.A21
        AND NOT EXISTS (
          SELECT
            *
          FROM
            bb_r_2 neg_b_0
          WHERE
            neg_b_0.a0 = s_0.a0
            AND neg_b_0.a1 = s_0.a3
        )
    ) t
),
bb_r_1 AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a0 AS a0,
        s_0.a2 AS a1,
        s_0.a4 AS a2
      FROM
        sfr s_0
        INNER JOIN r_1 r_1 ON s_0.a2 = r_1.A11
        LEFT OUTER JOIN yes_r_2 y_2 ON s_0.a0 = y_2.a0
        AND r_1.A12 = y_2.a1
      WHERE
        y_2.a0 IS NULL
        OR y_2.a1 IS NULL
        OR r_1.A13 != s_0.a4
    ) t
)
SELECT
  DISTINCT *
FROM
  (
    SELECT
      s_0.a4 AS a0,
      s_0.a0 AS a1
    FROM
      sfr s_0,
      r_1 r_1
    WHERE
      s_0.a2 = r_1.A11
      AND s_0.a3 = r_1.A12
      AND s_0.a4 = r_1.A13
      AND NOT EXISTS (
        SELECT
          *
        FROM
          bb_r_1 neg_b_0
        WHERE
          neg_b_0.a0 = s_0.a0
          AND neg_b_0.a1 = s_0.a2
          AND neg_b_0.a2 = s_0.a4
      )
  ) t;

