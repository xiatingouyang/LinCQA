select distinct part.p_brand, part.p_type, part.p_size from partsupp, part where part.p_partkey = partsupp.ps_partkey
