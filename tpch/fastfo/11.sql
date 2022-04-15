WITH sfr AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_1.s_nationkey AS a0,
        p_0.ps_partkey AS a1,
        p_0.ps_suppkey AS a2
      FROM
        partsupp p_0,
        supplier s_1,
        nation n_2
      WHERE
        p_0.ps_suppkey = s_1.s_suppkey
        AND s_1.s_nationkey = n_2.n_nationkey
        AND n_2.n_name = 3164273
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
        n_1.n_name != 3164273.0
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
        AND n_1.n_name = 3164273
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
        s_0.a2 AS a0
      FROM
        sfr s_0
        INNER JOIN supplier s_1 ON s_0.a2 = s_1.s_suppkey
        LEFT OUTER JOIN yes_nation y_2 ON s_1.s_nationkey = y_2.a0
      WHERE
        y_2.a0 IS NULL
    ) t
),
yes_supplier AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a2 AS a0
      FROM
        sfr s_0,
        supplier s_1
      WHERE
        s_0.a0 = s_1.s_nationkey
        AND s_0.a2 = s_1.s_suppkey
        AND NOT EXISTS (
          SELECT
            *
          FROM
            bb_supplier neg_b_0
          WHERE
            neg_b_0.a0 = s_0.a2
        )
    ) t
),
bb_partsupp AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a1 AS a0,
        s_0.a2 AS a1
      FROM
        sfr s_0
        INNER JOIN partsupp p_1 ON s_0.a1 = p_1.ps_partkey
        AND s_0.a2 = p_1.ps_suppkey
        LEFT OUTER JOIN yes_supplier y_2 ON s_0.a2 = p_1.ps_suppkey
        AND p_1.ps_suppkey = y_2.a0
      WHERE
        p_1.ps_suppkey IS NULL
        OR y_2.a0 IS NULL
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
      partsupp p_1
    WHERE
      s_0.a1 = p_1.ps_partkey
      AND s_0.a2 = p_1.ps_suppkey
      AND NOT EXISTS (
        SELECT
          *
        FROM
          bb_partsupp neg_b_0
        WHERE
          neg_b_0.a0 = s_0.a1
          AND neg_b_0.a1 = s_0.a2
      )
  ) t;

