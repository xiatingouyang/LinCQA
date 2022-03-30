SELECT distinct P.title
FROM author A, paper P, conference C, citation CITE
WHERE A.paper_key = CITE.paper_cited_key and CITE.paper_cite_key = P.paper_key and P.conf_key = C.conf_key and C.name = 5337
