with Users_bad_key as (
	select U.Id 
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


Comments_bad_key as (
	select C.UserId, C.CreationDate
	from Comments C
	where C.score <> 0

	union all 

	select UserId, CreationDate
	from (
		select distinct UserId, CreationDate, PostId
		from Comments
	) t  
	group by UserId, CreationDate
	having count(*) > 1
),

Comments_good_join as (
	select C.PostId
	from Comments C 
	where not exists (
		select *
		from Comments_bad_key 
		where C.UserId = Comments_bad_key.UserId and 
			C.CreationDate = Comments_bad_key.CreationDate 
	)
),

Posts_bad_key as (
	select P.Id 
	from Posts P 
	left outer join Users_good_join on (P.OwnerUserId = Users_good_join.Id) 
	where (Users_good_join.Id is null)


	union all 

	select P.Id
	from Posts P 
	where P.Tags not LIKE "%SQL%" or P.Tags is null
),

Posts_good_key as (
	select P.Id 
	from Posts P 
	where not exists (
		select *
		from Posts_bad_key
		where P.Id = Posts_bad_key.Id
	)
)


select distinct Posts_good_key.Id 
from Posts_good_key, Comments_good_join, Votes_good_join
where Posts_good_key.Id = Comments_good_join.PostId 
and Comments_good_join.PostId = Votes_good_join.PostId 





-- Select DISTINCT P.Id
-- FROM Users U, Posts P, PostHistory PH, Votes V, Comments C 
-- WHERE 
-- 	P.id = PH.PostId AND 
-- 	P.id = C.PostId AND 
-- 	P.id = V.PostId AND 
-- 	U.Id = P.OwnerUserId AND 
-- 	P.Tags LIKE "%SQL%" AND 
-- 	U.reputation > 100 AND 
-- 	V.BountyAmount > 100 AND 
-- 	PH.PostHistoryTypeId = 2 AND 
-- 	C.score = 0


