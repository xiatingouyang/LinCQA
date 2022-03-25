mkdir synthetic/results

for rewriting in sqls conquer lincqa-sql; do
        mode=size
        for scale in 100 500 1000 5000; do
                for qid in 15 16 17 18 19 20 21; do
                        for it in {1..3}; do
                                { time sqlcmd -S localhost -U sa -P cqa2022! -d ${mode}${scale}_${qid} -i synthetic/${rewriting}/${qid}.sql > output ; } 2>> synthetic/results/${mode}${scale}_${rewriting}_${qid}.txt
                        done
                done
        done

        mode=incon
        for scale in 10 30 50 70 90 100; do
                for qid in 15 16 17 18 19 20 21; do
                        for it in {1..3}; do
                                { time sqlcmd -S localhost -U sa -P cqa2022! -d ${mode}${scale}_${qid} -i synthetic/${rewriting}/${qid}.sql > output ; } 2>> synthetic/results/${mode}${scale}_${rewriting}_${qid}.txt
                        done
                done
        done
done 
