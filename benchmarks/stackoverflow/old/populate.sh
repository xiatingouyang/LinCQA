wget http://pages.cs.wisc.edu/~xouyang/programs/parsed.zip
unzip parsed.zip
mkdir data
mv parsed/*.csv data 
sqlcmd -S localhost -U sa -P cqa2022! -i create_db.sql
python3 ../bulk-populate.py schemas.json dbinfo.json
