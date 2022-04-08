drop table Posts_bad_key
drop table Posts_good_join
drop table Comments_bad_key
drop table Comments_good_join
drop table Users_bad_key
drop table Users_good_join


select P.Id 
into Posts_bad_key
from Posts  P 
where P.Tags not like "%SQL%" or P.Tags is null;



select P.Id 
into Posts_good_join
from Posts  P 
where not exists (
	select *
	from Posts_bad_key
	where P.Id = Posts_bad_key.Id
);


with Comments_bad_key as (
	select C.UserId, C.CreationDate
	from Comments  C 
	where C.Score <= 5

	union all 

	select C.UserId, C.CreationDate
	from Comments  C 
	left outer join Posts_good_join on (C.PostId = Posts_good_join.Id)
	where Posts_good_join.Id is null
)

select *
into Comments_bad_key
from Comments_bad_key;



select C.UserId 
into Comments_good_join 
from Comments  C 
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

