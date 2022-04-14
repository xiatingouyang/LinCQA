with part_bad_key as (
	select p_partkey
	from part 
	where p_brand <> 2926403
),

part_good_join as (
	select part.p_partkey
	from part 
	where not exists (
		select * from part_bad_key where part.p_partkey = part_bad_key.p_partkey
	)
),

lineitem_bad_key as (
	select l_orderkey, l_linenumber
	from lineitem
	left outer join part_good_join on (lineitem.l_partkey = part_good_join.p_partkey)
	where (part_good_join.p_partkey is NULL)
),

lineitem_good_join as (
	select 1 as bool_ans 
	from lineitem 
	where not exists (
		select * from lineitem_bad_key where (lineitem.l_orderkey = lineitem_bad_key.l_orderkey and lineitem.l_linenumber = lineitem_bad_key.l_linenumber)
	)
)


select distinct bool_ans from lineitem_good_join
