for rewriting in sqls conquer lincqa-sql; do
        mode=size
        for scale in 100 500 1000 5000; do
                for qid in 15 16 17 18 19 20 21; do
                        sqlcmd -S localhost -U sa -P cqa2022! -d ${mode}${scale}_${qid} -i synthetic/${rewriting}/${qid}.sql
                done
        done

        mode=incon
        for scale in 10 30 50 70 90 100; do
                for qid in 15 16 17 18 19 20 21; do
                        sqlcmd -S localhost -U sa -P cqa2022! -d ${mode}${scale}_${qid} -i synthetic/${rewriting}/${qid}.sql
                done
        done
done 
