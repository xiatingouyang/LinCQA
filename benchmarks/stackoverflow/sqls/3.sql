SELECT DISTINCT Users.DisplayName
FROM Users, Posts
WHERE Users.Id = Posts.OwnerUserId AND Posts.Tags LIKE "<c++>"
