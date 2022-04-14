WITH Candidates_lineitem AS (
        SELECT DISTINCT lineitem.l_orderkey, lineitem.l_linenumber FROM part, lineitem WHERE lineitem.l_partkey = part.p_partkey AND part.p_container = 2926595
), 
        Filter_lineitem AS (
                SELECT C.l_orderkey, C.l_linenumber FROM Candidates_lineitem C JOIN lineitem ON C.l_orderkey = lineitem.l_orderkey AND C.l_linenumber = lineitem.l_linenumber LEFT OUTER JOIN part ON lineitem.l_partkey = part.p_partkey WHERE (part.p_partkey IS NULL OR part.p_container != 2926595) UNION ALL SELECT C.l_orderkey, C.l_linenumber FROM Candidates_lineitem C GROUP BY C.l_orderkey, C.l_linenumber HAVING COUNT(*) > 1
)
        SELECT DISTINCT 'true' FROM Candidates_lineitem C WHERE NOT EXISTS (SELECT * FROM Filter_lineitem F WHERE C.l_orderkey = F.l_orderkey AND C.l_linenumber = F.l_linenumber)
