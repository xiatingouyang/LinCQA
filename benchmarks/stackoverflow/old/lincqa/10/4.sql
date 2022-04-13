

       select P.Id, P.Title
       into Posts_good_join
       from Posts P
       join candidates C on P.Id = C.Id and P.Title = C.Title
       where not exists (
            select * 
            from Posts_bad_key
            where P.Id = Posts_bad_key.Id 
       )


