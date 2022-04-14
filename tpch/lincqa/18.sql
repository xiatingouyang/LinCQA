--------------------------

--- ERROR SOMEWHERE???????

-------------------------

with customer_bad_key as (
	select c_custkey
	from (
		select distinct c_custkey, c_name 
		from customer
	) t 
	group by c_custkey
	having count(*) > 1
),

customer_good_join as (
	select customer.c_custkey, customer.c_name 
	from customer 
	where not exists 
	(select * from customer_bad_key where customer.c_custkey = customer_bad_key.c_custkey) 
),

orders_bad_key as (
	select o_orderkey
	from (
		select distinct o_orderkey, o_custkey, o_totalprice, o_orderdate
		from orders 
	) t 
	group by o_orderkey
	having count(*) > 1
),

orders_good_join as (
	select o_orderkey, o_custkey, o_totalprice, o_orderdate
	from orders  
	where not exists (
		select * from orders_bad_key where orders.o_orderkey = orders_bad_key.o_orderkey
	)
),

lineitem_good_join as (
	select distinct l_orderkey
	from lineitem
)

select distinct 
	customer_good_join.c_name, 
	customer_good_join.c_custkey, 
	orders_good_join.o_orderkey, 
	orders_good_join.o_orderdate, 
	orders_good_join.o_totalprice
from customer_good_join, orders_good_join, lineitem_good_join
where customer_good_join.c_custkey = orders_good_join.o_custkey and orders_good_join.o_orderkey = lineitem_good_join.l_orderkey

