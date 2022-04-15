WITH sfr AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        l_0.l_linenumber AS a0,
        l_0.l_orderkey AS a1,
        l_0.l_partkey AS a2
      FROM
        lineitem l_0,
        part p_1
      WHERE
        l_0.l_partkey = p_1.p_partkey
        AND p_1.p_container = 2926595
    ) t
),
bb_part AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a2 AS a0
      FROM
        sfr s_0
        INNER JOIN part p_1 ON s_0.a2 = p_1.p_partkey
      WHERE
        p_1.p_container != 2926595.0
    ) t
),
yes_part AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a2 AS a0
      FROM
        sfr s_0,
        part p_1
      WHERE
        s_0.a2 = p_1.p_partkey
        AND p_1.p_container = 2926595
        AND NOT EXISTS (
          SELECT
            *
          FROM
            bb_part neg_b_0
          WHERE
            neg_b_0.a0 = s_0.a2
        )
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
        LEFT OUTER JOIN yes_part y_2 ON l_1.l_partkey = y_2.a0
      WHERE
        y_2.a0 IS NULL
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
      AND s_0.a2 = l_1.l_partkey
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

