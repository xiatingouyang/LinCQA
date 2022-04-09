import json

schema_location = "schemas.json"
dbinfo_location = "dbinfo.json"

f = open(schema_location)
schema = json.load(f)
dbinfo_f = open(dbinfo_location)
dbinfo = json.load(dbinfo_f)