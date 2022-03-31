with conference_bad_key as (
	select conf_key
	from conference
	where name <> 5337
),

conference_good_key as (
	select conference.conf_key
	from conference
	where not exists (
		select *
		from conference_bad_key
		where conference.conf_key = conference_bad_key.conf_key
	)
),

paper_bad_key as (
	select paper.paper_key
	from paper 
	left outer join conference_good_key on paper.conf_key = conference_good_key.conf_key 
	where conference_good_key.conf_key is NULL

	union 

	select paper_key
	from (
		select distinct paper_key, title 
		from paper 
	) tmp
	group by paper_key 
	having count(*) > 1
),

paper_good_join as (
	select paper.title 
	from paper
	where not exists (
		select * 
		from paper_bad_key
		where paper.paper_key = paper_bad_key.paper_key
	)
)


SELECT distinct paper_good_join.title
FROM paper_good_join
