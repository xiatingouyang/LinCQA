WITH Candidates_lineitem_orders AS (
        SELECT DISTINCT lineitem.l_orderkey, lineitem.l_linenumber, orders.o_orderkey, supplier.s_name FROM lineitem, supplier, nation, orders WHERE orders.o_orderkey = lineitem.l_orderkey AND lineitem.l_suppkey = supplier.s_suppkey AND supplier.s_nationkey = nation.n_nationkey AND orders.o_orderstatus = 590240 AND nation.n_name = 3164286
), 
        Filter_lineitem_orders AS (
                SELECT C.l_orderkey, C.l_linenumber, C.o_orderkey FROM Candidates_lineitem_orders C JOIN lineitem ON C.l_orderkey = lineitem.l_orderkey AND C.l_linenumber = lineitem.l_linenumber JOIN orders ON C.o_orderkey = orders.o_orderkey LEFT OUTER JOIN supplier ON lineitem.l_suppkey = supplier.s_suppkey LEFT OUTER JOIN nation ON supplier.s_nationkey = nation.n_nationkey WHERE orders.o_orderkey = lineitem.l_orderkey AND (supplier.s_suppkey IS NULL OR nation.n_nationkey IS NULL OR orders.o_orderstatus != 590240 OR nation.n_name != 3164286) UNION ALL SELECT C.l_orderkey, C.l_linenumber, C.o_orderkey FROM Candidates_lineitem_orders C GROUP BY C.l_orderkey, C.l_linenumber, C.o_orderkey HAVING COUNT(*) > 1
)
        SELECT DISTINCT s_name FROM Candidates_lineitem_orders C WHERE NOT EXISTS (SELECT * FROM Filter_lineitem_orders F WHERE C.l_orderkey = F.l_orderkey AND C.l_linenumber = F.l_linenumber AND C.o_orderkey = F.o_orderkey)
