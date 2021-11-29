WITH Candidates_partsupp_part AS (
        SELECT DISTINCT partsupp.ps_partkey, partsupp.ps_suppkey, part.p_partkey, part.p_brand, part.p_type, part.p_size FROM partsupp, part WHERE part.p_partkey = partsupp.ps_partkey
), 
        Filter_partsupp_part AS (
                SELECT C.ps_partkey, C.ps_suppkey, C.p_partkey FROM Candidates_partsupp_part C GROUP BY C.ps_partkey, C.ps_suppkey, C.p_partkey HAVING COUNT(*) > 1
)
        SELECT DISTINCT p_brand, p_type, p_size FROM Candidates_partsupp_part C WHERE NOT EXISTS (SELECT * FROM Filter_partsupp_part F WHERE C.ps_partkey = F.ps_partkey AND C.ps_suppkey = F.ps_suppkey AND C.p_partkey = F.p_partkey)
