SELECT P.Title
FROM Posts P, PostLinks PL, PostHistory PH
WHERE P.PostId = PL.PostId AND  PL.PostId = PH.PostId AND PH.PostHistoryTypeId = 5 AND P.AnswerCount >= 50
