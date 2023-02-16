SELECT DISTINCT Posts.id, Posts.title 
FROM Posts, Votes
WHERE Posts.Id = Votes.PostId AND Posts.OwnerUserId = Votes.UserId AND Posts.BountyAmount > 100
