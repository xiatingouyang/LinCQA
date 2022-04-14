WITH lineitem_bad_key AS (

	select l_orderkey, l_linenumber
	from (
		select distinct lineitem.l_orderkey, lineitem.l_linenumber, lineitem.l_returnflag, lineitem.l_linestatus
		from lineitem
	) t
	group by l_orderkey, l_linenumber
	having count(*) > 1
),
lineitem_good_join AS (
	select l_returnflag, l_linestatus
	from lineitem 
	where not exists (
			select * from lineitem_bad_key where lineitem.l_orderkey = lineitem_bad_key.l_orderkey and lineitem.l_linenumber = lineitem_bad_key.l_orderkey

		)
)


select distinct l_returnflag, l_linestatus from lineitem_good_join

