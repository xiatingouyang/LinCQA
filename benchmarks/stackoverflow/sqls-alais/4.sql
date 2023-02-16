SELECT DISTINCT U.Id, U.DisplayName
FROM Users U, Posts P, Comments C
WHERE C.UserId = U.Id AND C.PostId = P.Id AND P.Tags LIKE "%SQL%" AND C.Score > 5
