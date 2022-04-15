WITH sfr AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        l_2.l_linenumber AS a0,
        o_1.o_orderkey AS a1,
        c_0.c_custkey AS a2,
        o_1.o_orderdate AS a3,
        o_1.o_shippriority AS a4
      FROM
        customer c_0,
        orders o_1,
        lineitem l_2
      WHERE
        c_0.c_custkey = o_1.o_custkey
        AND o_1.o_orderkey = l_2.l_orderkey
        AND c_0.c_mktsegment = 4
    ) t
),
bb_customer AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a2 AS a0
      FROM
        sfr s_0
        INNER JOIN customer c_1 ON s_0.a2 = c_1.c_custkey
      WHERE
        c_1.c_mktsegment != 4.0
    ) t
),
yes_customer AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a2 AS a0
      FROM
        sfr s_0,
        customer c_1
      WHERE
        s_0.a2 = c_1.c_custkey
        AND c_1.c_mktsegment = 4
        AND NOT EXISTS (
          SELECT
            *
          FROM
            bb_customer neg_b_0
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
        s_0.a1 AS a1,
        s_0.a2 AS a2
      FROM
        sfr s_0
        INNER JOIN lineitem l_1 ON s_0.a0 = l_1.l_linenumber
        AND s_0.a1 = l_1.l_orderkey
        LEFT OUTER JOIN yes_customer y_2 ON s_0.a2 = y_2.a0
      WHERE
        y_2.a0 IS NULL
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
        s_0.a3 AS a1,
        s_0.a4 AS a2
      FROM
        sfr s_0
        INNER JOIN orders o_1 ON s_0.a1 = o_1.o_orderkey
        LEFT OUTER JOIN yes_lineitem y_2 ON s_0.a1 = o_1.o_orderkey
        AND o_1.o_orderkey = y_2.a0
        AND o_1.o_custkey = y_2.a1
      WHERE
        o_1.o_orderkey IS NULL
        OR y_2.a0 IS NULL
        OR y_2.a1 IS NULL
        OR o_1.o_orderdate != s_0.a3
        OR o_1.o_shippriority != s_0.a4
    ) t
)
SELECT
  DISTINCT *
FROM
  (
    SELECT
      s_0.a1 AS a0,
      s_0.a3 AS a1,
      s_0.a4 AS a2
    FROM
      sfr s_0,
      orders o_1
    WHERE
      s_0.a1 = o_1.o_orderkey
      AND s_0.a2 = o_1.o_custkey
      AND s_0.a3 = o_1.o_orderdate
      AND s_0.a4 = o_1.o_shippriority
      AND NOT EXISTS (
        SELECT
          *
        FROM
          bb_orders neg_b_0
        WHERE
          neg_b_0.a0 = s_0.a1
          AND neg_b_0.a1 = s_0.a3
          AND neg_b_0.a2 = s_0.a4
      )
  ) t;

