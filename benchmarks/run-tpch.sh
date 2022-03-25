mkdir tpch/results

for rewriting in sqls conquer lincqa-sql; do
	for scale in 1 10; do
	       for qid in 1 2 3 4 6 10 11 12 14 16 17 18 20 21; do
	       		for it in {1..3}; do
                        { time sqlcmd -S localhost -U sa -P cqa2022! -d tpch_${scale} -i tpch/${rewriting}/${qid}.sql > output ; } 2>> tpch/results/${scale}_${rewriting}_${qid}.txt
                done
	        done
	done

done
