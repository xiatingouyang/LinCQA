WITH Candidates_orders_lineitem AS (
        SELECT DISTINCT orders.o_orderkey, lineitem.l_orderkey, lineitem.l_linenumber, orders.o_orderdate, orders.o_shippriority FROM orders, customer, lineitem WHERE lineitem.l_orderkey = orders.o_orderkey AND orders.o_custkey = customer.c_custkey AND customer.c_mktsegment = 4
), 
        Filter_orders_lineitem AS (
                SELECT C.o_orderkey, C.l_orderkey, C.l_linenumber FROM Candidates_orders_lineitem C JOIN orders ON C.o_orderkey = orders.o_orderkey JOIN lineitem ON C.l_orderkey = lineitem.l_orderkey AND C.l_linenumber = lineitem.l_linenumber LEFT OUTER JOIN customer ON orders.o_custkey = customer.c_custkey WHERE lineitem.l_orderkey = orders.o_orderkey AND (customer.c_custkey IS NULL OR customer.c_mktsegment != 4) UNION ALL SELECT C.o_orderkey, C.l_orderkey, C.l_linenumber FROM Candidates_orders_lineitem C GROUP BY C.o_orderkey, C.l_orderkey, C.l_linenumber HAVING COUNT(*) > 1
)
        SELECT DISTINCT o_orderkey, o_orderdate, o_shippriority FROM Candidates_orders_lineitem C WHERE NOT EXISTS (SELECT * FROM Filter_orders_lineitem F WHERE C.o_orderkey = F.o_orderkey AND C.l_orderkey = F.l_orderkey AND C.l_linenumber = F.l_linenumber)