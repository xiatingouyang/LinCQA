
with nation_bad_key as (
	select n_nationkey
	from nation 
	where n_name <> 3164273
),

nation_good_join as (
	select n_nationkey 
	from nation
	where not exists 
		(select * from nation_bad_key where nation.n_nationkey = nation_bad_key.n_nationkey)
),

supplier_bad_key as (
	select s_suppkey
	from supplier
	left outer hash join nation_good_join on (supplier.s_nationkey = nation_good_join.n_nationkey)
	where (nation_good_join.n_nationkey is NULL)
),

supplier_good_join as (
	select s_suppkey
	from supplier
	where not exists (
		select * from supplier_bad_key where supplier.s_suppkey = supplier_bad_key.s_suppkey
	)
),

partsupp_bad_key as (
	select partsupp.ps_partkey, partsupp.ps_suppkey
	from partsupp
	left outer hash join supplier_good_join on partsupp.ps_suppkey = supplier_good_join.s_suppkey
	where (supplier_good_join.s_suppkey is NULL)
),

partsupp_good_join as (
	select ps_partkey
	from partsupp
	where not exists (
		select * from partsupp_bad_key where partsupp.ps_partkey = partsupp_bad_key.ps_partkey and partsupp.ps_suppkey = partsupp_bad_key.ps_suppkey 
	)
)

select distinct ps_partkey from partsupp_good_join


