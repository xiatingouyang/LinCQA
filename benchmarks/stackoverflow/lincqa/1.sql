with Users_bad_key as (
	select Id
	from (
		select distinct Id, DisplayName
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
		where Users.Id = Users_bad_key.UserId
	)
),

Votes_bad_key as (
	select UserId
	from (
		select distinct UserId, PostId
		from Votes
	) t 
	group by UserId 
	having count(*) > 1
),

Votes_good_join as (
	select UserId, PostId
	from Votes 
	where not exists (
		select *
		from Votes_bad_key
		where Votes.UserId = Votes_bad_key.UserId and Votes.PostId = Votes_bad_key.PostId
	)
),

Comments_bad_key as (
	select UserId
	from (
		select distinct UserId, PostId
		from Comments
	) t 
	group by UserId 
	having count(*) > 1

	union 

	select UserId
	from Comments 
	left outer join Votes_good_join on Comments.UserId = Votes_good_join.UserId and Comments.PostId = Votes_good_join.PostId
	where Votes_good_join.UserId is NULL or Votes_good_join.PostId is NULL
),

Comments_good_join as (
	select UserId, PostId
	from Comments
	where not exists (
		select *
		from Comments_bad_key
		where Comments.UserId = Comments_bad_key.UserId
	)
),

Posts_bad_key as (
	select Id 
	from Posts 
	left outer join Comments_good_join on Posts.Id = Comments_good_join.PostId and Posts.OwnerUserId = Comments_good_join.UserId
	where Comments_good_join.PostId is NULL or Comments_good_join.UserId is NULL
),

Posts_good_join as (
	select Users_good_join.DisplayName
	from Posts, Users_good_join
	where Posts.OwnerUserId = Users_good_join.Id
	and not exists (
		select *
		from Posts_bad_key
		where Posts.Id = Posts_bad_key.Id
	)
)

select distinct DisplayName
from Posts_good_join
