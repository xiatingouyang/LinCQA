for rewriting in sqls conquer lincqa-sqls; do
	for scale in 1 10; do
	       for qid in 1 2 3 4 6 10 11 12 14 16 17 18 20 21; do
	                sqlcmd -S localhost -U sa -P cqa2021! -d tpch${scale} -i tpch/${rewriting}/${qid}.sql
	        done
	done

done
