import sys

def main():

	input_filename = sys.argv[1]

	file = open(input_filename, "r")

	line = file.readline()[:-1]

	while line != "":

		entries = line.split('","')

		new_entries = []
		for entry in entries:
			new_entry = entry.replace('"', "")
			new_entries.append(new_entry)

		new_line = '","'.join(new_entries)
		print('"{}"'.format(new_line))

		line = file.readline()[:-1]

	file.close()

if __name__ == "__main__":
	main()
