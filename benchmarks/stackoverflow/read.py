import json

def produce_stack_full_schema():

	schema = {}

	file = open("stack_schema.txt", "r")

	line = file.readline()[:-1]

	while line :

		table = line
		line = file.readline()[:-1]
		attributes = line.split(",")		

		schema[table] = {}
		for attr in attributes:
			print(table, attr)
			data_type = input(">>> ")
			schema[table][attr] = data_type
		line = file.readline()[:-1]

	file.close()

	file = open("stack_final_schema.txt", "w")
	for table in schema:
		print(table, file = file)

		items = ["{} {}".format(attr, schema[table][attr]) for attr in schema[table]]
		line = ",".join(items)
		print(line, file = file)
	file.close()


def produce_schema_json():

	file = open("stackoverflow_schema.txt", "r")

	schema = {}
	line = file.readline()[:-1]

	while line:

		table = line
		line = file.readline()[:-1]
		attributes = line.split(",")	

		schema[table] = {}
		schema[table]["key"] = [-1]
		schema[table]["attributes"] = attributes

		line = file.readline()[:-1]

	file.close()
	string = json.dumps(schema)
	print(string)

if __name__ == "__main__":
	produce_schema_json()