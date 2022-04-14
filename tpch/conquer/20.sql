WITH Candidates_supplier AS (
        SELECT DISTINCT supplier.s_suppkey, supplier.s_name, supplier.s_address FROM nation, supplier WHERE supplier.s_nationkey = nation.n_nationkey AND nation.n_name = 3164269
), 
        Filter_supplier AS (
                SELECT C.s_suppkey FROM Candidates_supplier C JOIN supplier ON C.s_suppkey = supplier.s_suppkey LEFT OUTER JOIN nation ON supplier.s_nationkey = nation.n_nationkey WHERE (nation.n_nationkey IS NULL OR nation.n_name != 3164269) UNION ALL SELECT C.s_suppkey FROM Candidates_supplier C GROUP BY C.s_suppkey HAVING COUNT(*) > 1
)
        SELECT DISTINCT s_name, s_address FROM Candidates_supplier C WHERE NOT EXISTS (SELECT * FROM Filter_supplier F WHERE C.s_suppkey = F.s_suppkey)
