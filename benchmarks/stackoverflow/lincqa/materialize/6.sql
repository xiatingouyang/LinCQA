drop table candidate
drop table candidates

drop table Users_bad_key
drop table Users_good_join

drop table Posts_bad_key
drop table Posts_good_join

drop table PostHistory_bad_key
drop table PostHistory_good_join

drop table Comments_bad_key
drop table Comments_good_join

drop table Badges_bad_key
drop table Badges_good_join

drop table Votes_bad_key
drop table Votes_good_Join

drop table PostHistory_bad_key
drop table PostHistory_good_join

Select DISTINCT C.UserId, C.CreationDate, P.Id, P.Title
into candidates
FROM Posts P, PostHistory PH, Votes V, Comments C 
WHERE P.Tags LIKE "%SQL%" AND P.id = PH.PostId AND P.id = C.PostId AND P.id = V.PostId AND V.BountyAmount > 100 AND PH.PostHistoryTypeId = 2 AND C.score = 0;


with Posts_bad_key as (
	select P.Id 
	from Posts P
	where P.Tags not LIKE "%SQL%" or P.Tags is null

	union all  

	select Id 
	from (
		select distinct Id, Title
		from Posts
	)t 
	group by Id 
	having count(*) > 1
)

select *
into Posts_bad_key
from Posts_bad_key;



select P.Id, P.Title
into Posts_good_join 
from Posts P 
where not exists (
	select *
	from Posts_bad_key
	where P.Id = Posts_bad_key.Id
);



select PH.PostId, PH.CreationDate, PH.UserId, PH.PostHistoryTypeId 
into PostHistory_bad_key
from PostHistory PH
where PH.PostHistoryTypeId <> 2;




select PH.PostId 
into PostHistory_good_join
from PostHistory PH 
where not exists (
	select *
	from PostHistory_bad_key
	where PH.PostId = PostHistory_bad_key.PostId and 
		PH.CreationDate = PostHistory_bad_key.CreationDate and  
		PH.UserId = PostHistory_bad_key.UserId and  
		PH.PostHistoryTypeId = PostHistory_bad_key.PostHistoryTypeId
)



select V.PostId, V.UserId, V.CreationDate
into Votes_bad_key
from Votes V 
where V.BountyAmount <= 100 or V.BountyAmount is null;





select V.PostId 
into Votes_good_join
from Votes V 
where not exists (
	select *
	from Votes_bad_key
	where
	V.PostId = Votes_bad_key.PostId and  
	V.UserId = Votes_bad_key.UserId and  
	V.CreationDate = Votes_bad_key.CreationDate
);


with Comments_bad_key as (
	select C.CreationDate, C.UserId, candidates.Title	
	from Comments C 
	join candidates on (C.CreationDate = candidates.CreationDate and C.UserId = candidates.UserId)
	where C.score <> 0


	union all 

	select C.CreationDate, C.UserId, candidates.Title
	from Comments C 
	join candidates on (C.CreationDate = candidates.CreationDate and C.UserId = candidates.UserId)
	left outer join Posts_good_join on (C.PostId = Posts_good_join.Id and candidates.Title = Posts_good_join.Title)
	left outer join PostHistory_good_join on (C.PostId = PostHistory_good_join.PostId)
	left outer join Votes_good_join on (C.PostId = Votes_good_join.PostId)
	where (
		Posts_good_join.Id is NULL or PostHistory_good_join.PostId is NULL or Votes_good_join.PostId is NULL
		or Posts_good_join.Title is NULL
	)
)

select *
into Comments_bad_key
from Comments_bad_key;



select candidates.Title
into Comments_good_join	
from Comments C 
join candidates on (C.CreationDate = candidates.CreationDate and C.UserId = candidates.UserId)
where not exists (
	select * 
	from Comments_bad_key
	where C.CreationDate = Comments_bad_key.CreationDate
	and C.UserId = Comments_bad_key.UserId
	and candidates.Title = Comments_bad_key.Title
);


select distinct Title
from Comments_good_join


