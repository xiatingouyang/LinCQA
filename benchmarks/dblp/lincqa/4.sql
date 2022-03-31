with cite_good_join as (
	select paper_cited_key
	from citation
),


paper_bad_key as (
	select paper_key
	from paper
	where year <> 1997

	union 

	select paper_key 
	from (
		select distinct paper_key, title
		from paper 
	) tmp
	group by paper_key
	having count(*) > 1

	union 

	select paper_key 
	from paper 
	left outer join cite_good_join on paper.paper_key = cite_good_join.paper_cited_key
	where cite_good_join.paper_cited_key is NULL
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
