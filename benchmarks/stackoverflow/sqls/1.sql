SELECT U.DisplayName
FROM Users_sample U, Posts_sample P, Votes_sample V, Comments_sample C
WHERE U.Id = P.OwnerUserId AND U.Id = V.UserId AND U.Id = C.UserId
AND C.PostId = P.Id and C.PostId = V.PostId
