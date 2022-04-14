WITH 
candidates as (
	select R_1.A11, R_1.A13, R_2.A21, R_7.A71, R_7.A73
	from R_1, R_2, R_7
	where R_1.A12 = R_2.A21 and R_2.A22 = R_7.A71
),

r_7_bad_key as (
	select A71
	from (

		select distinct R_7.A71, R_7.A73
		from R_7

	) t
	group by A71
	having count(*) > 1
),

r_7_good_join as (
	select R_7.A71, R_7.A73
	from R_7
	where not exists
	(select * from r_7_bad_key where R_7.A71 = r_7_bad_key.A71)
),


r_2_bad_key as (
	select R_2.A21, C.A73
	from R_2
	join candidates C on (R_2.A21 = C.A21)
	left outer join r_7_good_join on (R_2.A22 = r_7_good_join.A71 and C.A73 = r_7_good_join.A73)
	where (r_7_good_join.A71 is null or r_7_good_join.A73 is null)
),

r_2_good_join as (
	select R_2.A21, C.A73
	from R_2
	join candidates C on (R_2.A21 = C.A21)
	where not exists
	(select * from r_2_bad_key where R_2.A21 = r_2_bad_key.A21 and C.A73 = r_2_bad_key.A73)
),


r_1_bad_key as (
select R_1.A11, R_1.A13, C.A73
from R_1
join candidates C on (R_1.A11 = C.A11)
left outer join r_2_good_join on (R_1.A12 = r_2_good_join.A21 and C.A73 = r_2_good_join.A73)
where (r_2_good_join.A21 is null or r_2_good_join.A73 is null)
),

r_1_self_bad_key as (
select A11
from (
	select distinct R_1.A11, R_1.A13
	from R_1
) t
group by A11
having count(*) > 1
),

r_1_good_join as (
	select R_1.A13, C.A73
	from R_1
	join candidates C on (R_1.A11 = C.A11)
	where not exists
	(select * from r_1_bad_key where R_1.A11 = r_1_bad_key.A11 and C.A13 = r_1_bad_key.A13 and C.A73 = r_1_bad_key.A73)
	and not exists 
	(select * from r_1_self_bad_key where R_1.A11 = r_1_self_bad_key.A11)

)

select distinct A13, A73
from r_1_good_join


