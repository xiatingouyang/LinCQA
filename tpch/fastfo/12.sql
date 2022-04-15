WITH sfr AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        l_1.l_linenumber AS a0,
        o_0.o_orderkey AS a1,
        l_1.l_shipmode AS a2
      FROM
        orders o_0,
        lineitem l_1
      WHERE
        o_0.o_orderkey = l_1.l_orderkey
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
        s_0.a2 AS a2
      FROM
        sfr s_0
        INNER JOIN lineitem l_1 ON s_0.a0 = l_1.l_linenumber
        AND s_0.a1 = l_1.l_orderkey
      WHERE
        l_1.l_shipmode != s_0.a2
    ) t
),
yes_lineitem AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a1 AS a0,
        s_0.a2 AS a1
      FROM
        sfr s_0,
        lineitem l_1
      WHERE
        s_0.a0 = l_1.l_linenumber
        AND s_0.a1 = l_1.l_orderkey
        AND s_0.a2 = l_1.l_shipmode
        AND NOT EXISTS (
          SELECT
            *
          FROM
            bb_lineitem neg_b_0
          WHERE
            neg_b_0.a0 = s_0.a0
            AND neg_b_0.a1 = s_0.a1
            AND neg_b_0.a2 = s_0.a2
        )
    ) t
),
bb_orders AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a1 AS a0,
        s_0.a2 AS a1
      FROM
        sfr s_0
        INNER JOIN orders o_1 ON s_0.a1 = o_1.o_orderkey
        LEFT OUTER JOIN yes_lineitem y_2 ON s_0.a1 = o_1.o_orderkey
        AND o_1.o_orderkey = y_2.a0
        AND s_0.a2 = y_2.a1
      WHERE
        o_1.o_orderkey IS NULL
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
      orders o_1
    WHERE
      s_0.a1 = o_1.o_orderkey
      AND NOT EXISTS (
        SELECT
          *
        FROM
          bb_orders neg_b_0
        WHERE
          neg_b_0.a0 = s_0.a1
          AND neg_b_0.a1 = s_0.a2
      )
  ) t;

