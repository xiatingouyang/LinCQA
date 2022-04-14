--------------------------

--- ERROR SOMEWHERE???????

-------------------------

WITH Candidates as (

	select 
		supplier.s_suppkey,
		supplier.s_acctbal, 
		supplier.s_name, 
		nation.n_name, 
		part.p_partkey, 
		part.p_mfgr, 
		supplier.s_address, 
		supplier.s_phone, 
		supplier.s_comment 
	from 
		part, supplier, partsupp, nation, region 
	where part.p_partkey = partsupp.ps_partkey 
			and supplier.s_suppkey = partsupp.ps_suppkey 
			and part.p_size = 15 
			and supplier.s_nationkey = nation.n_nationkey 
			and nation.n_regionkey = region.r_regionkey 
			and region.r_name = 3250192

),


partsupp_good_join as (
	select distinct ps_suppkey, ps_partkey
	from partsupp
),

region_bad_key as (
	select r_regionkey
	from region 
	where r_name <> 3250192
),

region_good_join as (
	select r_regionkey
	from region 
	where not exists (select * from region_bad_key where region.r_regionkey = region_bad_key.r_regionkey)
),

nation_bad_key as (
	select n_nationkey
	from (
		select distinct n_nationkey, n_name
		from nation
	) t
	group by n_nationkey
	having count(*) > 1

	union 

	select nation.n_nationkey
	from nation
	left outer join region_good_join on (nation.n_regionkey = region_good_join.r_regionkey)
	where (region_good_join.r_regionkey is NULL)

),

nation_good_join as (
	select n_nationkey, n_name
	from nation 
	where not exists (
		select * from nation_bad_key where nation_bad_key.n_nationkey = nation.n_nationkey	
	)
),



supplier_bad_key as (

	select t2.s_suppkey, C.n_name
	from (
		select s_suppkey
		from (
			select distinct
				supplier.s_suppkey,
				supplier.s_name, 
				supplier.s_address, 
				supplier.s_phone, 
				supplier.s_acctbal, 
				supplier.s_comment
			from supplier

		) t1
		group by s_suppkey
		having count(*) > 1
	) t2 
	join Candidates C on (t2.s_suppkey = C.s_suppkey)

	union all

	select supplier.s_suppkey, C.n_name
	from supplier
	join Candidates C on (supplier.s_suppkey = C.s_suppkey)
	left outer join nation_good_join on 
		(supplier.s_nationkey = nation_good_join.n_nationkey 
			     and C.n_name = nation_good_join.n_name)
	left outer join partsupp_good_join on 
		(supplier.s_suppkey = partsupp_good_join.ps_suppkey 
			and C.p_partkey = partsupp_good_join.ps_partkey)
	where (
		nation_good_join.n_nationkey is NULL 
		or nation_good_join.n_name is NULL 
		or partsupp_good_join.ps_suppkey is NULL 
		or partsupp_good_join.ps_partkey is NULL)
),

supplier_good_join as (
	select 
		supplier.s_suppkey,
		supplier.s_name, 
		supplier.s_address, 
		supplier.s_phone, 
		supplier.s_acctbal, 
		supplier.s_comment,
		C.n_name,
		C.p_partkey
	from supplier
	join Candidates C on (
		supplier.s_suppkey = C.s_suppkey 
	)
	where not exists (
		select * from supplier_bad_key 
		where supplier.s_suppkey = supplier_bad_key.s_suppkey and C.n_name = supplier_bad_key.n_name
	)

),

part_bad_key as (
	select p_partkey
	from (
		select distinct p_partkey, p_mfgr
		from part 
	) t 
	group by p_partkey
	having count(*) > 1

	union all

	select p_partkey
	from part 
	where p_size <> 15
),

part_good_join as (
	select part.p_partkey, part.p_mfgr
	from part 
	where not exists (
		select * from part_bad_key where part.p_partkey = part_bad_key.p_partkey
	)
)
-- select * from supplier_good_join
-- select * from part_good_join


select distinct
		supplier_good_join.s_name, 
		supplier_good_join.s_address, 
		supplier_good_join.s_phone, 
		supplier_good_join.s_acctbal, 
		supplier_good_join.s_comment,
		supplier_good_join.n_name,
		part_good_join.p_partkey,
		part_good_join.p_mfgr
from supplier_good_join
inner hash join part_good_join on (supplier_good_join.p_partkey = part_good_join.p_partkey) 




