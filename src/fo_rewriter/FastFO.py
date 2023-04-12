import sys
sys.path.append("../../")

from src.fo_rewriter.FORewriter import *


class FastFORewriter(FORewriter):

	def __init__(self):
		print("initialized fastfo rewriter")

	def rewrite_as_sql(self, cq):
		return ("TODO: fastfo as sql")

	def rewrite_as_datalog(self, cq):
		return ("TODO: fastfo as datalog")


	def is_rewritable(self, cq):
		return self.is_fo(cq)
		
