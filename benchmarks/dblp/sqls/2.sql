SELECT distinct P.title
FROM paper P, conference C
WHERE P.conf_key = C.conf_key and C.name = 5337
