WITH Candidates_supplier_part_partsupp AS (
  SELECT
    DISTINCT supplier.s_suppkey,
    part.p_partkey,
    partsupp.ps_partkey,
    partsupp.ps_suppkey,
    supplier.s_acctbal,
    supplier.s_name,
    nation.n_name,
    part.p_mfgr,
    supplier.s_address,
    supplier.s_phone,
    supplier.s_comment
  FROM
    nation,
    supplier,
    region,
    part,
    partsupp
  WHERE
    partsupp.ps_partkey = part.p_partkey
    AND partsupp.ps_suppkey = supplier.s_suppkey
    AND nation.n_regionkey = region.r_regionkey
    AND supplier.s_nationkey = nation.n_nationkey
    AND part.p_size = 15
    AND region.r_name = 3250192
),
Filter_supplier_part_partsupp AS (
  SELECT
    C.s_suppkey,
    C.p_partkey,
    C.ps_partkey,
    C.ps_suppkey
  FROM
    Candidates_supplier_part_partsupp C
    JOIN supplier ON C.s_suppkey = supplier.s_suppkey
    JOIN part ON C.p_partkey = part.p_partkey
    JOIN partsupp ON C.ps_partkey = partsupp.ps_partkey
    AND C.ps_suppkey = partsupp.ps_suppkey
    LEFT OUTER JOIN nation ON supplier.s_nationkey = nation.n_nationkey
    LEFT OUTER JOIN region ON nation.n_regionkey = region.r_regionkey
  WHERE
    partsupp.ps_partkey = part.p_partkey
    AND partsupp.ps_suppkey = supplier.s_suppkey
    AND (
      nation.n_nationkey IS NULL
      OR region.r_regionkey IS NULL
      OR part.p_size != 15
      OR region.r_name != 3250192
    )
  UNION ALL
  SELECT
    C.s_suppkey,
    C.p_partkey,
    C.ps_partkey,
    C.ps_suppkey
  FROM
    Candidates_supplier_part_partsupp C
  GROUP BY
    C.s_suppkey,
    C.p_partkey,
    C.ps_partkey,
    C.ps_suppkey
  HAVING
    COUNT(*) > 1
)
SELECT
  DISTINCT s_acctbal,
  s_name,
  n_name,
  p_partkey,
  p_mfgr,
  s_address,
  s_phone,
  s_comment
FROM
  Candidates_supplier_part_partsupp C
WHERE
  NOT EXISTS (
    SELECT
      *
    FROM
      Filter_supplier_part_partsupp F
    WHERE
      C.s_suppkey = F.s_suppkey
      AND C.p_partkey = F.p_partkey
      AND C.ps_partkey = F.ps_partkey
      AND C.ps_suppkey = F.ps_suppkey
  )

