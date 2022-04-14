Select DISTINCT P.Id, P.Title
FROM Posts P, PostHistory PH, Votes V, Comments C 
WHERE P.Tags LIKE "%SQL%" AND P.id = PH.PostId AND P.id = C.PostId AND P.id = V.PostId AND V.BountyAmount > 100 AND PH.PostHistoryTypeId = 2 AND C.score = 0
