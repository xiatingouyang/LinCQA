import json


class Schema:

	def __init__(self, schema_dir_str):
		file = open(schema_dir_str)
		self.schema = json.load(file)

