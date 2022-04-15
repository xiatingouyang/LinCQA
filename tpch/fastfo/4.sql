WITH sfr AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        o_0.o_orderkey AS a0,
        o_0.o_orderpriority AS a1
      FROM
        orders o_0
    ) t
),
bb_orders AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a0 AS a0,
        s_0.a1 AS a1
      FROM
        sfr s_0
        INNER JOIN orders o_1 ON s_0.a0 = o_1.o_orderkey
      WHERE
        o_1.o_orderpriority != s_0.a1
    ) t
)
SELECT
  DISTINCT *
FROM
  (
    SELECT
      s_0.a1 AS a0
    FROM
      sfr s_0,
      orders o_1
    WHERE
      s_0.a0 = o_1.o_orderkey
      AND s_0.a1 = o_1.o_orderpriority
      AND NOT EXISTS (
        SELECT
          *
        FROM
          bb_orders neg_b_0
        WHERE
          neg_b_0.a0 = s_0.a0
          AND neg_b_0.a1 = s_0.a1
      )
  ) t;

