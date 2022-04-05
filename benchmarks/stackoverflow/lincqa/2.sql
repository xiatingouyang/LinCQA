with candidate as (
	select P.Id as PostId, U.Id as UserId, U.DisplayName
	from Posts P, Users U
	where P.OwnerUserId = U.Id and P.Tags like "<c++>"
)


Users_bad_key as (
	select Id 
	from (
		select distinct Id, DisplayName
		from Users
	) t
	group by Id 
	having count(*) > 1
),

Users_good_join as (
	select U.Id, U.DisplayName
	from Users U
	where not exists (
		select * 
		from Users_bad_key
		where U.Id = Users_bad_key.Id
	)
),

Posts_bad_key as (
	select P.Id 
	from Posts P
	where Posts.Tags not like "<c++>"

	union all

	select P.Id 
	from Posts P
	join candidate C on C.PostId = P.Id 
	left outer join Users_good_join on (P.OwnerUserId = Users_good_join.Id and C.DisplayName = Users_good_join.DisplayName)
	where (Users_good_join.Id is NULL or Users_good_join.DisplayName is NULL)
),

Posts_good_join as (
	select P.Id, C.DisplayName
	from Posts P
	join candidate C on (P.Id = C.PostId)
	where not exists (
		select *
		from Posts_bad_key
		where P.Pid = Posts_bad_key.Id
	)
)

SELECT DISTINCT Posts_good_join.DisplayName
FROM Posts_good_join
