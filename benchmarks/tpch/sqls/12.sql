select distinct lineitem.l_shipmode from orders, lineitem where orders.o_orderkey = lineitem.l_orderkey
