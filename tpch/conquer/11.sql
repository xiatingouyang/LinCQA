WITH Candidates_supplier_partsupp AS (
        SELECT DISTINCT supplier.s_suppkey, partsupp.ps_partkey, partsupp.ps_suppkey FROM nation, supplier, partsupp WHERE supplier.s_suppkey = partsupp.ps_suppkey AND supplier.s_nationkey = nation.n_nationkey AND nation.n_name = 3164273
), 
        Filter_supplier_partsupp AS (
                SELECT C.s_suppkey, C.ps_partkey, C.ps_suppkey FROM Candidates_supplier_partsupp C JOIN supplier ON C.s_suppkey = supplier.s_suppkey JOIN partsupp ON C.ps_partkey = partsupp.ps_partkey AND C.ps_suppkey = partsupp.ps_suppkey LEFT OUTER JOIN nation ON supplier.s_nationkey = nation.n_nationkey WHERE supplier.s_suppkey = partsupp.ps_suppkey AND (nation.n_nationkey IS NULL OR nation.n_name != 3164273) UNION ALL SELECT C.s_suppkey, C.ps_partkey, C.ps_suppkey FROM Candidates_supplier_partsupp C GROUP BY C.s_suppkey, C.ps_partkey, C.ps_suppkey HAVING COUNT(*) > 1
)
        SELECT DISTINCT ps_partkey FROM Candidates_supplier_partsupp C WHERE NOT EXISTS (SELECT * FROM Filter_supplier_partsupp F WHERE C.s_suppkey = F.s_suppkey AND C.ps_partkey = F.ps_partkey AND C.ps_suppkey = F.ps_suppkey)
