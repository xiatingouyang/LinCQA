drop table candidates;

drop table Users_bad_key;
drop table Users_good_join;

drop table Posts_bad_key;
drop table Posts_good_join;

drop table PostHistory_bad_key;
drop table PostHistory_good_join;

drop table Comments_bad_key;
drop table Comments_good_join;

drop table Badges_bad_key;
drop table Badges_good_join;

drop table Votes_bad_key;
drop table Votes_good_join;


SELECT DISTINCT P.Id, P.title, V.PostId, V.UserId, V.CreationDate
into candidates 
FROM Posts P, Votes V
WHERE P.Id = V.PostId AND P.OwnerUserId = V.UserId AND BountyAmount > 100;
GO

select V.PostId, V.UserId, V.CreationDate 
into Votes_bad_key
from Votes V
join candidates on (V.PostId = candidates.PostId and V.UserId = candidates.UserId and V.CreationDate = candidates.CreationDate)
where V.BountyAmount <= 100;





select V.PostId, V.UserId
into Votes_good_join
from Votes V
join candidates on V.PostId = candidates.PostId and V.UserId = candidates.UserId and V.CreationDate = candidates.CreationDate
where not exists (
        select *
        from Votes_bad_key
        where
        V.PostId = Votes_bad_key.PostId and
        V.UserId = Votes_bad_key.UserId and
        V.CreationDate = Votes_bad_key.CreationDate
);



with Posts_bad_key as (
       select Id 
       from (
       	    select distinct id, Title
	          from Posts 
       ) t
       group by Id 
       having count(*) > 1

       union all 

       select P.Id 
       from Posts P
       join candidates on P.Id = candidates.Id and P.Title = candidates.Title
       left outer join Votes_good_join on (P.OwnerUserId = Votes_good_join.UserId)
       where Votes_good_join.UserId is null
)
select * into Posts_bad_key
from Posts_bad_key;



select P.Id, P.Title
into Posts_good_join
from Posts P
join candidates on P.Id = candidates.Id and P.Title = candidates.Title
where not exists (
    select * 
    from Posts_bad_key
    where P.Id = Posts_bad_key.Id 
);



select distinct Posts_good_join.Id, Posts_good_join.title 
from Votes_good_join, Posts_good_join
where Posts_good_join.Id = Votes_good_join.PostId


