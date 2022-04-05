SELECT U.DisplayName
FROM Users U, Posts P, Votes V, Comments C
WHERE U.Id = P.OwnerUserId AND U.Id = V.UserId AND U.Id = C.UserId
AND C.PostId = P.Id and C.PostId = V.PostId
