SELECT DISTINCT P.id, P.title 
FROM Posts P, Votes V
WHERE P.Id = V.PostId AND P.OwnerUserId = V.UserId AND BountyAmount > 100
