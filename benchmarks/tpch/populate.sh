wget http://pages.cs.wisc.edu/~xouyang/programs/tpch_data.zip
unzip tpch_data.zip
python3 ../bulk-populate.py schemas.json dbinfo.json