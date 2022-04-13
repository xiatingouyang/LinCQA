
select distinct Posts_good_join.Id, Posts_good_join.title 
from Votes_good_join, Posts_good_join
where Posts_good_join.Id = Votes_good_join.PostId

