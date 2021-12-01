with orders_good_join as (
	select o_orderkey
	from orders
),

lineitem_bad_key as (

	select l_orderkey, l_linenumber
	from (
		select distinct l_orderkey, l_linenumber, l_shipmode
		from lineitem
	) t 
	group by l_orderkey, l_linenumber
	having count(*) > 1

	union all

	select l_orderkey, l_linenumber
	from lineitem 
	left outer hash join orders_good_join on (lineitem.l_orderkey = orders_good_join.o_orderkey)
	where (orders_good_join.o_orderkey is NULL)
),

lineitem_good_join as (
	select l_shipmode
	from lineitem
	where not exists (
		select * from lineitem_bad_key where lineitem.l_orderkey = lineitem_bad_key.l_orderkey and lineitem.l_linenumber = lineitem_bad_key.l_linenumber
	)
)

select distinct l_shipmode from lineitem_good_join

