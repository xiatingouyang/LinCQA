import sys

def main():

	input_filename = sys.argv[1]

	file = open(input_filename, "r", errors='ignore')

	line = file.readline()[-1]
	col_num = len(line.split('","'))
	while line != "":

		entries = line.split('","')

		new_entries = []
		for entry in entries:
			new_entry = entry.replace('"', "")
			new_entries.append(new_entry)

		if len(new_entries) == col_num:
			new_line = '","'.join(new_entries)
			print('"{}"'.format(new_line))

		line = file.readline()[-1]
		

	file.close()

if __name__ == "__main__":
	main()
