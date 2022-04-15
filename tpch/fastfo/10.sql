WITH sfr AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        c_0.c_accbal AS a0,
        c_0.c_address AS a1,
        c_0.c_comment AS a2,
        c_0.c_custkey AS a3,
        c_0.c_name AS a4,
        c_0.c_phone AS a5,
        l_2.l_linenumber AS a6,
        n_3.n_name AS a7,
        c_0.c_nationkey AS a8,
        o_1.o_orderkey AS a9
      FROM
        customer c_0,
        orders o_1,
        lineitem l_2,
        nation n_3
      WHERE
        c_0.c_custkey = o_1.o_custkey
        AND c_0.c_nationkey = n_3.n_nationkey
        AND o_1.o_orderkey = l_2.l_orderkey
        AND l_2.l_returnflag = 590239
    ) t
),
bb_nation AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a7 AS a0,
        s_0.a8 AS a1
      FROM
        sfr s_0
        INNER JOIN nation n_1 ON s_0.a8 = n_1.n_nationkey
      WHERE
        n_1.n_name != s_0.a7
    ) t
),
yes_nation AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a7 AS a0,
        s_0.a8 AS a1
      FROM
        sfr s_0,
        nation n_1
      WHERE
        s_0.a7 = n_1.n_name
        AND s_0.a8 = n_1.n_nationkey
        AND NOT EXISTS (
          SELECT
            *
          FROM
            bb_nation neg_b_0
          WHERE
            neg_b_0.a0 = s_0.a7
            AND neg_b_0.a1 = s_0.a8
        )
    ) t
),
bb_lineitem AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a6 AS a0,
        s_0.a7 AS a1,
        s_0.a8 AS a2,
        s_0.a9 AS a3
      FROM
        sfr s_0
        INNER JOIN lineitem l_1 ON s_0.a6 = l_1.l_linenumber
        AND s_0.a9 = l_1.l_orderkey
        LEFT OUTER JOIN yes_nation y_2 ON s_0.a7 = y_2.a0
        AND s_0.a8 = y_2.a1
      WHERE
        y_2.a0 IS NULL
        OR y_2.a1 IS NULL
        OR l_1.l_returnflag != 590239.0
    ) t
),
yes_lineitem AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a7 AS a0,
        s_0.a8 AS a1,
        s_0.a9 AS a2
      FROM
        sfr s_0,
        lineitem l_1
      WHERE
        s_0.a6 = l_1.l_linenumber
        AND s_0.a9 = l_1.l_orderkey
        AND l_1.l_returnflag = 590239
        AND NOT EXISTS (
          SELECT
            *
          FROM
            bb_lineitem neg_b_0
          WHERE
            neg_b_0.a0 = s_0.a6
            AND neg_b_0.a1 = s_0.a7
            AND neg_b_0.a2 = s_0.a8
            AND neg_b_0.a3 = s_0.a9
        )
    ) t
),
bb_orders AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a3 AS a0,
        s_0.a7 AS a1,
        s_0.a8 AS a2,
        s_0.a9 AS a3
      FROM
        sfr s_0
        INNER JOIN orders o_1 ON s_0.a9 = o_1.o_orderkey
        LEFT OUTER JOIN yes_lineitem y_2 ON s_0.a7 = y_2.a0
        AND s_0.a8 = y_2.a1
        AND s_0.a9 = o_1.o_orderkey
        AND o_1.o_orderkey = y_2.a2
      WHERE
        y_2.a0 IS NULL
        OR y_2.a1 IS NULL
        OR o_1.o_orderkey IS NULL
        OR y_2.a2 IS NULL
        OR o_1.o_custkey != s_0.a3
    ) t
),
yes_orders AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a3 AS a0,
        s_0.a7 AS a1,
        s_0.a8 AS a2
      FROM
        sfr s_0,
        orders o_1
      WHERE
        s_0.a3 = o_1.o_custkey
        AND s_0.a9 = o_1.o_orderkey
        AND NOT EXISTS (
          SELECT
            *
          FROM
            bb_orders neg_b_0
          WHERE
            neg_b_0.a0 = s_0.a3
            AND neg_b_0.a1 = s_0.a7
            AND neg_b_0.a2 = s_0.a8
            AND neg_b_0.a3 = s_0.a9
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
        s_0.a2 AS a2,
        s_0.a3 AS a3,
        s_0.a4 AS a4,
        s_0.a5 AS a5,
        s_0.a7 AS a6
      FROM
        sfr s_0
        INNER JOIN customer c_1 ON s_0.a3 = c_1.c_custkey
        LEFT OUTER JOIN yes_orders y_2 ON s_0.a3 = c_1.c_custkey
        AND c_1.c_custkey = y_2.a0
        AND s_0.a7 = y_2.a1
        AND c_1.c_nationkey = y_2.a2
      WHERE
        c_1.c_custkey IS NULL
        OR y_2.a0 IS NULL
        OR y_2.a1 IS NULL
        OR y_2.a2 IS NULL
        OR c_1.c_name != s_0.a4
        OR c_1.c_address != s_0.a1
        OR c_1.c_phone != s_0.a5
        OR c_1.c_accbal != s_0.a0
        OR c_1.c_comment != s_0.a2
    ) t
)
SELECT
  DISTINCT *
FROM
  (
    SELECT
      s_0.a3 AS a0,
      s_0.a4 AS a1,
      s_0.a0 AS a2,
      s_0.a7 AS a3,
      s_0.a1 AS a4,
      s_0.a5 AS a5,
      s_0.a2 AS a6
    FROM
      sfr s_0,
      customer c_1
    WHERE
      s_0.a0 = c_1.c_accbal
      AND s_0.a1 = c_1.c_address
      AND s_0.a2 = c_1.c_comment
      AND s_0.a3 = c_1.c_custkey
      AND s_0.a4 = c_1.c_name
      AND s_0.a5 = c_1.c_phone
      AND s_0.a8 = c_1.c_nationkey
      AND NOT EXISTS (
        SELECT
          *
        FROM
          bb_customer neg_b_0
        WHERE
          neg_b_0.a0 = s_0.a0
          AND neg_b_0.a1 = s_0.a1
          AND neg_b_0.a2 = s_0.a2
          AND neg_b_0.a3 = s_0.a3
          AND neg_b_0.a4 = s_0.a4
          AND neg_b_0.a5 = s_0.a5
          AND neg_b_0.a6 = s_0.a7
      )
  ) t;

