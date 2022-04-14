with orders_bad_key as (
	select o_orderkey
	from (
		select distinct o_orderkey, o_orderpriority
		from orders
	) t 
	group by o_orderkey
	having count(*) > 1
),

orders_good_join as (
	select orders.o_orderpriority
	from orders
	where not exists (
		select * from orders_bad_key where orders.o_orderkey = orders_bad_key.o_orderkey
	)

)

select distinct o_orderpriority from orders_good_join

