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

SELECT DISTINCT P.Id as pid, C.UserId, C.CreationDate, U.Id as uid, U.DisplayName
into candidates
FROM Users U, Posts P, Comments C
WHERE C.UserId = U.Id AND C.PostId = P.Id AND P.Tags LIKE "%SQL%" AND C.Score > 5;
 


select P.Id 
into Posts_bad_key
from Posts  P 
join candidates on (P.Id = candidates.pid)
where P.Tags not like "%SQL%" or P.Tags is null;



select P.Id 
into Posts_good_join
from Posts  P 
join candidates  on (P.Id = candidates.pid)
where not exists (
	select *
	from Posts_bad_key
	where P.Id = Posts_bad_key.Id
);


with Comments_bad_key as (
	select C.UserId, C.CreationDate
	from Comments  C 
	join candidates on (C.UserID = candidates.UserId and C.CreationDate = candidates.CreationDate)
	where C.Score <= 5

	union all 

	select C.UserId, C.CreationDate
	from Comments  C 
	join candidates on (C.UserID = candidates.UserId and C.CreationDate = candidates.CreationDate)
	left outer join Posts_good_join on (C.PostId = Posts_good_join.Id)
	where Posts_good_join.Id is null
)

select *
into Comments_bad_key
from Comments_bad_key;



select C.UserId 
into Comments_good_join 
from Comments  C 
join candidates on (C.UserID = candidates.UserId and C.CreationDate = candidates.CreationDate)
where not exists (
	select *
	from Comments_bad_key
	where C.UserId = Comments_bad_key.UserId
	and C.CreationDate = Comments_bad_key.CreationDate
);


select Id 
into Users_bad_key
from (
	select distinct Id, DisplayName
	from Users
) t 
group by Id 
having count(*) > 1;




select U.Id, U.DisplayName
into Users_good_join
from users  U 
join candidates on (U.Id = candidates.uid)
where not exists (
	select *
	from Users_bad_key
	where U.Id = Users_bad_key.Id
);


select distinct Users_good_join.Id, Users_good_join.DisplayName
from Users_good_join, Comments_good_join
where Users_good_join.Id = Comments_good_join.UserId


-- SELECT DISTINCT U.Id, U.DisplayName
-- FROM Users U, Posts P, Comments C
-- WHERE C.UserId = U.Id AND C.PostId = P.Id AND P.Tags LIKE "%SQL%" AND C.Score > 5


