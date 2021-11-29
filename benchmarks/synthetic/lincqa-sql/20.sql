WITH candidates as (
	select r_6.A61, r_5.A53 
	from r_5, r_6, r_9 
	where r_5.A51 = r_9.A91 and r_5.A52 = r_6.A62 and r_6.A62 = r_9.A92
),

r_9_bad_key as (
	select A91
	from (
		select distinct A91, A92
		from R_9 
	) t
	group by A91
	having count(*) > 1
),

r_9_good_join as (
	select R_9.A91, R_9.A92
	from R_9
	where not exists
	(select * from r_9_bad_key where R_9.A91 = r_9_bad_key.A91)
),

r_5_bad_key as (
	(
	select A51
	from (
		select distinct R_5.A51, R_5.A53
		from R_5
	) t
	group by A51
	having count(*) > 1
	)
	union
	(
	select R_5.A51
	from R_5
	left outer join r_9_good_join on (R_5.A51 = r_9_good_join.A91 and R_5.A52 = r_9_good_join.A92)
	where (r_9_good_join.A91 is null or r_9_good_join.A92 is null)
	)
),

r_5_good_join as (
	select R_5.A52, R_5.A53
	from R_5
	where not exists
	(select * from r_5_bad_key where R_5.A51 = r_5_bad_key.A51)

),

r_6_bad_key as (

	select R_6.A61, C.A53
	from R_6
	join candidates C on (C.A61 = R_6.A61)
	left outer join r_5_good_join on (R_6.A62 = r_5_good_join.A52 and r_5_good_join.A53 = C.A53)
	where (r_5_good_join.A52 is null or r_5_good_join.A53 is null)

),

r_6_good_join as (
	select C.A53
	from R_6
	join candidates C on (C.A61 = R_6.A61)
	where not exists
	(select * from r_6_bad_key where R_6.A61 = r_6_bad_key.A61 and C.A53 = r_6_bad_key.A53)
)

select distinct A53 from r_6_good_join
