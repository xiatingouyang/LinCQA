WITH sfr AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        r_0.A31 AS a0,
        r_0.A32 AS a1,
        r_0.A33 AS a2
      FROM
        r_3 r_0,
        r_4 r_1,
        r_10 r_2
      WHERE
        r_0.A31 = r_1.A42
        AND r_1.A42 = r_2.A101
        AND r_0.A32 = r_1.A41
        AND r_1.A41 = r_2.A102
    ) t
),
bb_r_10 AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a0 AS a0,
        s_0.a1 AS a1
      FROM
        sfr s_0
        INNER JOIN r_10 r_1 ON s_0.a0 = r_1.A101
      WHERE
        r_1.A102 != s_0.a1
    ) t
),
yes_r_10 AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a0 AS a0,
        s_0.a1 AS a1
      FROM
        sfr s_0,
        r_10 r_1
      WHERE
        s_0.a0 = r_1.A101
        AND s_0.a1 = r_1.A102
        AND NOT EXISTS (
          SELECT
            *
          FROM
            bb_r_10 neg_b_0
          WHERE
            neg_b_0.a0 = s_0.a0
            AND neg_b_0.a1 = s_0.a1
        )
    ) t
),
bb_r_3 AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a0 AS a0,
        s_0.a1 AS a1,
        s_0.a2 AS a2
      FROM
        sfr s_0
        INNER JOIN r_3 r_1 ON s_0.a0 = r_1.A31
        LEFT OUTER JOIN yes_r_10 y_2 ON s_0.a0 = r_1.A31
        AND r_1.A31 = y_2.a0
        AND s_0.a1 = y_2.a1
      WHERE
        r_1.A31 IS NULL
        OR y_2.a0 IS NULL
        OR y_2.a1 IS NULL
        OR r_1.A32 != s_0.a1
        OR r_1.A33 != s_0.a2
    ) t
),
yes_r_3 AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a0 AS a0,
        s_0.a0 AS a1,
        s_0.a1 AS a2,
        s_0.a1 AS a3,
        s_0.a2 AS a4
      FROM
        sfr s_0,
        r_3 r_1
      WHERE
        s_0.a0 = r_1.A31
        AND s_0.a1 = r_1.A32
        AND s_0.a2 = r_1.A33
        AND NOT EXISTS (
          SELECT
            *
          FROM
            bb_r_3 neg_b_0
          WHERE
            neg_b_0.a0 = s_0.a0
            AND neg_b_0.a1 = s_0.a1
            AND neg_b_0.a2 = s_0.a2
        )
    ) t
),
bb_r_4 AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a1 AS a0,
        s_0.a2 AS a1
      FROM
        sfr s_0
        INNER JOIN r_4 r_1 ON s_0.a1 = r_1.A41
        LEFT OUTER JOIN yes_r_3 y_2 ON s_0.a1 = r_1.A41
        AND r_1.A41 = y_2.a2
        AND y_2.a2 = y_2.a3
        AND s_0.a2 = y_2.a4
        AND r_1.A42 = y_2.a0
        AND y_2.a0 = y_2.a1
      WHERE
        r_1.A41 IS NULL
        OR y_2.a2 IS NULL
        OR y_2.a3 IS NULL
        OR y_2.a4 IS NULL
        OR y_2.a0 IS NULL
        OR y_2.a1 IS NULL
    ) t
)
SELECT
  DISTINCT *
FROM
  (
    SELECT
      s_0.a2 AS a0
    FROM
      sfr s_0,
      r_4 r_1
    WHERE
      s_0.a0 = r_1.A42
      AND s_0.a1 = r_1.A41
      AND NOT EXISTS (
        SELECT
          *
        FROM
          bb_r_4 neg_b_0
        WHERE
          neg_b_0.a0 = s_0.a1
          AND neg_b_0.a1 = s_0.a2
      )
  ) t;

