with r_3_good_join AS (
	select distinct r_3.X3
	from r_3
),

r_2_bad_key AS (
        select r_2.X2
        from r_2
        left outer join r_3_good_join on (r_2.Y2 = r_3_good_join.X3)
        where r_3_good_join.X3 is NULL
),

r_2_good_join AS (
        select r_2.X2
        from r_2
        where not exists (
                select * from r_2_bad_key where r_2_bad_key.X2 = r_2.X2
        )
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
	
