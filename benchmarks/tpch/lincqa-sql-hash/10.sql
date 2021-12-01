--------------------------

--- ERROR SOMEWHERE???????

-------------------------
-- select customer.c_custkey, customer.c_name, customer.c_accbal, customer.c_address, customer.c_phone, customer.c_comment, nation.n_name from customer, nation where customer.c_nationkey = nation.n_nationkey


with Candidates as (
	select 
		customer.c_custkey, 
		customer.c_name, 
		customer.c_accbal, 
		nation.n_name, 
		customer.c_address, 
		customer.c_phone, 
		customer.c_comment 
	from customer, nation, orders, lineitem
	where customer.c_custkey = orders.o_custkey and lineitem.l_orderkey = orders.o_orderkey and lineitem.l_returnflag = 590239 and customer.c_nationkey = nation.n_nationkey
),

nation_bad_key as (
	select n_nationkey from 
	(
		select distinct n_nationkey, n_name
		from nation 
	) t 
	group by n_nationkey
	having count(*) > 1
),

nation_good_join as (
	select n_nationkey, n_name 
	from nation 
	where not exists (
		select * from nation_bad_key where nation.n_nationkey = nation_bad_key.n_nationkey
	)

),

customer_bad_key_self as (
	
	select c_custkey
	from (
		select distinct c_custkey, c_name, c_accbal, c_address, c_phone, c_comment
		from customer
	) t
	group by c_custkey 
	having count(*) > 1
),

customer_bad_key_pair as (
	select 
		customer.c_custkey,
		C.n_name
	from customer
	inner hash join Candidates C on (customer.c_custkey = C.c_custkey)
	left outer hash join nation_good_join on (
		customer.c_nationkey = nation_good_join.n_nationkey and
		C.n_name = nation_good_join.n_name)
	where (nation_good_join.n_nationkey is NULL or nation_good_join.n_name is NULL)
),


customer_good_join as (
	select 
		customer.c_custkey, 
		customer.c_name, 
		customer.c_accbal, 
		customer.c_address, 
		customer.c_phone,
		customer.c_comment,
		C.n_name
	from customer
	inner hash join Candidates C on (customer.c_custkey = C.c_custkey)

	where not exists (
		select * from customer_bad_key_pair
		where customer.c_custkey = customer_bad_key_pair.c_custkey and   
				C.n_name = customer_bad_key_pair.n_name
	) and not exists (
		select * from customer_bad_key_self
		where customer.c_custkey = customer_bad_key_self.c_custkey
	)

),

lineitem_bad_key as (
	select l_orderkey, l_linenumber
	from lineitem
	where lineitem.l_returnflag <> 590239
),

lineitem_good_join as (
	select l_orderkey
	from lineitem 
	where not exists (
		select * from lineitem_bad_key 
		where lineitem.l_orderkey = lineitem_bad_key.l_orderkey and 
		lineitem.l_linenumber = lineitem_bad_key.l_linenumber
	)
),

orders_bad_key as (
	select o_orderkey 
	from (
		select distinct o_orderkey, o_custkey
		from orders
	) t 
	group by o_orderkey
	having count(*) > 1

	union 

	select o_orderkey 
	from orders
	left outer hash join lineitem_good_join on (orders.o_orderkey = lineitem_good_join.l_orderkey)
	where lineitem_good_join.l_orderkey is NULL
),

orders_good_join as (
	select o_custkey 
	from orders 
	where not exists (
		select * from orders_bad_key where orders.o_orderkey = orders_bad_key.o_orderkey
	)
)

select distinct
	customer_good_join.c_custkey, 
	customer_good_join.c_name, 
	customer_good_join.c_accbal, 
	customer_good_join.c_address, 
	customer_good_join.c_phone,
	customer_good_join.c_comment,
	customer_good_join.n_name
from customer_good_join, orders_good_join 
where customer_good_join.c_custkey = orders_good_join.o_custkey





