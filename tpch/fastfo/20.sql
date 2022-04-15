WITH sfr AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.s_nationkey AS a0,
        s_0.s_address AS a1,
        s_0.s_name AS a2,
        s_0.s_suppkey AS a3
      FROM
        supplier s_0,
        nation n_1
      WHERE
        s_0.s_nationkey = n_1.n_nationkey
        AND n_1.n_name = 3164269
    ) t
),
bb_nation AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a0 AS a0
      FROM
        sfr s_0
        INNER JOIN nation n_1 ON s_0.a0 = n_1.n_nationkey
      WHERE
        n_1.n_name != 3164269.0
    ) t
),
yes_nation AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a0 AS a0
      FROM
        sfr s_0,
        nation n_1
      WHERE
        s_0.a0 = n_1.n_nationkey
        AND n_1.n_name = 3164269
        AND NOT EXISTS (
          SELECT
            *
          FROM
            bb_nation neg_b_0
          WHERE
            neg_b_0.a0 = s_0.a0
        )
    ) t
),
bb_supplier AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a1 AS a0,
        s_0.a2 AS a1,
        s_0.a3 AS a2
      FROM
        sfr s_0
        INNER JOIN supplier s_1 ON s_0.a3 = s_1.s_suppkey
        LEFT OUTER JOIN yes_nation y_2 ON s_1.s_nationkey = y_2.a0
      WHERE
        y_2.a0 IS NULL
        OR s_1.s_name != s_0.a2
        OR s_1.s_address != s_0.a1
    ) t
)
SELECT
  DISTINCT *
FROM
  (
    SELECT
      s_0.a2 AS a0,
      s_0.a1 AS a1
    FROM
      sfr s_0,
      supplier s_1
    WHERE
      s_0.a0 = s_1.s_nationkey
      AND s_0.a1 = s_1.s_address
      AND s_0.a2 = s_1.s_name
      AND s_0.a3 = s_1.s_suppkey
      AND NOT EXISTS (
        SELECT
          *
        FROM
          bb_supplier neg_b_0
        WHERE
          neg_b_0.a0 = s_0.a1
          AND neg_b_0.a1 = s_0.a2
          AND neg_b_0.a2 = s_0.a3
      )
  ) t;

