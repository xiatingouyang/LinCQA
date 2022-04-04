SELECT U.DisplayName
FROM Users U, Posts P, PostHistory PH, Votes V, Comments C
WHERE U.UserId = C.UserId AND C.UserId = PH.UserId AND PH.UserId = V.UserId AND U.UserId = P.OwnerUserId AND U.DisplayName = PH.UserDisplayName AND P.Id = PH.PostId AND PH.PostId = C.PostId AND C.PostId = V.PostId AND FavoriteCount >= 100 AND PH.PostHistoryTypeId = 5
