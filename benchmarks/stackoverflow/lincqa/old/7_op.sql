with candidates as (
	Select DISTINCT C.UserId, C.CreationDate, P.Id, P.Title
	FROM Users U, Posts P, PostHistory PH, Votes V, Comments C 
	WHERE P.Tags LIKE "%SQL%" AND P.id = PH.PostId AND P.id = C.PostId AND P.id = V.PostId AND U.Id = P.OwnerUserId AND U.reputation > 100 AND V.BountyAmount > 100 AND PH.PostHistoryTypeId = 2 AND C.score = 0
),

Users_bad_key as (
	select Id 
	from Users U 
	where U.reputation <= 100
),

Users_good_join as (
	select U.Id
	from Users U 
	where not exists (
		select *
		from Users_bad_key
		where U.Id = Users_bad_key.Id
	)
),

Votes_bad_key as (
	select V.UserId, V.PostId, V.CreationDate
	from Votes V
	where V.BountyAmount <= 100 
),

Votes_good_join as (
	select V.PostId 
	from Votes V 
	where not exists (
		select *
		from Votes_bad_key
		where V.UserId = Votes_bad_key.UserId 
		and V.PostId = Votes_bad_key.PostId 
		and V.CreationDate = Votes_bad_key.CreationDate
	)
),

PostHistory_good_join as (
	select distinct PostId 
	from PostHistory
	where PostHistoryTypeId = 2
),

Posts_bad_key as (
	select Id 
	from (
		select distinct Id, Title 
		from Posts
	) t
	group by Id 
	having count(*) > 1 

	union all  

	select P.Id 
	from Posts P 
	left outer join Users_good_join on (P.OwnerUserId = Users_good_join.Id)
	where Users_good_join.Id is null
),

Posts_good_join as (
	select P.Id 
	from Posts P
	where not exists (
		select *
		from Posts_bad_key
		where P.Id = Posts_bad_key.Id
	)
),

Comments_bad_key as (
	select C.UserId, C.CreationDate, candidates.Id, candidates.Title
	from Comments C
	join candidates on C.UserId = candidates.UserId and C.CreationDate = candidates.CreationDate 
	where C.score <> 0

	union all 

	select C.UserId, C.CreationDate, candidates.Id, candidates.Title
	from Comments C
	join candidates on C.UserId = candidates.UserId and C.CreationDate = candidates.CreationDate 
	left outer join PostHistory_good_join on (C.PostId = PostHistory_good_join.PostId)
	left outer join Posts_good_join on (C.PostId = Posts_good_join.Id)
	left outer join Votes_good_join on (C.PostId = Votes_good_join.PostId)
	where (PostHistory_good_join.PostId is null or Posts_good_join.Id is null or Votes_good_join.PostId is null)
),

Comments_good_join as (
	select candidates.Id, candidates.Title
	from Comments C 
	join candidates on C.UserId = candidates.UserId and C.CreationDate = candidates.CreationDate 
	where not exists (
		select *
		from Comments_bad_key 
		where C.UserId = Comments_bad_key.UserId and 
			C.CreationDate = Comments_bad_key.CreationDate and  
			candidates.Id = Comments_bad_key.Id and 
			candidates.Title = Comments_bad_key.Title
	)
)

select distinct Id, Title 
from Comments_good_join


-- Select DISTINCT P.Id, P.Title
-- FROM Users U, Posts P, PostHistory PH, Votes V, Comments C 
-- WHERE P.Tags LIKE "%SQL%" AND P.id = PH.PostId AND P.id = C.PostId AND P.id = V.PostId AND U.Id = P.OwnerUserId 
-- AND U.reputation > 100 
-- AND V.BountyAmount > 100 
-- AND PH.PostHistoryTypeId = 2 
-- AND C.score = 0


