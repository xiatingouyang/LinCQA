Select DISTINCT P.Id, P.Title
FROM Users U, Posts P, PostHistory PH, Votes V, Comments C 
WHERE P.Tags LIKE "%SQL%" AND P.id = PH.PostId AND P.id = C.PostId AND P.id = V.PostId AND U.Id = P.OwnerUserId AND U.reputation > 100 AND V.BountyAmount > 100 AND PH.PostHistoryTypeId = 2 AND C.score = 0
