
for benchmark in tpch; do
	for qid in 1; do
		for algo in fastfo conquer lincqa; do
			python3 rewriter.py -s benchmarks/${benchmark}/schemas.json -i benchmarks/${benchmark}/sqls/${qid}.sql -algo ${algo}
		done
	done
done
