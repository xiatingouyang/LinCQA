


        select V.PostId, V.UserId
        into Votes_good_join
        from Votes V
        join candidates C on V.PostId = C.PostId and V.UserId = C.UserId and V.CreationDate = C.CreationDate
        where not exists (
                select *
                from Votes_bad_key
                where
                V.PostId = Votes_bad_key.PostId and
                V.UserId = Votes_bad_key.UserId and
                V.CreationDate = Votes_bad_key.CreationDate
        )


