WITH Candidates_orders_lineitem AS (
        SELECT DISTINCT orders.o_orderkey, lineitem.l_orderkey, lineitem.l_linenumber, lineitem.l_shipmode FROM orders, lineitem WHERE lineitem.l_orderkey = orders.o_orderkey
), 
        Filter_orders_lineitem AS (
                SELECT C.o_orderkey, C.l_orderkey, C.l_linenumber FROM Candidates_orders_lineitem C GROUP BY C.o_orderkey, C.l_orderkey, C.l_linenumber HAVING COUNT(*) > 1
)
        SELECT DISTINCT l_shipmode FROM Candidates_orders_lineitem C WHERE NOT EXISTS (SELECT * FROM Filter_orders_lineitem F WHERE C.o_orderkey = F.o_orderkey AND C.l_orderkey = F.l_orderkey AND C.l_linenumber = F.l_linenumber)
