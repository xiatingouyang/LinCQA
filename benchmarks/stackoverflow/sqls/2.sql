SELECT DISTINCT U.DisplayName
FROM Users U, Posts P
WHERE U.Id = P.OwnerUserId AND P.Tags LIKE "<c++>"
