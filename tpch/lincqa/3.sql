WITH candidates as (
	select distinct lineitem.l_orderkey,
					orders.o_orderkey, 
					orders.o_custkey,
					orders.o_orderdate, 
					orders.o_shippriority 
	from customer, orders, lineitem 
	where customer.c_mktsegment = 4 
		and customer.c_custkey = orders.o_custkey 
		and lineitem.l_orderkey = orders.o_orderkey
),


customer_bad_key AS (
	select c_custkey
	from customer
	where c_mktsegment <> 4
),

customer_good_join as (
	select c_custkey
	from customer 
	where not exists (
			select * from customer_bad_key where customer.c_custkey = customer_bad_key.c_custkey
		)
),

orders_bad_key as (
	select o_orderkey
	from (

			select distinct o_orderkey, o_orderdate, o_shippriority
			from candidates

		) t 
	group by o_orderkey
	having count(*) > 1

	union 

	select o_orderkey
	from candidates 
	left outer join customer_good_join on (candidates.o_custkey = customer_good_join.c_custkey)
	where customer_good_join.c_custkey is NULL
),

orders_good_join as (
	select candidates.o_orderkey, candidates.o_orderdate, candidates.o_shippriority
	from candidates
	where not exists (
		select * from orders_bad_key where candidates.o_orderkey = orders_bad_key.o_orderkey
	)
),

lineitem_good_join as (
	select distinct l_orderkey
	from candidates
)

select distinct 
	lineitem_good_join.l_orderkey, 
	orders_good_join.o_orderdate, 
	orders_good_join.o_shippriority

from lineitem_good_join, orders_good_join
where lineitem_good_join.l_orderkey = orders_good_join.o_orderkey


