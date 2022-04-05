SELECT U.DisplayName
FROM Users_sample U, Posts_sample P, PostHistory_sample PH, Votes_sample V, Comments_sample C, Badges_sample B
WHERE U.Id = C.UserId AND C.UserId = PH.UserId AND PH.UserId = V.UserId AND U.Id = P.OwnerUserId AND U.DisplayName = PH.UserDisplayName AND P.Id = PH.PostId AND PH.PostId = C.PostId AND C.PostId = V.PostId AND PH.PostHistoryTypeId = 5 AND B.UserId = U.Id AND B.Name = "Nice Answer"

