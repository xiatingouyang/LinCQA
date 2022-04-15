WITH sfr AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        l_0.l_linenumber AS a0,
        l_0.l_orderkey AS a1
      FROM
        lineitem l_0
      WHERE
        l_0.l_quantity = 13
    ) t
),
bb_lineitem AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a0 AS a0,
        s_0.a1 AS a1
      FROM
        sfr s_0
        INNER JOIN lineitem l_1 ON s_0.a0 = l_1.l_linenumber
        AND s_0.a1 = l_1.l_orderkey
      WHERE
        l_1.l_quantity != 13.0
    ) t
)
SELECT
  DISTINCT *
FROM
  (
    SELECT
       1
    FROM
      sfr s_0,
      lineitem l_1
    WHERE
      s_0.a0 = l_1.l_linenumber
      AND s_0.a1 = l_1.l_orderkey
      AND l_1.l_quantity = 13
      AND NOT EXISTS (
        SELECT
          *
        FROM
          bb_lineitem neg_b_0
        WHERE
          neg_b_0.a0 = s_0.a0
          AND neg_b_0.a1 = s_0.a1
      )
  ) t;

