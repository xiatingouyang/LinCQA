
with lineitem_bad_key as (
	select l_orderkey, l_linenumber
	from lineitem
	where l_quantity <> 13
),

lineitem_good_join as (
	select distinct 1 as bool_as
	from lineitem
	where not exists (
		select * from lineitem_bad_key where lineitem.l_orderkey = lineitem_bad_key.l_orderkey 
					and lineitem.l_linenumber = lineitem_bad_key.l_linenumber

	)
)


select distinct 1 from lineitem_good_join

