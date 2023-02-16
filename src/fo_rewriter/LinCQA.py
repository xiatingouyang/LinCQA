import sys
sys.path.append("../../")

from src.fo_rewriter.FORewriter import *
from src.conjunctive_query.ConjunctiveQuery import *


class LinCQARewriter(FORewriter):

	def __init__(self):
		print("initialized LinCQA rewriter")

	def rewrite_as_datalog(self, cq):
		return ("TODO lincqa datalog")

	



	def rewrite_as_sql(self, cq):
		if not self.is_rewritable(cq):
			print("LinCQA not applicable - not in PPJT")
			return None
		
		ret_sql = "hahahahaah"

		
		return ret_sql


	def is_rewritable(self, cq):
		if not self.is_fo(cq):
			return False
		return True

