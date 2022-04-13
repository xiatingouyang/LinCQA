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

select B.UserId 
into Badges_good_join
from Badges B 
where B.name = "Illuminator";



select Id 
into Users_bad_key
from (
	select Id, DisplayName
	from Users
) t
group by Id 
having count(*) > 1;



select Id, DisplayName
into Users_good_join
from Users 
where not exists (
	select *
	from Users_bad_key
	where Users.Id = Users_bad_key.Id
);


select distinct Id, DisplayName
from Users_good_join, Badges_good_join
where Users_good_join.Id = Badges_good_join.UserId
