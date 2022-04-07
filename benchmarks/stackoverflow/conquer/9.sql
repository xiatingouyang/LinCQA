WITH Candidates_Users_Badges AS (
        SELECT DISTINCT Users.Id, Badges.Name, Badges.UserId, Badges.Date, Users.DisplayName FROM Users, Badges WHERE Badges.UserId = Users.Id AND Badges.name = "Illuminator"
), 
        Filter_Users_Badges AS (
                SELECT C.Id, C.Name, C.UserId, C.Date FROM Candidates_Users_Badges C GROUP BY C.Id, C.Name, C.UserId, C.Date HAVING COUNT(*) > 1
)
        SELECT DISTINCT Id, DisplayName FROM Candidates_Users_Badges C WHERE NOT EXISTS (SELECT * FROM Filter_Users_Badges F WHERE C.Id = F.Id AND C.Name = F.Name AND C.UserId = F.UserId AND C.Date = F.Date)
