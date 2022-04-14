SELECT DISTINCT U.Id, U.DisplayName
FROM Users U, Badges B
WHERE U.Id = B.UserId AND B.name = "Illuminator"
