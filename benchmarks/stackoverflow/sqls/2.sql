SELECT DISTINCT Users.Id, Users.DisplayName
FROM Users, Badges
WHERE Users.Id = Badges.UserId AND Badges.name = "Illuminator"
