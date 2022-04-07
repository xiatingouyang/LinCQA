Select DISTINCT P.Id
FROM Users U, Posts P, Votes V, Comments C 
WHERE  P.id = C.PostId 
	AND P.id = V.PostId 
	AND U.Id = P.OwnerUserId 
	AND P.Tags LIKE "%SQL%"
	AND U.reputation > 100 
	AND V.BountyAmount > 100 
	AND C.score = 0

