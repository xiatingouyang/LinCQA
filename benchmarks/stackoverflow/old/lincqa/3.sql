with 
-- PostLinks_good_join as (
-- 	select PostId 
-- 	from PostLinks
-- ),


-- PostHistory_good_join as (
-- 	select PH.PostId 
-- 	from PostHistory PH
-- 	where PH.PostHistoryTypeId = 5
-- ),


Posts_bad_key as (
	select Id 
	from (
		select distinct Id, Title 
		from Posts 
	) t
	group by Id 
	having count(*) > 1

	union all 

	select P.Id 
	from Posts P 
	where P.AnswerCount < 50

	union all 

	select P.Id
	from Posts P
	left outer join PostLinks on (P.Id = PostLinks.PostId)
	left outer join PostHistory on (P.Id = PostHistory.PostId and PostHistory.PostHistoryTypeId = 5)
	where (PostLinks.PostId is NULL) or (PostHistory.PostId is NULL)
),

Posts_good_join as (
	select P.Title 
	from Posts P
	where not exists (
		select *
		from Posts_bad_key
		where P.Id = Posts_bad_key.Id
	)
)

select distinct Title 
from Posts_good_join

