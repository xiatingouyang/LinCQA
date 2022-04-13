with Badges_good_join as (
	select B.UserId 
	from Badges B 
	where B.name = "Illuminator"
),

Users_bad_key as (
	select Id 
	from (
		select Id, DisplayName
		from Users
	) t
	group by Id 
	having count(*) > 1
),

Users_good_join as (
	select Id, DisplayName
	from Users 
	where not exists (
		select *
		from Users_bad_key
		where Users.Id = Users_bad_key.Id
	)

)

select distinct Id, DisplayName
from Users_good_join, Badges_good_join
where Users_good_join.Id = Badges_good_join.UserId

