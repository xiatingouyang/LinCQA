
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
from Posts_bad_key

