wget <put the url for data.zip here>
unzip data.zip
sqlcmd -S localhost -U sa -P cqa2022! -i create_db.sql
python3 ../bulk-populate.py schemas.json dbinfo.json
