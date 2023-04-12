import sys
sys.path.append("../../")

from src.fo_rewriter.FORewriter import *


class ConQuerRewriter(FORewriter):

	def __init__(self):
		print("initialized conquer rewriter")

	def rewrite_as_sql(self, cq):
		return ("TODO conquer sql")

	def rewrite_as_datalog(self, cq):
		return ("TODO conquer datalog")

	def is_rewritable(self, cq):
		return self.is_fo(cq)
		
