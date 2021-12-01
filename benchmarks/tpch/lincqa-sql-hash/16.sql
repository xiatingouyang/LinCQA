with Candidates as (
	select partsupp.ps_partkey, partsupp.ps_suppkey, part.p_brand, part.p_type, part.p_size 
	from partsupp, part where part.p_partkey = partsupp.ps_partkey

),

part_bad_key as (

	select p_partkey
	from (
		select distinct p_partkey, p_brand, p_type, p_size
		from part
	) t 
	group by p_partkey
	having count(*) > 1

),

part_good_join as (
	select part.p_partkey, part.p_brand, part.p_type, part.p_size
	from part 
	where not exists(
		select * from part_bad_key where part.p_partkey = part_bad_key.p_partkey
	)
),

partsupp_bad_key as (
	select partsupp.ps_partkey, partsupp.ps_suppkey
	from partsupp 
	inner hash join Candidates C on (partsupp.ps_partkey = C.ps_partkey and partsupp.ps_suppkey = C.ps_suppkey)
	left outer hash join part_good_join on (
			partsupp.ps_partkey = part_good_join.p_partkey and 
			C.p_brand = part_good_join.p_brand and 
			C.p_type = part_good_join.p_type and 
			C.p_size = part_good_join.p_size)
	where (part_good_join.p_partkey is NULL or part_good_join.p_brand is NULL or part_good_join.p_type is NULL or part_good_join.p_size is NULL)
),

partsupp_good_join as (
	select C.p_brand, C.p_type, C.p_size
	from partsupp 
	inner hash join Candidates C on (partsupp.ps_partkey = C.ps_partkey and partsupp.ps_suppkey = C.ps_suppkey)
	where not exists (
		select * from partsupp_bad_key 
		where partsupp.ps_partkey = partsupp_bad_key.ps_partkey and partsupp.ps_suppkey = partsupp_bad_key.ps_suppkey
	)
)

select distinct p_brand, p_type, p_size from partsupp_good_join



