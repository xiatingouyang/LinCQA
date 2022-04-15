WITH sfr AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        c_0.c_custkey AS a0,
        c_0.c_name AS a1,
        l_2.l_linenumber AS a2,
        o_1.o_orderdate AS a3,
        o_1.o_orderkey AS a4,
        o_1.o_totalprice AS a5
      FROM
        customer c_0,
        orders o_1,
        lineitem l_2
      WHERE
        c_0.c_custkey = o_1.o_custkey
        AND o_1.o_orderkey = l_2.l_orderkey
    ) t
),
yes_lineitem AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a4 AS a0
      FROM
        sfr s_0,
        lineitem l_1
      WHERE
        s_0.a2 = l_1.l_linenumber
        AND s_0.a4 = l_1.l_orderkey
    ) t
),
bb_orders AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a0 AS a0,
        s_0.a3 AS a1,
        s_0.a4 AS a2,
        s_0.a5 AS a3
      FROM
        sfr s_0
        INNER JOIN orders o_1 ON s_0.a4 = o_1.o_orderkey
        LEFT OUTER JOIN yes_lineitem y_2 ON s_0.a4 = o_1.o_orderkey
        AND o_1.o_orderkey = y_2.a0
      WHERE
        o_1.o_orderkey IS NULL
        OR y_2.a0 IS NULL
        OR o_1.o_custkey != s_0.a0
        OR o_1.o_totalprice != s_0.a5
        OR o_1.o_orderdate != s_0.a3
    ) t
),
yes_orders AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a0 AS a0,
        s_0.a3 AS a1,
        s_0.a4 AS a2,
        s_0.a4 AS a3,
        s_0.a5 AS a4
      FROM
        sfr s_0,
        orders o_1
      WHERE
        s_0.a0 = o_1.o_custkey
        AND s_0.a3 = o_1.o_orderdate
        AND s_0.a4 = o_1.o_orderkey
        AND s_0.a5 = o_1.o_totalprice
        AND NOT EXISTS (
          SELECT
            *
          FROM
            bb_orders neg_b_0
          WHERE
            neg_b_0.a0 = s_0.a0
            AND neg_b_0.a1 = s_0.a3
            AND neg_b_0.a2 = s_0.a4
            AND neg_b_0.a3 = s_0.a5
        )
    ) t
),
bb_customer AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a0 AS a0,
        s_0.a1 AS a1,
        s_0.a3 AS a2,
        s_0.a4 AS a3,
        s_0.a5 AS a4
      FROM
        sfr s_0
        INNER JOIN customer c_1 ON s_0.a0 = c_1.c_custkey
        LEFT OUTER JOIN yes_orders y_2 ON s_0.a0 = c_1.c_custkey
        AND c_1.c_custkey = y_2.a0
        AND s_0.a3 = y_2.a1
        AND s_0.a4 = y_2.a2
        AND y_2.a2 = y_2.a3
        AND s_0.a5 = y_2.a4
      WHERE
        c_1.c_custkey IS NULL
        OR y_2.a0 IS NULL
        OR y_2.a1 IS NULL
        OR y_2.a2 IS NULL
        OR y_2.a3 IS NULL
        OR y_2.a4 IS NULL
        OR c_1.c_name != s_0.a1
    ) t
)
SELECT
  DISTINCT *
FROM
  (
    SELECT
      s_0.a1 AS a0,
      s_0.a0 AS a1,
      s_0.a4 AS a2,
      s_0.a3 AS a3,
      s_0.a5 AS a4
    FROM
      sfr s_0,
      customer c_1
    WHERE
      s_0.a0 = c_1.c_custkey
      AND s_0.a1 = c_1.c_name
      AND NOT EXISTS (
        SELECT
          *
        FROM
          bb_customer neg_b_0
        WHERE
          neg_b_0.a0 = s_0.a0
          AND neg_b_0.a1 = s_0.a1
          AND neg_b_0.a2 = s_0.a3
          AND neg_b_0.a3 = s_0.a4
          AND neg_b_0.a4 = s_0.a5
      )
  ) t;

