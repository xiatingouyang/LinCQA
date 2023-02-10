
# python3 rewriter.py -s benchmarks/tpch/schemas.json -i benchmarks/tpch/sqls/10.sql -algo lincqa
		
# for benchmark in synthetic; do
# 	for qid in {15..21}; do
# 		for algo in fastfo conquer lincqa; do
# 			python3 rewriter.py -s benchmarks/${benchmark}/schemas.json -i benchmarks/${benchmark}/sqls/${qid}.sql -algo ${algo}
# 		done
# 	done
# done


for benchmark in tpch; do
	for qid in 1 2 3 4 6 10 11 12 14 16 17 18 20 21; do
		for algo in fastfo conquer lincqa; do
			python3 rewriter.py -s benchmarks/${benchmark}/schemas.json -i benchmarks/${benchmark}/sqls/${qid}.sql -algo ${algo}
		done
	done
done


# for benchmark in stackoverflow; do
# 	for qid in {1..5}; do
# 		for algo in fastfo conquer lincqa; do
# 			python3 rewriter.py -s benchmarks/${benchmark}/schemas.json -i benchmarks/${benchmark}/sqls/${qid}.sql -algo ${algo}
# 		done
# 	done
# done
