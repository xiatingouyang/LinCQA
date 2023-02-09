import sys

from src.conjunctive_query.ConjunctiveQuery import *
from src.conjunctive_query.Schema import *
from src.fo_rewriter.FORewriter import *
from src.fo_rewriter.LinCQA import *
from src.fo_rewriter.ConQuer import *
from src.fo_rewriter.FastFO import *


def main():
	"""
		Usage: 
			python3 rewriter.py -s <dir_to_schema> -i <input_sql_dir> -algo <fastfo/lincqa/conquer> [-o <output_dir>] [-f <datalog/sql>]
	"""
	argc = len(sys.argv)
	if argc < 1:
		print("Too few arguments")

	schema_dir_str = ""
	input_sql_dir_str = ""
	algorithm = ""
	output_dir = ""
	is_rewrite_as_sql = True

	error_found = False

	for arg_index in range(1, argc):
		if sys.argv[arg_index] == "-s" and arg_index + 1 < argc:
			schema_dir_str = sys.argv[arg_index + 1]

		elif sys.argv[arg_index] == "-i" and arg_index + 1 < argc:
			input_sql_dir_str = sys.argv[arg_index + 1]

		elif sys.argv[arg_index] == "-algo" and arg_index + 1 < argc:
			if sys.argv[arg_index + 1] in ["lincqa", "fastfo", "conquer"]:
				algorithm = sys.argv[arg_index + 1]
			else:
				error_found = True

		elif sys.argv[arg_index] == "-o" and arg_index + 1 < argc:
			output_dir = sys.argv[arg_index + 1]

		elif sys.argv[arg_index] == "-f" and arg_index + 1 < argc:
			if sys.argv[arg_index + 1] == "sql":
				is_rewrite_as_sql = True
			elif sys.argv[arg_index + 1] == "datalog":
				is_rewrite_as_sql = False
			else:
				error_found = True

	if error_found or not schema_dir_str or not input_sql_dir_str or not algorithm:
		print("Not enough arguments") 

	schema = Schema(schema_dir_str)
	cq = ConjunctiveQuery(input_sql_dir_str, schema)

	if algorithm == "lincqa":
		rewriter = LinCQARewriter()
	elif algorithm == "fastfo":
		rewriter = FastFORewriter()
	elif algorithm == "conquer":
		rewriter = ConQuerRewriter()

	rewriter.rewrite(cq, is_rewrite_as_sql, output_dir)
	return



if __name__ == "__main__":
	main()
