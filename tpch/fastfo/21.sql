WITH sfr AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        l_1.l_linenumber AS a0,
        l_1.l_orderkey AS a1,
        s_0.s_suppkey AS a2,
        s_0.s_nationkey AS a3,
        s_0.s_name AS a4
      FROM
        supplier s_0,
        lineitem l_1,
        orders o_2,
        nation n_3
      WHERE
        s_0.s_suppkey = l_1.l_suppkey
        AND s_0.s_nationkey = n_3.n_nationkey
        AND l_1.l_orderkey = o_2.o_orderkey
        AND o_2.o_orderstatus = 590240
        AND n_3.n_name = 3164286
    ) t
),
bb_nation AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a3 AS a0
      FROM
        sfr s_0
        INNER JOIN nation n_1 ON s_0.a3 = n_1.n_nationkey
      WHERE
        n_1.n_name != 3164286.0
    ) t
),
yes_nation AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a3 AS a0
      FROM
        sfr s_0,
        nation n_1
      WHERE
        s_0.a3 = n_1.n_nationkey
        AND n_1.n_name = 3164286
        AND NOT EXISTS (
          SELECT
            *
          FROM
            bb_nation neg_b_0
          WHERE
            neg_b_0.a0 = s_0.a3
        )
    ) t
),
bb_supplier AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a2 AS a0,
        s_0.a4 AS a1
      FROM
        sfr s_0
        INNER JOIN supplier s_1 ON s_0.a2 = s_1.s_suppkey
        LEFT OUTER JOIN yes_nation y_2 ON s_1.s_nationkey = y_2.a0
      WHERE
        y_2.a0 IS NULL
        OR s_1.s_name != s_0.a4
    ) t
),
yes_supplier AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a2 AS a0,
        s_0.a4 AS a1
      FROM
        sfr s_0,
        supplier s_1
      WHERE
        s_0.a2 = s_1.s_suppkey
        AND s_0.a3 = s_1.s_nationkey
        AND s_0.a4 = s_1.s_name
        AND NOT EXISTS (
          SELECT
            *
          FROM
            bb_supplier neg_b_0
          WHERE
            neg_b_0.a0 = s_0.a2
            AND neg_b_0.a1 = s_0.a4
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
        s_0.a2 AS a1,
        s_0.a4 AS a2
      FROM
        sfr s_0
        INNER JOIN orders o_1 ON s_0.a1 = o_1.o_orderkey
        LEFT OUTER JOIN yes_supplier y_2 ON s_0.a2 = y_2.a0
        AND s_0.a4 = y_2.a1
      WHERE
        y_2.a0 IS NULL
        OR y_2.a1 IS NULL
        OR o_1.o_orderstatus != 590240.0
    ) t
),
yes_orders AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a1 AS a0,
        s_0.a2 AS a1,
        s_0.a4 AS a2
      FROM
        sfr s_0,
        orders o_1
      WHERE
        s_0.a1 = o_1.o_orderkey
        AND o_1.o_orderstatus = 590240
        AND NOT EXISTS (
          SELECT
            *
          FROM
            bb_orders neg_b_0
          WHERE
            neg_b_0.a0 = s_0.a1
            AND neg_b_0.a1 = s_0.a2
            AND neg_b_0.a2 = s_0.a4
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
        s_0.a4 AS a2
      FROM
        sfr s_0
        INNER JOIN lineitem l_1 ON s_0.a0 = l_1.l_linenumber
        AND s_0.a1 = l_1.l_orderkey
        LEFT OUTER JOIN yes_orders y_2 ON s_0.a1 = l_1.l_orderkey
        AND l_1.l_orderkey = y_2.a0
        AND s_0.a4 = y_2.a2
        AND l_1.l_suppkey = y_2.a1
      WHERE
        l_1.l_orderkey IS NULL
        OR y_2.a0 IS NULL
        OR y_2.a2 IS NULL
        OR y_2.a1 IS NULL
    ) t
)
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
      s_0.a0 = l_1.l_linenumber
      AND s_0.a1 = l_1.l_orderkey
      AND s_0.a2 = l_1.l_suppkey
      AND NOT EXISTS (
        SELECT
          *
        FROM
          bb_lineitem neg_b_0
        WHERE
          neg_b_0.a0 = s_0.a0
          AND neg_b_0.a1 = s_0.a1
          AND neg_b_0.a2 = s_0.a4
      )
  ) t;

