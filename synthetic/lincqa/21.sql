WITH 
candidates as (
	select r_4.A41, r_3.A33 
	from r_3, r_4, r_10 
	where r_3.A31 = r_10.A101 and 
		r_3.A31 = r_4.A42 and 
		r_3.A32 = r_4.A41 and 
		r_4.A41 = r_10.A102
),

r_10_bad_key as (
	select A101
	from (
		select distinct A101, A102
		from R_10 
	) t
	group by A101
	having count(*) > 1
),

r_10_good_join as (
	select R_10.A101, R_10.A102
	from R_10
	where not exists
	(select * from r_10_bad_key where R_10.A101 = r_10_bad_key.A101)
),

r_3_bad_key as (
	(
	select A31
	from ( 
		select distinct R_3.A31, R_3.A33
		from R_3
	) t
	group by A31
	having count(*) > 1
	)

	union

	(
	select R_3.A31
	from R_3
	left outer join r_10_good_join on (R_3.A31 = r_10_good_join.A101 and R_3.A32 = r_10_good_join.A102)
	where (r_10_good_join.A101 is null or r_10_good_join.A102 is null)
	)
),

r_3_good_join as (
	select R_3.A31, R_3.A32, R_3.A33
	from R_3
	where not exists
	(select * from r_3_bad_key where R_3.A31 = r_3_bad_key.A31)

),

r_4_bad_key as (

	select R_4.A41, C.A33
	from R_4
	join candidates C on (C.A41 = R_4.A41)
	left outer join r_3_good_join on (R_4.A42 = r_3_good_join.A31 and R_4.A41 = r_3_good_join.A32 and r_3_good_join.A33 = C.A33)
	where (r_3_good_join.A31 is null or r_3_good_join.A32 is null or r_3_good_join.A33 is null)

),

r_4_good_join as (
	select C.A33
	from R_4
	join candidates C on (C.A41 = R_4.A41)
	where not exists
	(select * from r_4_bad_key where R_4.A41 = r_4_bad_key.A41 and C.A33 = r_4_bad_key.A33)
)



select distinct A33 from r_4_good_join 

