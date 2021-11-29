WITH Candidates_lineitem AS (
        SELECT DISTINCT lineitem.l_orderkey, lineitem.l_linenumber FROM lineitem WHERE lineitem.l_quantity = 13
), 
        Filter_lineitem AS (
                SELECT C.l_orderkey, C.l_linenumber FROM Candidates_lineitem C GROUP BY C.l_orderkey, C.l_linenumber HAVING COUNT(*) > 1
)
        SELECT DISTINCT 'true' FROM Candidates_lineitem C WHERE NOT EXISTS (SELECT * FROM Filter_lineitem F WHERE C.l_orderkey = F.l_orderkey AND C.l_linenumber = F.l_linenumber)
