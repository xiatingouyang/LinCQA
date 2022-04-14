with nation_bad_key as (
	select n_nationkey 
	from nation 
	where n_name <> 3164269
),

nation_good_join as (
	select n_nationkey 
	from nation 
	where not exists (
		select * from nation_bad_key where nation.n_nationkey = nation_bad_key.n_nationkey
	)
),


supplier_bad_key as (
	select s_suppkey
	from (
		select distinct s_suppkey, s_name, s_address
		from supplier
	) t 
	group by s_suppkey
	having count (*) > 1

	union 

	select s_suppkey 
	from supplier
	left outer join nation_good_join on (supplier.s_nationkey = nation_good_join.n_nationkey) 
	where (nation_good_join.n_nationkey is NULL)
),

supplier_good_join as (
	select s_suppkey, s_name, s_address
	from supplier
	where not exists (
		select * from supplier_bad_key where supplier.s_suppkey = supplier_bad_key.s_suppkey
	)
)


select distinct s_suppkey, s_name, s_address from supplier_good_join

