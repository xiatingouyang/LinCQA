with r_2_good_join AS (
	select distinct r_2.X2
	from r_2
),

r_1_bad_key AS (
	select r_1.X1
	from r_1
	left outer join r_2_good_join on (r_1.Y1 = r_2_good_join.X2)
	where r_2_good_join.X2 is NULL
),

r_1_good_join AS (
	select r_1.X1
	from r_1
	where not exists (
		select * from r_1_bad_key where r_1_bad_key.X1 = r_1.X1
	)
)

select distinct r_1_good_join.X1 from r_1_good_join
	