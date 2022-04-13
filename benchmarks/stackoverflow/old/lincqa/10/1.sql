
        select V.PostId, V.UserId, V.CreationDate 
        into Votes_bad_key
        from Votes V
        join candidates C on V.PostId = C.PostId and V.UserId = C.UserId and V.CreationDate = C.CreationDate
        where V.BountyAmount <= 100


