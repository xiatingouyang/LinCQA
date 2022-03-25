wget http://pages.cs.wisc.edu/~xouyang/programs/synthetic_data.zip
unzip synthetic_data.zip
sqlcmd -S localhost -U sa -P cqa2022! -i create_db.sql
python3 ../bulk-populate.py schemas.json dbinfo.json
