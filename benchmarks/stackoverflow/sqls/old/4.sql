SELECT DISTINCT U.DisplayName
FROM Users U, Posts P, PostHistory PH, Votes V, Comments C
WHERE U.Id = C.UserId AND C.UserId = PH.UserId AND PH.UserId = V.UserId AND U.Id = P.OwnerUserId AND U.DisplayName = PH.UserDisplayName AND P.Id = PH.PostId AND PH.PostId = C.PostId AND C.PostId = V.PostId AND FavoriteCount >= 100 AND PH.PostHistoryTypeId = 5
