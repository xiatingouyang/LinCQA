SELECT distinct P.title
FROM paper P, citation CITE
WHERE P.paper_key = CITE.paper_cited_key and P.year = 1997
