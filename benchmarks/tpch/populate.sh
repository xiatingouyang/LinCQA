wget http://pages.cs.wisc.edu/~xouyang/programs/tpch_data.zip
unzip tpch_data.zip
sqlcmd -S localhost -U sa -P cqa2022! -i create_db.sql
python3 ../bulk-populate.py schemas.json dbinfo.json
