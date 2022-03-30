SELECT distinct A.name
FROM author A, paper P, conference C
WHERE A.paper_key = P.paper_key and P.conf_key = C.conf_key and C.name = 5337
