SELECT DISTINCT Posts.id, Posts.title 
FROM Posts, Votes
WHERE Posts.Id = Votes.PostId AND Posts.OwnerUserId = Votes.UserId AND Votes.BountyAmount > 100
