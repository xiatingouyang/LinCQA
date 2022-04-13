for table in Badges PostHistory PostLinks Tags Users Votes Comments Posts; do
echo ${table}
 ./parse ${table}.csv > parsed/${table}.csv
done
