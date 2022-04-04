SELECT U.DisplayName
FROM Users U, Posts P, PostHistory PH, Votes V, Comments C, Badge B
WHERE U.UserId = C.UserId AND C.UserId = PH.UserId AND PH.UserId = V.UserId AND U.UserId = P.OwnerUserId AND U.DisplayName = PH.UserDisplayName AND P.Id = PH.PostId AND PH.PostId = C.PostId AND C.PostId = V.PostId AND AND PH.PostHistoryTypeId = 5 AND B.UserId = U.Id AND B.Name = "Nice Answer"
