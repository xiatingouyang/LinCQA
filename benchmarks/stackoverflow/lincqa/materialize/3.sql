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


select P.Id as PostId, U.Id as UserId, U.DisplayName
into candidate
from Posts P, Users U
where P.OwnerUserId = U.Id and P.Tags like "<c++>";




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
from Users U
where not exists (
	select * 
	from Users_bad_key
	where U.Id = Users_bad_key.Id
);


with Posts_bad_key as (
	select P.Id 
	from Posts P
	where P.Tags not like "<c++>"

	union all

	select P.Id 
	from Posts P
	join candidate C on C.PostId = P.Id 
	left outer join Users_good_join on (P.OwnerUserId = Users_good_join.Id and C.DisplayName = Users_good_join.DisplayName)
	where (Users_good_join.Id is NULL or Users_good_join.DisplayName is NULL)
)

select *
into Posts_bad_key
from Posts_bad_key;



select P.Id, C.DisplayName
into Posts_good_join
from Posts P
join candidate C on (P.Id = C.PostId)
where not exists (
	select *
	from Posts_bad_key
	where P.Id = Posts_bad_key.Id
);


SELECT DISTINCT DisplayName
FROM Posts_good_join
