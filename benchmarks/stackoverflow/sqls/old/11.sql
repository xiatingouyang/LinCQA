select distinct U.DisplayName
from Users U, Comments C, Posts P 
where U.Id = C.UserId and C.PostId = P.Id and
P.FavoriteCount > 5 and
C.Score > 10 and 
U.Reputation > 20

