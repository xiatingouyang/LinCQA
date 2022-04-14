WITH Candidates_lineitem AS (
        SELECT DISTINCT lineitem.l_orderkey, lineitem.l_linenumber, lineitem.l_returnflag, lineitem.l_linestatus FROM lineitem
), 
        Filter_lineitem AS (
                SELECT C.l_orderkey, C.l_linenumber FROM Candidates_lineitem C GROUP BY C.l_orderkey, C.l_linenumber HAVING COUNT(*) > 1
)
        SELECT DISTINCT l_returnflag, l_linestatus FROM Candidates_lineitem C WHERE NOT EXISTS (SELECT * FROM Filter_lineitem F WHERE C.l_orderkey = F.l_orderkey AND C.l_linenumber = F.l_linenumber)
