SELECT DISTINCT Users.Id, Users.DisplayName
FROM Users, Posts, Comments
WHERE Comments.UserId = Users.Id AND Comments.PostId = Posts.Id AND Posts.Tags LIKE "%SQL%" AND Comments.Score > 5
