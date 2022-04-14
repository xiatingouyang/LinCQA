select distinct partsupp.ps_partkey from partsupp, supplier, nation where partsupp.ps_suppkey = supplier.s_suppkey and supplier.s_nationkey = nation.n_nationkey and nation.n_name = 3164273
