mkdir tmp
for qid in 2 6 8 9 10; do
	mv ${qid}.sql tmp/${qid}.sql
done

cp tmp/10.sql 1.sql
cp tmp/9.sql 2.sql
cp tmp/2.sql 3.sql
cp tmp/8.sql 4.sql
cp tmp/6.sql 5.sql
