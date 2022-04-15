WITH sfr AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        l_0.l_linenumber AS a0,
        l_0.l_linestatus AS a1,
        l_0.l_orderkey AS a2,
        l_0.l_returnflag AS a3
      FROM
        lineitem l_0
    ) t
),
bb_lineitem AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a0 AS a0,
        s_0.a1 AS a1,
        s_0.a2 AS a2,
        s_0.a3 AS a3
      FROM
        sfr s_0
        INNER JOIN lineitem l_1 ON s_0.a0 = l_1.l_linenumber
        AND s_0.a2 = l_1.l_orderkey
      WHERE
        l_1.l_returnflag != s_0.a3
        OR l_1.l_linestatus != s_0.a1
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
      lineitem l_1
    WHERE
      s_0.a0 = l_1.l_linenumber
      AND s_0.a1 = l_1.l_linestatus
      AND s_0.a2 = l_1.l_orderkey
      AND s_0.a3 = l_1.l_returnflag
      AND NOT EXISTS (
        SELECT
          *
        FROM
          bb_lineitem neg_b_0
        WHERE
          neg_b_0.a0 = s_0.a0
          AND neg_b_0.a1 = s_0.a1
          AND neg_b_0.a2 = s_0.a2
          AND neg_b_0.a3 = s_0.a3
      )
  ) t;

