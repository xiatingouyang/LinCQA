mkdir dblp/results

for rewriting in sqls; do
       
        for qid in 1 2 3 4 5; do
                for it in {1..3}; do
                        { time sqlcmd -S localhost -U sa -P cqa2022! -d dblp -i dblp/${rewriting}/${qid}.sql > output ; } 2>> dblp/results/${rewriting}_${qid}.txt
                done
        done
        
done 
