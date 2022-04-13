for table in Badges PostHistory Posts Users Comments PostLinks Tags Votes; do
	echo ${table} >> stack_schema.txt
	head -1 ${table}.csv >> stack_schema.txt
done