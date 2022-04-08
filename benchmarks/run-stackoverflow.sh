mkdir stackoverflow/results

for rewriting in sqls lincqa/view lincqa/materialize conquer fastfo; do
        for qid in 2 6 8 9 10; do
                for it in {1..6}; do
                        { timeout 10m sqlcmd -S localhost -U sa -P cqa2022! -d StackOverflow -i stackoverflow/${rewriting}/${qid}.sql > output ; } 2>> stackoverflow/results/${rewriting}_${qid}.txt
                done
        done   
done 
