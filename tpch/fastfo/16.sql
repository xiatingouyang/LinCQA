WITH sfr AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        p_0.ps_partkey AS a0,
        p_0.ps_suppkey AS a1,
        p_1.p_brand AS a2,
        p_1.p_size AS a3,
        p_1.p_type AS a4
      FROM
        partsupp p_0,
        part p_1
      WHERE
        p_0.ps_partkey = p_1.p_partkey
    ) t
),
bb_part AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a0 AS a0,
        s_0.a2 AS a1,
        s_0.a3 AS a2,
        s_0.a4 AS a3
      FROM
        sfr s_0
        INNER JOIN part p_1 ON s_0.a0 = p_1.p_partkey
      WHERE
        p_1.p_brand != s_0.a2
        OR p_1.p_type != s_0.a4
        OR p_1.p_size != s_0.a3
    ) t
),
yes_part AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a0 AS a0,
        s_0.a2 AS a1,
        s_0.a3 AS a2,
        s_0.a4 AS a3
      FROM
        sfr s_0,
        part p_1
      WHERE
        s_0.a0 = p_1.p_partkey
        AND s_0.a2 = p_1.p_brand
        AND s_0.a3 = p_1.p_size
        AND s_0.a4 = p_1.p_type
        AND NOT EXISTS (
          SELECT
            *
          FROM
            bb_part neg_b_0
          WHERE
            neg_b_0.a0 = s_0.a0
            AND neg_b_0.a1 = s_0.a2
            AND neg_b_0.a2 = s_0.a3
            AND neg_b_0.a3 = s_0.a4
        )
    ) t
),
bb_partsupp AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a0 AS a0,
        s_0.a1 AS a1,
        s_0.a2 AS a2,
        s_0.a3 AS a3,
        s_0.a4 AS a4
      FROM
        sfr s_0
        INNER JOIN partsupp p_1 ON s_0.a0 = p_1.ps_partkey
        AND s_0.a1 = p_1.ps_suppkey
        LEFT OUTER JOIN yes_part y_2 ON s_0.a0 = p_1.ps_partkey
        AND p_1.ps_partkey = y_2.a0
        AND s_0.a2 = y_2.a1
        AND s_0.a3 = y_2.a2
        AND s_0.a4 = y_2.a3
      WHERE
        p_1.ps_partkey IS NULL
        OR y_2.a0 IS NULL
        OR y_2.a1 IS NULL
        OR y_2.a2 IS NULL
        OR y_2.a3 IS NULL
    ) t
)
SELECT
  DISTINCT *
FROM
  (
    SELECT
      s_0.a2 AS a0,
      s_0.a4 AS a1,
      s_0.a3 AS a2
    FROM
      sfr s_0,
      partsupp p_1
    WHERE
      s_0.a0 = p_1.ps_partkey
      AND s_0.a1 = p_1.ps_suppkey
      AND NOT EXISTS (
        SELECT
          *
        FROM
          bb_partsupp neg_b_0
        WHERE
          neg_b_0.a0 = s_0.a0
          AND neg_b_0.a1 = s_0.a1
          AND neg_b_0.a2 = s_0.a2
          AND neg_b_0.a3 = s_0.a3
          AND neg_b_0.a4 = s_0.a4
      )
  ) t;

