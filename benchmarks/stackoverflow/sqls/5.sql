Select DISTINCT Posts.Id, Posts.Title
FROM Posts, PostHistory, Votes, Comments
WHERE Posts.Tags LIKE "%SQL%" AND Posts.id = PostHistory.PostId AND Posts.id = Comments.PostId AND Posts.id = Votes.PostId AND Votes.BountyAmount > 100 AND PostHistory.PostHistoryTypeId = 2 AND Comments.score = 0
