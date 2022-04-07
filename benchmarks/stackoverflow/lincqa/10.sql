drop table candidates
drop table Votes_bad_key
drop table Votes_good_join
drop table Posts_bad_key
drop table Posts_good_join



SELECT DISTINCT P.id, P.title, V.PostId, V.UserId, V.CreationDate
into candidates 
FROM Posts P, Votes V
WHERE P.Id = V.PostId AND P.OwnerUserId = V.UserId AND BountyAmount > 100;


select V.PostId, V.UserId, V.CreationDate 
into Votes_bad_key
from Votes V
join candidates C on V.PostId = C.PostId and V.UserId = C.UserId and V.CreationDate = C.CreationDate
where V.BountyAmount <= 100;





select V.PostId, V.UserId
into Votes_good_join
from Votes V
join candidates C on V.PostId = C.PostId and V.UserId = C.UserId and V.CreationDate = C.CreationDate
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
       join candidates C on P.Id = C.Id and P.Title = C.Title
       left outer join Votes_good_join on (P.OwnerUserId = Votes_good_join.UserId)
       where Votes_good_join.UserId is null
)
select * into Posts_bad_key
from Posts_bad_key;



select P.Id, P.Title
into Posts_good_join
from Posts P
join candidates C on P.Id = C.Id and P.Title = C.Title
where not exists (
    select * 
    from Posts_bad_key
    where P.Id = Posts_bad_key.Id 
);



select distinct Posts_good_join.Id, Posts_good_join.title 
from Votes_good_join, Posts_good_join
where Posts_good_join.Id = Votes_good_join.PostId


