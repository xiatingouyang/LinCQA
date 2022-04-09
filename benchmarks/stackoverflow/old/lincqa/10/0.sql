SELECT DISTINCT P.id, P.title, V.PostId, V.UserId, V.CreationDate
into candidates 
FROM Posts P, Votes V
WHERE P.Id = V.PostId AND P.OwnerUserId = V.UserId AND BountyAmount > 100
