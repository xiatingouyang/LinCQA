SELECT P.Title
FROM Posts_sample P, PostLinks_sample PL, PostHistory_sample PH
WHERE P.Id = PL.PostId AND  PL.PostId = PH.PostId AND PH.PostHistoryTypeId = 5 AND P.AnswerCount >= 50
