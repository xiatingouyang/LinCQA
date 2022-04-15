WITH sfr AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        n_3.n_name AS a0,
        s_1.s_nationkey AS a1,
        s_1.s_suppkey AS a2,
        p_0.p_mfgr AS a3,
        p_0.p_partkey AS a4,
        n_3.n_regionkey AS a5,
        s_1.s_acctbal AS a6,
        s_1.s_address AS a7,
        s_1.s_comment AS a8,
        s_1.s_name AS a9,
        s_1.s_phone AS a10
      FROM
        part p_0,
        supplier s_1,
        partsupp p_2,
        nation n_3,
        region r_4
      WHERE
        p_0.p_partkey = p_2.ps_partkey
        AND s_1.s_suppkey = p_2.ps_suppkey
        AND s_1.s_nationkey = n_3.n_nationkey
        AND n_3.n_regionkey = r_4.r_regionkey
        AND p_0.p_size = 15
        AND r_4.r_name = 3250192
    ) t
),
bb_region AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a5 AS a0
      FROM
        sfr s_0
        INNER JOIN region r_1 ON s_0.a5 = r_1.r_regionkey
      WHERE
        r_1.r_name != 3250192.0
    ) t
),
yes_region AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a5 AS a0
      FROM
        sfr s_0,
        region r_1
      WHERE
        s_0.a5 = r_1.r_regionkey
        AND r_1.r_name = 3250192
        AND NOT EXISTS (
          SELECT
            *
          FROM
            bb_region neg_b_0
          WHERE
            neg_b_0.a0 = s_0.a5
        )
    ) t
),
bb_nation AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a0 AS a0,
        s_0.a1 AS a1
      FROM
        sfr s_0
        INNER JOIN nation n_1 ON s_0.a1 = n_1.n_nationkey
        LEFT OUTER JOIN yes_region y_2 ON n_1.n_regionkey = y_2.a0
      WHERE
        y_2.a0 IS NULL
        OR n_1.n_name != s_0.a0
    ) t
),
yes_nation AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a0 AS a0,
        s_0.a1 AS a1
      FROM
        sfr s_0,
        nation n_1
      WHERE
        s_0.a0 = n_1.n_name
        AND s_0.a1 = n_1.n_nationkey
        AND s_0.a5 = n_1.n_regionkey
        AND NOT EXISTS (
          SELECT
            *
          FROM
            bb_nation neg_b_0
          WHERE
            neg_b_0.a0 = s_0.a0
            AND neg_b_0.a1 = s_0.a1
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
        s_0.a4 AS a3
      FROM
        sfr s_0
        INNER JOIN partsupp p_1 ON s_0.a2 = p_1.ps_suppkey
        AND s_0.a4 = p_1.ps_partkey
        LEFT OUTER JOIN yes_nation y_2 ON s_0.a0 = y_2.a0
        AND s_0.a1 = y_2.a1
      WHERE
        y_2.a0 IS NULL
        OR y_2.a1 IS NULL
    ) t
),
yes_partsupp AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a0 AS a0,
        s_0.a1 AS a1,
        s_0.a2 AS a2,
        s_0.a4 AS a3
      FROM
        sfr s_0,
        partsupp p_1
      WHERE
        s_0.a2 = p_1.ps_suppkey
        AND s_0.a4 = p_1.ps_partkey
        AND NOT EXISTS (
          SELECT
            *
          FROM
            bb_partsupp neg_b_0
          WHERE
            neg_b_0.a0 = s_0.a0
            AND neg_b_0.a1 = s_0.a1
            AND neg_b_0.a2 = s_0.a2
            AND neg_b_0.a3 = s_0.a4
        )
    ) t
),
bb_supplier AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a0 AS a0,
        s_0.a2 AS a1,
        s_0.a4 AS a2,
        s_0.a6 AS a3,
        s_0.a7 AS a4,
        s_0.a8 AS a5,
        s_0.a9 AS a6,
        s_0.a10 AS a7
      FROM
        sfr s_0
        INNER JOIN supplier s_1 ON s_0.a2 = s_1.s_suppkey
        LEFT OUTER JOIN yes_partsupp y_2 ON s_0.a0 = y_2.a0
        AND s_0.a2 = s_1.s_suppkey
        AND s_1.s_suppkey = y_2.a2
        AND s_0.a4 = y_2.a3
        AND s_1.s_nationkey = y_2.a1
      WHERE
        y_2.a0 IS NULL
        OR s_1.s_suppkey IS NULL
        OR y_2.a2 IS NULL
        OR y_2.a3 IS NULL
        OR y_2.a1 IS NULL
        OR s_1.s_name != s_0.a9
        OR s_1.s_address != s_0.a7
        OR s_1.s_phone != s_0.a10
        OR s_1.s_acctbal != s_0.a6
        OR s_1.s_comment != s_0.a8
    ) t
),
yes_supplier AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a0 AS a0,
        s_0.a4 AS a1,
        s_0.a6 AS a2,
        s_0.a7 AS a3,
        s_0.a8 AS a4,
        s_0.a9 AS a5,
        s_0.a10 AS a6
      FROM
        sfr s_0,
        supplier s_1
      WHERE
        s_0.a1 = s_1.s_nationkey
        AND s_0.a2 = s_1.s_suppkey
        AND s_0.a6 = s_1.s_acctbal
        AND s_0.a7 = s_1.s_address
        AND s_0.a8 = s_1.s_comment
        AND s_0.a9 = s_1.s_name
        AND s_0.a10 = s_1.s_phone
        AND NOT EXISTS (
          SELECT
            *
          FROM
            bb_supplier neg_b_0
          WHERE
            neg_b_0.a0 = s_0.a0
            AND neg_b_0.a1 = s_0.a2
            AND neg_b_0.a2 = s_0.a4
            AND neg_b_0.a3 = s_0.a6
            AND neg_b_0.a4 = s_0.a7
            AND neg_b_0.a5 = s_0.a8
            AND neg_b_0.a6 = s_0.a9
            AND neg_b_0.a7 = s_0.a10
        )
    ) t
),
bb_part AS (
  SELECT
    DISTINCT *
  FROM
    (
      SELECT
        s_0.a0 AS a0,
        s_0.a3 AS a1,
        s_0.a4 AS a2,
        s_0.a6 AS a3,
        s_0.a7 AS a4,
        s_0.a8 AS a5,
        s_0.a9 AS a6,
        s_0.a10 AS a7
      FROM
        sfr s_0
        INNER JOIN part p_1 ON s_0.a4 = p_1.p_partkey
        LEFT OUTER JOIN yes_supplier y_2 ON s_0.a0 = y_2.a0
        AND s_0.a4 = p_1.p_partkey
        AND p_1.p_partkey = y_2.a1
        AND s_0.a6 = y_2.a2
        AND s_0.a7 = y_2.a3
        AND s_0.a8 = y_2.a4
        AND s_0.a9 = y_2.a5
        AND s_0.a10 = y_2.a6
      WHERE
        y_2.a0 IS NULL
        OR p_1.p_partkey IS NULL
        OR y_2.a1 IS NULL
        OR y_2.a2 IS NULL
        OR y_2.a3 IS NULL
        OR y_2.a4 IS NULL
        OR y_2.a5 IS NULL
        OR y_2.a6 IS NULL
        OR p_1.p_mfgr != s_0.a3
        OR p_1.p_size != 15.0
    ) t
)
SELECT
  DISTINCT *
FROM
  (
    SELECT
      s_0.a6 AS a0,
      s_0.a9 AS a1,
      s_0.a0 AS a2,
      s_0.a4 AS a3,
      s_0.a3 AS a4,
      s_0.a7 AS a5,
      s_0.a10 AS a6,
      s_0.a8 AS a7
    FROM
      sfr s_0,
      part p_1
    WHERE
      s_0.a3 = p_1.p_mfgr
      AND s_0.a4 = p_1.p_partkey
      AND p_1.p_size = 15
      AND NOT EXISTS (
        SELECT
          *
        FROM
          bb_part neg_b_0
        WHERE
          neg_b_0.a0 = s_0.a0
          AND neg_b_0.a1 = s_0.a3
          AND neg_b_0.a2 = s_0.a4
          AND neg_b_0.a3 = s_0.a6
          AND neg_b_0.a4 = s_0.a7
          AND neg_b_0.a5 = s_0.a8
          AND neg_b_0.a6 = s_0.a9
          AND neg_b_0.a7 = s_0.a10
      )
  ) t;

