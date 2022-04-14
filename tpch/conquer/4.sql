WITH Candidates_orders AS (
        SELECT DISTINCT orders.o_orderkey, orders.o_orderpriority FROM orders
), 
        Filter_orders AS (
                SELECT C.o_orderkey FROM Candidates_orders C GROUP BY C.o_orderkey HAVING COUNT(*) > 1
)
        SELECT DISTINCT o_orderpriority FROM Candidates_orders C WHERE NOT EXISTS (SELECT * FROM Filter_orders F WHERE C.o_orderkey = F.o_orderkey)
