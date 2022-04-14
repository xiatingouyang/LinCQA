WITH r_2_good_join as (
	select R_2.A21
	from R_2
),

r_1_bad_key as (
select R_1.A11
from R_1
left outer join r_2_good_join on R_1.A12 = r_2_good_join.A21
where (r_2_good_join.A21 is null)

union

select A11
from (

	select distinct R_1.A11, R_1.A13
	from R_1

) t
group by A11
having count(*) > 1

),

r_1_good_join as (
	select R_1.A13
	from R_1
	where not exists
	(select * from r_1_bad_key where R_1.A11 = r_1_bad_key.A11)
)

select distinct A13
from r_1_good_join

