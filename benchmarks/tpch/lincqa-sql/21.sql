with Candidates as (
	select lineitem.l_orderkey, lineitem.l_linenumber, supplier.s_name 
	from supplier, lineitem, orders, nation 
	where supplier.s_suppkey = lineitem.l_suppkey 
	and orders.o_orderkey = lineitem.l_orderkey 
	and orders.o_orderstatus = 590240 
	and supplier.s_nationkey = nation.n_nationkey 
	and nation.n_name = 3164286
),

orders_bad_key as (
	select o_orderkey
	from orders
	where orders.o_orderstatus <> 590240 
),

orders_good_join as (
	select o_orderkey
	from orders
	where not exists (
		select * from orders_bad_key where orders.o_orderkey = orders_bad_key.o_orderkey
	)
),

nation_bad_key as (
	select n_nationkey 
	from nation 
	where nation.n_name <> 3164286
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
		select distinct s_suppkey, s_name
		from supplier
	) t 
	group by s_suppkey
	having count(*) > 1
 	
 	union 

 	select s_suppkey
 	from supplier
 	left outer join nation_good_join on (supplier.s_nationkey = nation_good_join.n_nationkey)
 	where (nation_good_join.n_nationkey is NULL)
),

supplier_good_join as (
	select s_suppkey, s_name
	from supplier
	where not exists (
		select * from supplier_bad_key
		where supplier.s_suppkey = supplier_bad_key.s_suppkey
	)

),


lineitem_bad_key as (
	select lineitem.l_orderkey, lineitem.l_linenumber
	from lineitem
	join Candidates C on (lineitem.l_orderkey = C.l_orderkey and lineitem.l_linenumber = C.l_linenumber)
	left outer join orders_good_join on (lineitem.l_orderkey = orders_good_join.o_orderkey)
	left outer join supplier_good_join on (lineitem.l_suppkey = supplier_good_join.s_suppkey and C.s_name = supplier_good_join.s_name)
	where (orders_good_join.o_orderkey is NULL or supplier_good_join.s_suppkey is NULL or supplier_good_join.s_name is NULL)
),

lineitem_good_join as (
	select C.s_name
	from lineitem
	join Candidates C on (lineitem.l_orderkey = C.l_orderkey and lineitem.l_linenumber = C.l_linenumber)
	where not exists (
		select * from lineitem_bad_key where lineitem.l_orderkey = lineitem_bad_key.l_orderkey and lineitem.l_linenumber = lineitem_bad_key.l_linenumber

	)
)

select distinct s_name from lineitem_good_join



